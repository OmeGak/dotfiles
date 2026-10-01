#!/usr/bin/env python3
"""herdr tab-names: label every tab from its first (main) pane. stdlib only.

Usage: tab_names.py sync [--dry-run] [--snapshot FILE]
       tab_names.py watch    (background poll; normally started by sync)
"""
import fcntl
import hashlib
import json
import os
import re
import subprocess
import sys
import time
import unicodedata

MAX_LEN = 40
# herdr (0.9.x) shows an unlabelled tab as its 1-based position in the workspace
# ("3", renumbering as tabs close); the API has no default/custom flag, so a
# label equal to the tab's position counts as default. "shell" is legacy.
DEFAULT_LABELS = {"shell"}
GENERIC_TITLES = {"shell", "sh", "bash", "zsh", "fish", "claude code", "claude"}
SPINNERS = set("·✢✳✶✻✽✴✵")
HOST_PREFIX = re.compile(r"^\[[^\]]*\]")  # fish over ssh: "[host] cmd dir"
# herdr 0.9.1 sidebar glyphs, "symbols" style for the busy states (src/client/shell.rs
# status_icon). Colour is dropped, so distinct shapes keep the states apart.
STATUS_GLYPHS = {"working": "◐", "blocked": "×", "done": "✓", "idle": "○"}
# Every glyph any herdr style (dots or symbols) or an older plugin version
# ("·" for unknown) may have produced, for stripping.
KNOWN_GLYPHS = set(STATUS_GLYPHS.values()) | {"●", "·"}


def _is_decoration(ch):
    return (ch.isspace() or ch in SPINNERS or "⠀" <= ch <= "⣿"
            or (ch > "\x7f" and unicodedata.category(ch) in ("So", "Sk", "Sm")))


def clean_title(title):
    """Strip leading spinner/symbol chars and whitespace; collapse whitespace."""
    if not title:
        return ""
    i = 0
    while i < len(title) and _is_decoration(title[i]):
        i += 1
    t = re.sub(r"\s+", " ", title[i:]).strip()
    if not t or HOST_PREFIX.match(t) or t.lower() in GENERIC_TITLES:
        return ""
    return t


def truncate(s, n=MAX_LEN):
    return s if len(s) <= n else s[: n - 1].rstrip() + "…"


def cwd_label(cwd, home):
    if not cwd:
        return ""
    if home and os.path.normpath(cwd) == os.path.normpath(home):
        return "~"
    return os.path.basename(os.path.normpath(cwd)) or "/"


PANE_ALPHABET = "123456789ABCDEFGHJKMNPQRSTVWXYZ0"  # herdr 0.9.1 src/workspace.rs


def pane_number(pane_id):
    """Creation number from a public pane id like `w2:p3` / `w2:pG`, else None.

    herdr numbers panes per workspace with a monotonic counter, encoded in a
    bijective base-32 over PANE_ALPHABET; snapshot order is layout order, not
    creation order, so the number is the only creation signal.
    """
    m = re.search(r"(?:^|:)p([^:]+)$", pane_id or "")
    if not m:
        return None
    n = 0
    for ch in m.group(1):
        d = PANE_ALPHABET.find(ch)
        if d < 0:
            return None
        n = n * len(PANE_ALPHABET) + d + 1
    return n


def pick_pane(panes):
    """The tab's main pane: the earliest-created live pane (lowest pane number).

    Ids that do not parse sort last; ties keep snapshot order.
    """
    if not panes:
        return None
    return min(panes, key=lambda p: (pane_number(p.get("pane_id")) is None,
                                     pane_number(p.get("pane_id")) or 0))


def compute_label(pane, home):
    title = clean_title(pane.get("terminal_title_stripped") or pane.get("terminal_title"))
    label = title or cwd_label(pane.get("foreground_cwd") or pane.get("cwd"), home)
    return label


def status_glyph(status):
    """Glyph for an agent status; "" (no glyph) for unknown or missing."""
    return STATUS_GLYPHS.get(status or "", "")


def strip_glyph(label):
    """Drop one leading known status glyph plus the space after it."""
    if label and len(label) > 1 and label[0] in KNOWN_GLYPHS and label[1] == " ":
        return label[2:]
    return label


