# tab-names

A herdr plugin that labels every tab after what runs in it. Python 3 stdlib
only; talks to herdr through `$HERDR_BIN_PATH` (fallback `herdr`).

## Naming rule

Per tab, the name comes from its first ("main") pane: the earliest-created
pane still alive. Secondary panes are side tasks and never affect the name, busy
or focused. One exception: while the tab is zoomed (snapshot `layouts[]` entry
with `zoomed: true`), the name comes from the zoomed pane instead, which herdr
0.9.1 reports as that layout's `focused_pane_id` (if it is not among the tab's
panes, the main pane is used). Unzooming returns to the main pane. herdr has no
plugin event for zoom toggles, so the change is picked up by the 3 s watcher. herdr's snapshot lists panes in layout order, not creation order, so
creation order is taken from the pane id: herdr numbers panes per workspace with a
monotonic counter, encoded in bijective base 32 over `123456789ABCDEFGHJKMNPQRSTVWXYZ0`
(`w2:p3` < `w2:p9` < `w2:pA` < `w2:pG` < `w2:p11`), and the lowest number wins. Ids
that do not parse sort last. The status glyph is unaffected: it is the tab-level
`agent_status`, which herdr sets to the most urgent state across all panes.

Label = the pane's terminal title, cleaned (leading spinner/symbol glyphs such
as Claude Code's and whitespace stripped, so `.dotfiles` and `(wip) x` are kept;
whitespace collapsed). Ignored as no title: empty, `Claude Code`, bare shell
names, and fish-over-ssh style `[host] ...` titles. Fallback = basename of the
pane's cwd (`~` for `$HOME`). Truncated to 40 chars with `…`.

Status glyph: with an agent the label is `<glyph> <name>`, using herdr's own sidebar glyphs
("symbols" style for the busy states, herdr 0.9.1 `src/client/shell.rs`
`status_icon`) for the tab's `agent_status`: `◐` working, `×` blocked, `✓` done,
`○` idle. Tabs whose status is unknown or missing (no agent) get no glyph: the
label is just `<name>`. Labels are plain text, so herdr's colours are
lost, but the distinct shapes keep the states apart. A glyph change alone renames the tab. The guard strips
one leading known glyph (and its space, including the legacy `·` and `●`)
from the current label and the remembered one before comparing, so previously
set labels stay recognised and an old `· name` is renamed to `name`.

Pane count: a tab with more than one pane gets ` · N` (space, middle dot, space, plain number) appended, N being the
tab's `pane_count` (fallback: the snapshot panes with that `tab_id`). The label
format is `[<glyph> ]<name>[ · <N>]`, e.g. `◐ api-refactor · 3`, `.dotfiles · 2`, `build · 12`. The
name is truncated before the glyph and suffix are added, so the suffix always
survives. A count change alone renames the tab. The guard also strips a
trailing ` · <digits>` or the legacy ` <superscript digits>` / ` ⊞<digits>` (with the leading glyph) before comparing, so older
labels without a suffix are still recognised.

Zoom marker: herdr's tab bar appends ` Z` to a zoomed tab's label (0.9.1
`tab_label`), which would otherwise read `name · 2 Z`. While the tab's layout is
zoomed the plugin ends the label with ` ·` (after the count suffix, if any), so
the bar shows `◐ name · 2 · Z` or `name · Z`. Pane labels never get it. The
guard also strips this trailing ` ·` (alone or after ` · N`), so zoom toggles
are recognised as ours; a name ending in `·` without the leading space is kept.

Manual-rename guard: the plugin remembers the last label it set per tab (in
`$HERDR_PLUGIN_STATE_DIR/labels-<session hash>.json`, keyed by a hash of
`HERDR_SOCKET_PATH` because tab ids collide across herdr sessions). It only
renames a tab whose current label is empty, `shell`, herdr's default (the tab's
1-based position in its workspace, e.g. `3` for the third tab; herdr renumbers
it as tabs close and the API has no default/custom flag), the pane's agent name
(e.g. `claude`), or the label it set last (ignoring its leading glyph and trailing count suffix). Anything else is treated as manual
and left alone. Workspace labels are never touched (see Workspace tab count).

herdr does report `terminal_title` for plain shell panes (checked live), so the
shell hooks matter: zsh sets the title to the cwd basename at the prompt and to
the command name (no arguments) while it runs.

## Pane labels

Every pane with an agent (`agent` set, e.g. `claude`) also gets a pane label,
shown on its border by herdr 0.9.1 (borders exist only when a tab has more than
one pane). The label is the cleaned terminal title (`clean_title`, truncated to
40 chars) prefixed with the pane's own `agent_status` glyph like tab labels
(`◐ ` working, `× ` blocked, `✓ ` done, `○ ` idle, none for unknown/missing; no
count suffix), set with `herdr pane rename <pane_id> <label>`.
Empty cleaned title: nothing is done. Panes without an agent are untouched.
herdr's snapshot exposes a set label as pane field `label` (absent when unset);
`herdr pane rename <pane_id> --clear` removes it (the plugin never clears).
Same guard as tabs: a label is replaced only if empty, equal to the agent name,
or equal to the one the plugin set last (`labels-<session hash>-panes.json`,
pane id to label, pruned to live panes, written only on change). Renames happen
only on change, via the same events and 3 s watcher as tabs.

## Workspace tab count