# current ` · 2` style plus legacy ` ²` (superscript) and ` ⊞2` styles
# plus the trailing ` ·` zoom marker (herdr appends ` Z` to a zoomed tab's label), alone or after the count
COUNT_SUFFIX = re.compile(r"(?: (?:· \d+|[⁰¹²³⁴⁵⁶⁷⁸⁹]+|⊞\d+)(?: ·)?| ·)$")


def strip_label(label):
    """Drop the plugin's decorations: one leading status glyph and a trailing pane-count suffix (` · N`, or legacy superscript / ` ⊞N`) and/or zoom marker (` ·`)."""
    return COUNT_SUFFIX.sub("", strip_glyph(label or ""))


def build_label(name, glyph, pane_count, zoomed=False):
    """`[<glyph> ]<name>[ · N][ ·]` (trailing ` ·` when zoomed, so herdr shows `· Z`); the name is truncated first so the suffix survives."""
    label = truncate(name)
    if glyph:
        label = f"{glyph} {label}"
    if pane_count > 1:
        label += f" · {pane_count}"
    if zoomed:
        label += " ·"
    return label


def is_replaceable(current, pane, last_set, position=None):
    c = (current or "").strip()
    if not c or c.lower() in DEFAULT_LABELS:
        return True
    if position is not None and c == str(position):
        return True
    agent = pane.get("agent")
    if agent and c.lower() == agent.lower():
        return True
    # last_set may carry an older glyph/count (or none, from older versions)
    return last_set is not None and strip_label(c) == strip_label(last_set)


def zoomed_pane(layout, panes):
    """The tab's zoomed pane, or None.

    While a layout is zoomed, its `focused_pane_id` is the zoomed pane (herdr
    0.9.1 `apply_pane_zoom` focuses the target before zooming). Must be one of
    the tab's own panes, else None.
    """
    if not layout or not layout.get("zoomed"):
        return None
    fid = layout.get("focused_pane_id")
    return next((p for p in panes if p.get("pane_id") == fid), None) if fid else None


def plan(snapshot, state, home):
    """Return list of (tab_id, current, new) renames."""
    layouts = {l.get("tab_id"): l for l in snapshot.get("layouts") or []}
    by_tab = {}
    for p in snapshot.get("panes", []):
        by_tab.setdefault(p.get("tab_id"), []).append(p)
    out = []
    seen = {}  # workspace_id -> tabs so far; snapshot order is display order
    for t in snapshot.get("tabs", []):
        ws = t.get("workspace_id")
        seen[ws] = position = seen.get(ws, 0) + 1
        tab_panes = by_tab.get(t["tab_id"], [])
        pane = zoomed_pane(layouts.get(t["tab_id"]), tab_panes) or pick_pane(tab_panes)
        if not pane:
            continue
        name = compute_label(pane, home)
        cur = t.get("label", "")
        if not name:
            continue
        count = t.get("pane_count") or len(by_tab.get(t["tab_id"], []))
        zoomed = bool((layouts.get(t["tab_id"]) or {}).get("zoomed"))
        new = build_label(name, status_glyph(t.get("agent_status")), count, zoomed)
        if new == cur:
            continue
        if is_replaceable(cur, pane, state.get(t["tab_id"]), position):
            out.append((t["tab_id"], cur, new))
    return out


def plan_panes(snapshot, state):
    """Return list of (pane_id, current, new) pane-label renames.

    Only panes with an agent: label = `[<glyph> ]<cleaned title>` (the pane's
    own agent_status glyph, no count). No usable title: untouched. Manual
    labels are left alone.
    """
    out = []
    for p in snapshot.get("panes", []):
        if not p.get("agent"):
            continue
        name = truncate(clean_title(p.get("terminal_title_stripped") or p.get("terminal_title")))
        if not name:
            continue
        new = build_label(name, status_glyph(p.get("agent_status")), 1)
        cur = p.get("label", "")  # absent from the snapshot when unset
        if new == cur:
            continue
        if is_replaceable(cur, p, state.get(p["pane_id"])):
            out.append((p["pane_id"], cur, new))
    return out


TABS_TOKEN = "tabs"
LEGACY_TOKEN = "title"  # old combined name+count token, cleared once per workspace per server epoch
TABS_SOURCE = "tab-names"


def tabs_value(tab_count):
    """Workspace `$tabs` token: plain tab count when N > 1, else "" (no token)."""
    if tab_count and tab_count > 1:
        return str(tab_count)
    return ""


def plan_tabs(snapshot, reported):
    """Return list of (workspace_id, value) `tabs` reports to make; "" means clear.

    `reported` maps workspace_id -> value last reported (absent = nothing set).
    Only changes are returned; herdr keeps the metadata itself.
    """
    out = []
    for w in snapshot.get("workspaces", []):
        wid = w.get("workspace_id")
        if not wid:
            continue
        want = tabs_value(w.get("tab_count"))
        if want != reported.get(wid, ""):
            out.append((wid, want))
    return out


def server_epoch(sock=None):
    """Changes when the herdr server restarts (its socket is recreated); herdr
    keeps metadata in memory only, so a restart invalidates what we reported."""
    if sock is None:
        sock = os.environ.get("HERDR_SOCKET_PATH", "")
    try:
        return os.stat(sock).st_mtime_ns
    except OSError:
        return 0


def session_key(sock=None):
    """Short hash of the herdr socket path: tab ids collide across sessions."""
    if sock is None:
        sock = os.environ.get("HERDR_SOCKET_PATH", "")
    return hashlib.sha1(sock.encode()).hexdigest()[:8]


def run_herdr(*args):
    binary = os.environ.get("HERDR_BIN_PATH") or "herdr"
    return subprocess.run([binary, *args], capture_output=True, text=True,
                          encoding="utf-8", errors="replace", timeout=15)


def get_snapshot():
    r = run_herdr("api", "snapshot")
    if r.returncode != 0:
        raise RuntimeError(f"herdr api snapshot exited {r.returncode}: {r.stderr.strip()}")
    return json.loads(r.stdout)["result"]["snapshot"]