The workspace (Space) sidebar row shows herdr's native `workspace` name plus a
tab count when it has more than one tab (e.g. `.dotfiles · 3`).
herdr joins row tokens with ` · `, so that separator is fixed. The count uses
herdr's native display-only workspace metadata, not the label: each sync reports
token `tabs` per workspace via `herdr workspace report-metadata <workspace_id>
--source tab-names --token tabs=<count>` (id first: herdr's CLI misparses a
trailing positional), or `--clear-token tabs` when the count drops to 1. Nothing
renames the workspace. Reports are made only on change (so a tab count change is
picked up by the 3 s watcher), remembered in
`labels-<session hash>-tabs.json` (with the herdr socket's mtime as a server
epoch, since herdr keeps metadata in memory and a restart forgets it). The first
pass per workspace per epoch also clears the old combined `title` token.

Display needs a Space row template referencing `$tabs`, in
`~/.config/herdr/config.toml` (herdr docs, "Sidebar row layouts"):

    [ui.sidebar.spaces]
    rows = [["state_icon", "workspace", "$tabs"], ["branch", "git_status"]]

Apply with `herdr server reload-config`. Machines without the plugin (remote
herdr servers) just show the name with no count.

## How it stays fresh

herdr has no terminal-title-changed or cd event. The plugin syncs on startup and
on tab/pane created, focused, closed, exited, moved, agent detected and agent
status changed (the latter refreshes agent titles). `tab.renamed` is not
subscribed, so there is no feedback loop. Concurrent invocations coalesce via a
lock plus a rerun flag. A background poll (below) catches the rest. Shell hooks call the `sync` action after each prompt:
zsh via `zsh/herdr.rc.zsh` in this repo, fish via `fish/tab-names.fish`. The fish
snippet (active only when `HERDR_ENV=1`) also overrides `fish_title`, because
fish 4.x's default emits `[host] cmd ~/c/dir` over ssh; the override gives the
command name while running and the cwd basename at an idle prompt.

## Background poll

Some label changes fire no herdr event at all: a program retitling its terminal
without an agent status change (Claude Code's `/rename`, a long-running
command updating its title). So one long-lived watcher per herdr server
(`python3 tab_names.py watch`) re-syncs every 3 s: it takes one `herdr api
snapshot`, plans in-process, and calls `herdr tab rename` only for tabs whose label
changed. It shares the event hooks' lock and rerun flag, so it never races them
(if an event sync holds the lock, the tick is skipped). When idle it writes no
files.

Cost: one python3 process sleeping between ticks, plus one `herdr api snapshot`
subprocess per tick. No python3 start-up per tick (about 90 ms of CPU each);
only the snapshot call (under 10 ms).

Lifecycle:

- Start: every `sync` (startup hook, events, shell hooks) checks the watcher
  lock `watch-lock-<session hash>` in `$HERDR_PLUGIN_STATE_DIR` and, if nobody
  holds it, spawns the watcher detached (new session via setsid, stdio on
  `/dev/null`). It is not a `[[startup]]` command of its own because herdr
  (0.9.1, `src/app/api/plugins/runtime.rs` `start_plugin_command`) waits on
  every plugin command and reads its stdout/stderr to EOF, holding one of 32
  concurrent-command slots until then (docs: startup hooks are "one-shot
  initialization commands rather than supervised daemons"). Startup hooks also
  do not rerun on config reload or `plugin link`, but the next event does.
- One per server: the watcher holds that flock (keyed by the socket path hash)
  for its whole life; a second one exits at once.
- Exit: when `$HERDR_SOCKET_PATH` disappears (herdr removes it on shutdown), or
  after 5 consecutive failed ticks (15 s). A restarted server's startup hook
  then starts a fresh watcher; if the old one is still alive on the same socket,
  it keeps serving and the new one exits.
- Code or binary change: the watcher records what it runs (script path,
  script mtime, `$HERDR_BIN_PATH`) in `watcher-<session hash>.json`. A `sync`
  from different code (edit, re-link to another dir, herdr upgrade) overwrites
  it, and the watcher re-execs into that code on its next tick.

Stop it: `touch "$HERDR_PLUGIN_STATE_DIR/no-watch"` (normally
`~/.local/state/herdr/plugins/tab-names/no-watch`); the watcher exits within 3 s
and `sync` no longer starts one. Remove the file to re-enable. `pkill -f
'tab_names.py watch'` stops it only until the next sync restarts it.

## Install

Laptop (from the dotfiles checkout):

    dot install

This links the plugin automatically. Running `herdr plugin link <dir>` is idempotent and safe to re-run; it's needed after manifest changes because herdr stores a copy of the manifest when linking.

Remote (each machine runs its own herdr server; the plugin must live there):

    rsync -a --delete --exclude __pycache__ ~/.dotfiles/agents/herdr-plugins/tab-names/ agentbox:~/.local/share/herdr-plugins/tab-names/
    ssh agentbox 'herdr plugin link ~/.local/share/herdr-plugins/tab-names'

For fish on the remote, append to `~/.config/fish/config.fish`:

    source ~/.local/share/herdr-plugins/tab-names/fish/tab-names.fish

## Try it

    python3 tab_names.py sync --dry-run                    # print planned renames
    herdr --machine agentbox api snapshot > /tmp/s.json
    python3 tab_names.py sync --dry-run --snapshot /tmp/s.json

## Update / uninstall

Linked plugins run from the directory: edit (laptop) or re-run the rsync
(remote). A running watcher picks up the new code on its next tick after any
sync. Uninstall with `herdr plugin unlink tab-names`, then stop the watcher
(`touch .../no-watch` or `pkill -f 'tab_names.py watch'`); labels stay as-is.

## Tests

    python3 -m unittest

## TODO

Remote (agentbox, fish): not set up yet. Plan: rsync the plugin dir to the remote, `herdr plugin link` it there, and source `fish/tab-names.fish` from config.fish.