def load_state(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (OSError, ValueError):
        return {}


def save_state(path, state):
    tmp = path + ".tmp"
    with open(tmp, "w") as f:
        json.dump(state, f)
    os.replace(tmp, path)


def sync_tabs(tabs_path, snap, dry_run=False):
    """Report the `tabs` workspace metadata token where the tab count changed."""
    epoch = server_epoch()
    st = load_state(tabs_path)
    fresh = st.get("epoch") == epoch
    reported = st.get("values", {}) if fresh else {}
    cleared = set(st.get("cleared", [])) if fresh else set()
    changes = plan_tabs(snap, reported)
    live = {w.get("workspace_id") for w in snap.get("workspaces", []) if w.get("workspace_id")}
    values = {k: v for k, v in reported.items() if k in live}
    # herdr's CLI wants the workspace id first (a trailing positional is misparsed)
    base = lambda wid: ["workspace", "report-metadata", wid, "--source", TABS_SOURCE]
    if not dry_run:
        for wid in sorted(live - cleared):  # once per epoch: drop the old `title` token
            if run_herdr(*base(wid), "--clear-token", LEGACY_TOKEN).returncode == 0:
                cleared.add(wid)
    for wid, value in changes:
        if dry_run:
            print(f"{wid}: tabs -> {value!r}")
            continue
        arg = ["--token", f"{TABS_TOKEN}={value}"] if value else ["--clear-token", TABS_TOKEN]
        if run_herdr(*base(wid), *arg).returncode == 0:
            if value:
                values[wid] = value
            else:
                values.pop(wid, None)
    new = {"epoch": epoch, "values": values, "cleared": sorted(cleared & live)}
    if not dry_run and new != st:
        save_state(tabs_path, new)  # only on change: the poll runs every 3 s
    return changes


def sync_once(state_path, dry_run=False, snapshot=None):
    snap = snapshot or get_snapshot()
    sync_tabs(os.path.splitext(state_path)[0] + "-tabs.json", snap, dry_run)
    state = load_state(state_path)
    renames = plan(snap, state, os.path.expanduser("~"))
    live = {t["tab_id"] for t in snap.get("tabs", [])}
    for tab_id, cur, new in renames:
        if dry_run:
            print(f"{tab_id}: {cur!r} -> {new!r}")
            continue
        if run_herdr("tab", "rename", tab_id, new).returncode == 0:
            state[tab_id] = new
            save_state(state_path, state)  # record now: a crash must not look manual
    pruned = {k: v for k, v in state.items() if k in live}
    if not dry_run and len(pruned) != len(state):
        save_state(state_path, pruned)  # prune only on change: the poll runs every 3 s
    sync_panes(os.path.splitext(state_path)[0] + "-panes.json", snap, dry_run)
    return renames


def sync_panes(path, snap, dry_run=False):
    """Set agent panes' labels to their cleaned title (herdr `pane rename`)."""
    state = load_state(path)
    renames = plan_panes(snap, state)
    for pane_id, cur, new in renames:
        if dry_run:
            print(f"{pane_id}: pane label {cur!r} -> {new!r}")
        elif run_herdr("pane", "rename", pane_id, new).returncode == 0:
            state[pane_id] = new
            save_state(path, state)  # record now: a crash must not look manual
    live = {p["pane_id"] for p in snap.get("panes", [])}
    pruned = {k: v for k, v in state.items() if k in live}
    if not dry_run and len(pruned) != len(state):
        save_state(path, pruned)
    return renames


def locked_sync(state_path, lock, rerun, sync=sync_once):
    """Run `sync` under the session lock, again while the rerun flag is set.

    Returns False when another process holds the lock (it will see the flag).
    Exceptions propagate, after unlocking.
    """
    for _ in range(20):
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except OSError:
            return False
        try:
            os.remove(rerun)
        except OSError:
            pass
        try:
            sync(state_path)
        finally:
            fcntl.flock(lock, fcntl.LOCK_UN)
        if not os.path.exists(rerun):
            break
    return True


# --- background poll -------------------------------------------------------
# herdr fires no event for terminal title changes (e.g. Claude Code's /rename),
# so one long-lived watcher per herdr session re-syncs every POLL_SECONDS.
POLL_SECONDS = 3.0
MAX_FAILURES = 5  # consecutive failed ticks before assuming the server is gone
SCRIPT = os.path.realpath(__file__)
try:
    SCRIPT_MTIME = os.stat(SCRIPT).st_mtime_ns  # at import: the code actually running
except OSError:
    SCRIPT_MTIME = 0
LOCK_RETRIES = 5  # watcher lock attempts, LOCK_RETRY_DELAY apart
LOCK_RETRY_DELAY = 0.1


def watcher_identity():
    """What a watcher started now would run: code path + version, herdr binary."""
    return {"script": SCRIPT, "mtime": SCRIPT_MTIME,
            "bin": os.environ.get("HERDR_BIN_PATH") or ""}


def watcher_action(lock_free, wanted, me, disabled):
    """Decide what `sync` does about the watcher.

    "spawn": none runs; "retarget": one runs other code or binary (re-link,
    edit, herdr upgrade), so record ours and it re-execs; "none" otherwise.
    """
    if disabled:
        return "none"
    if lock_free:
        return "spawn"
    return "none" if wanted == me else "retarget"


def watch_loop(tick, check, sleep, interval=POLL_SECONDS, max_failures=MAX_FAILURES):
    """Tick every `interval` s until check() gives a reason or ticks keep failing.

    check() returns None to go on, or a reason string to stop. Returns the reason.
    """
    failures = 0
    while True:
        try:
            reason = check()
        except Exception:
            reason = None
            failures += 1
            if failures >= max_failures:
                return "failures"
            sleep(interval)
            continue
        if reason:
            return reason
        try:
            tick()
            failures = 0
        except Exception:
            failures += 1
            if failures >= max_failures:
                return "failures"
        sleep(interval)


def watch_check(sock, disabled_path, wanted_path, me):
    if sock and not os.path.exists(sock):
        return "socket gone"
    if os.path.exists(disabled_path):
        return "disabled"
    wanted = load_state(wanted_path)
    if wanted and wanted != me:
        return "retarget"
    return None


def paths(state_dir, key):
    j = lambda name: os.path.join(state_dir, name)
    return {"state": j(f"labels-{key}.json"), "lock": j(f"lock-{key}"),
            "rerun": j(f"rerun-{key}"), "watch_lock": j(f"watch-lock-{key}"),
            "watcher": j(f"watcher-{key}.json"), "disabled": j("no-watch")}


def spawn_watcher():
    """Start `tab_names.py watch` fully detached: own session, stdio on /dev/null.

    herdr waits for every plugin command and reads its stdout/stderr to EOF
    (holding one of 32 in-flight slots meanwhile), so the watcher must neither
    be herdr's direct child nor inherit those pipes. The parent `sync` exits
    right away, so launchd/init adopts and reaps the watcher.
    """
    subprocess.Popen([sys.executable, SCRIPT, "watch"], cwd=os.path.dirname(SCRIPT),
                     stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                     stderr=subprocess.DEVNULL, start_new_session=True, close_fds=True)


def ensure_watcher(p):
    with open(p["watch_lock"], "a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            fcntl.flock(lock, fcntl.LOCK_UN)
            free = True
        except OSError:
            free = False
    me = watcher_identity()
    act = watcher_action(free, load_state(p["watcher"]), me, os.path.exists(p["disabled"]))
    if act == "spawn":
        spawn_watcher()
    elif act == "retarget":
        save_state(p["watcher"], me)


def watch(p):
    """The poll loop. Exactly one per session: holds the watch lock until exit."""
    lock = open(p["watch_lock"], "a")
    for attempt in range(LOCK_RETRIES):  # a sync's probe may briefly hold it
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            break
        except OSError:
            if attempt == LOCK_RETRIES - 1:
                return 0  # another watcher runs
            time.sleep(LOCK_RETRY_DELAY)
    me = watcher_identity()
    save_state(p["watcher"], me)  # claim: we are the current code
    sync_lock = open(p["lock"], "w")
    reason = watch_loop(
        tick=lambda: locked_sync(p["state"], sync_lock, p["rerun"]),
        check=lambda: watch_check(os.environ.get("HERDR_SOCKET_PATH", ""),
                                  p["disabled"], p["watcher"], me),
        sleep=time.sleep)
    if reason == "retarget":
        wanted = load_state(p["watcher"])
        lock.close()  # release, so the new code can take it
        sync_lock.close()
        if isinstance(wanted, dict) and wanted.get("script"):
            os.environ["HERDR_BIN_PATH"] = wanted.get("bin", "")
            try:
                os.execv(sys.executable, [sys.executable, wanted["script"], "watch"])
            except OSError:
                pass
    return 0


def main(argv):
    args = argv[1:]
    if not args or args[0] not in ("sync", "watch"):
        print(__doc__)
        return 2
    dry = "--dry-run" in args
    snap = None
    if "--snapshot" in args:
        with open(args[args.index("--snapshot") + 1]) as f:
            data = json.load(f)
        snap = data.get("result", data)
        snap = snap.get("snapshot", snap)
    state_dir = os.environ.get("HERDR_PLUGIN_STATE_DIR") or os.path.join(
        os.path.expanduser("~"), ".cache", "herdr-tab-names")
    os.makedirs(state_dir, exist_ok=True)
    p = paths(state_dir, session_key())
    if args[0] == "watch":
        return watch(p)
    if dry:
        sync_once(p["state"], True, snap)
        return 0
    if os.environ.get("HERDR_SOCKET_PATH") and os.environ.get("HERDR_PLUGIN_STATE_DIR"):  # plugin command under a herdr server
        try:
            ensure_watcher(p)  # self-healing: every sync (re)starts the poll if needed
        except Exception as e:
            print(f"tab-names: watcher: {e}", file=sys.stderr)
    # Coalesce bursts: one runner at a time. A contender sets the rerun flag
    # BEFORE trying the lock, so the holder's post-unlock check cannot miss it.
    open(p["rerun"], "w").close()
    try:
        with open(p["lock"], "w") as lock:
            locked_sync(p["state"], lock, p["rerun"])
    except Exception as e:  # never fail a hook loudly
        print(f"tab-names: {e}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
