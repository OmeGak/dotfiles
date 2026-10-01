import fcntl
import os
import tempfile
import unittest

import tab_names as t


class T(unittest.TestCase):
    def test_clean(self):
        self.assertEqual(t.clean_title("◐ tab  naming"), "tab naming")
        self.assertEqual(t.clean_title("✳ Claude Code"), "")
        self.assertEqual(t.clean_title("⠂ Fix bug"), "Fix bug")
        self.assertEqual(t.clean_title("zsh"), "")
        self.assertEqual(t.clean_title(None), "")
        self.assertEqual(t.clean_title(".dotfiles"), ".dotfiles")
        self.assertEqual(t.clean_title("(wip) x"), "(wip) x")
        self.assertEqual(t.clean_title("~"), "~")
        self.assertEqual(t.clean_title("[agentbox] vim ~/c/d"), "")

    def test_truncate(self):
        s = t.truncate("x" * 60)
        self.assertEqual(len(s), 40)
        self.assertTrue(s.endswith("…"))

    def test_cwd(self):
        self.assertEqual(t.cwd_label("/Users/a", "/Users/a"), "~")
        self.assertEqual(t.cwd_label("/Users/a/Code/x/", "/Users/a"), "x")

    def test_guard(self):
        p = {"agent": "claude"}
        for cur in ("", "shell", "claude", "mine", "3"):
            self.assertTrue(t.is_replaceable(cur, p, "mine", 3), cur)
        self.assertFalse(t.is_replaceable("7", p, None, 3))  # digits, not its position
        self.assertFalse(t.is_replaceable("3", p, None, None))
        self.assertFalse(t.is_replaceable("my custom", p, "mine", 3))
        self.assertFalse(t.is_replaceable("bash", {}, None, 3))

    def test_plan(self):
        snap = {
            "tabs": [{"tab_id": "t1", "label": "1", "number": 1},
                     {"tab_id": "t2", "label": "custom", "number": 2},
                     {"tab_id": "t3", "label": "same", "number": 3},
                     {"tab_id": "t4", "label": "9", "number": 4}],  # "9": user-set
            "layouts": [{"tab_id": "t1", "focused_pane_id": "p2"}],  # ignored
            "panes": [
                {"pane_id": "p2", "tab_id": "t1", "cwd": "/a/c"},  # listed first, created second
                {"pane_id": "p1", "tab_id": "t1", "cwd": "/a/b"},
                {"pane_id": "p3", "tab_id": "t2", "cwd": "/a/d"},
                {"pane_id": "p4", "tab_id": "t3", "cwd": "/a/same"},
                {"pane_id": "p5", "tab_id": "t4", "cwd": "/a/e"},
            ],
        }
        self.assertEqual(t.plan(snap, {}, "/h"), [("t1", "1", "b · 2")])
        # a busy agent in a secondary pane does not rename the tab
        snap["panes"][0].update(agent="claude", agent_status="working",
                                terminal_title="◐ Fix bug")
        self.assertEqual(t.plan(snap, {}, "/h"), [("t1", "1", "b · 2")])
        # the main pane's title wins; the glyph is the tab-level status
        snap["panes"][1].update(terminal_title="main task")
        snap["tabs"][0]["agent_status"] = "working"
        self.assertEqual(t.plan(snap, {}, "/h"), [("t1", "1", "◐ main task · 2")])

    def test_plan_zoomed(self):
        def snap(zoomed, focused, label="1"):
            return {
                "tabs": [{"tab_id": "t1", "label": label, "agent_status": "working"}],
                "layouts": [{"tab_id": "t1", "zoomed": zoomed, "focused_pane_id": focused}],
                "panes": [{"pane_id": "p2", "tab_id": "t1", "cwd": "/a/c"},
                          {"pane_id": "p1", "tab_id": "t1", "cwd": "/a/b"}],
            }
        # zoomed: the zoomed pane names the tab; glyph and count unchanged
        self.assertEqual(t.plan(snap(True, "p2"), {}, "/h"), [("t1", "1", "◐ c · 2 ·")])
        # unzoomed: main pane, even when another pane is focused
        self.assertEqual(t.plan(snap(False, "p2"), {}, "/h"), [("t1", "1", "◐ b · 2")])
        # zoomed pane id not among the tab's panes: main name, still marked zoomed
        self.assertEqual(t.plan(snap(True, "p9"), {}, "/h"), [("t1", "1", "◐ b · 2 ·")])
        # switching zoomed <-> main names is still recognised as ours
        self.assertEqual(t.plan(snap(True, "p2", "◐ b · 2"), {"t1": "◐ b · 2"}, "/h"),
                         [("t1", "◐ b · 2", "◐ c · 2 ·")])
        self.assertEqual(t.plan(snap(True, "p2", "◐ b · 2"), {}, "/h"), [])
        # toggling zoom on/off is recognised as ours (marker stripped by the guard)
        self.assertEqual(t.plan(snap(False, "p2", "◐ c · 2 ·"), {"t1": "◐ c · 2 ·"}, "/h"),
                         [("t1", "◐ c · 2 ·", "◐ b · 2")])
        self.assertEqual(t.plan(snap(True, "p1", "◐ b · 2"), {"t1": "◐ b · 2"}, "/h"),
                         [("t1", "◐ b · 2", "◐ b · 2 ·")])
        # zoomed without a count suffix
        one = {"tabs": [{"tab_id": "t", "label": "x", "agent_status": None}],
               "layouts": [{"tab_id": "t", "zoomed": True, "focused_pane_id": "p"}],
               "panes": [{"pane_id": "p", "tab_id": "t", "cwd": "/a/x"}]}
        self.assertEqual(t.plan(one, {"t": "x"}, "/h"), [("t", "x", "x ·")])

    def test_pane_number(self):
        self.assertEqual(t.pane_number("w2:p3"), 3)
        self.assertEqual(t.pane_number("p1"), 1)
        self.assertEqual(t.pane_number("w2:p0"), 32)
        self.assertEqual(t.pane_number("w2:p11"), 33)
        self.assertLess(t.pane_number("w2:p9"), t.pane_number("w2:pA"))
        self.assertLess(t.pane_number("w2:pZ"), t.pane_number("w2:p11"))
        self.assertIsNone(t.pane_number("w2:pI"))
        self.assertIsNone(t.pane_number(None))

    def test_pick_pane(self):
        ids = lambda *a: [{"pane_id": i} for i in a]
        self.assertIsNone(t.pick_pane([]))
        self.assertEqual(t.pick_pane(ids("w2:pG", "w2:p4", "w2:p9"))["pane_id"], "w2:p4")
        self.assertEqual(t.pick_pane(ids("w2:p11", "w2:pZ"))["pane_id"], "w2:pZ")
        self.assertEqual(t.pick_pane(ids("x", "w2:p7"))["pane_id"], "w2:p7")
        self.assertEqual(t.pick_pane(ids("x", "y"))["pane_id"], "x")

    def test_plan_default_is_position(self):
        # Observed herdr 0.9.1: tab w2:tA (number 10) created third in w2 got
        # label "3"; the label follows position, not number, and is per workspace.
        snap = {
            "tabs": [{"tab_id": "w2:t3", "workspace_id": "w2", "label": "keep", "number": 3},
                     {"tab_id": "w2:t4", "workspace_id": "w2", "label": "mine", "number": 4},
                     {"tab_id": "w4:t1", "workspace_id": "w4", "label": "1", "number": 1},
                     {"tab_id": "w2:tA", "workspace_id": "w2", "label": "3", "number": 10},
                     {"tab_id": "w2:tB", "workspace_id": "w2", "label": "10", "number": 11}],
            "layouts": [],
            "panes": [{"pane_id": "p%d" % i, "tab_id": tid, "cwd": "/tmp"}
                      for i, tid in enumerate(["w2:t3", "w2:t4", "w4:t1", "w2:tA", "w2:tB"])],
        }
        self.assertEqual(t.plan(snap, {}, "/h"),
                         [("w4:t1", "1", "tmp"), ("w2:tA", "3", "tmp")])

    def test_glyphs(self):
        self.assertEqual([t.status_glyph(x) for x in
                          ("working", "blocked", "done", "idle", "unknown", None, "??")],
                         ["◐", "×", "✓", "○", "", "", ""])
        self.assertEqual(t.strip_glyph("● foo"), "foo")
        self.assertEqual(t.strip_glyph("· foo"), "foo")  # legacy unknown glyph
        self.assertEqual(t.strip_glyph("○ foo"), "foo")
        self.assertEqual(t.strip_glyph("○foo"), "○foo")
        self.assertEqual(t.strip_glyph("foo"), "foo")

    def test_guard_glyph_change(self):
        p = {}
        self.assertTrue(t.is_replaceable("◐ x", p, "○ x", 3))  # glyph changed since
        self.assertTrue(t.is_replaceable("x", p, "○ x", 3))
        self.assertTrue(t.is_replaceable("○ x", p, "x", 3))  # pre-glyph state
        self.assertFalse(t.is_replaceable("◐ y", p, "○ x", 3))

    def test_plan_glyph(self):
        def snap(status, label):
            return {"tabs": [{"tab_id": "t", "label": label, "agent_status": status}],
                    "layouts": [], "panes": [{"pane_id": "p", "tab_id": "t", "cwd": "/a/x"}]}
        self.assertEqual(t.plan(snap("idle", "1"), {}, "/h"), [("t", "1", "○ x")])
        self.assertEqual(t.plan(snap("idle", "○ x"), {"t": "○ x"}, "/h"), [])
        # unknown / missing status: no glyph at all
        self.assertEqual(t.plan(snap("unknown", "1"), {}, "/h"), [("t", "1", "x")])
        self.assertEqual(t.plan(snap(None, "x"), {"t": "x"}, "/h"), [])
        # legacy "· " label from an older run is cleaned up
        self.assertEqual(t.plan(snap("unknown", "· x"), {"t": "· x"}, "/h"),
                         [("t", "· x", "x")])
        self.assertEqual(t.plan(snap(None, "· foo"), {"t": "· foo"}, "/h"),
                         [("t", "· foo", "x")])  # name changed too
        self.assertEqual(t.plan(snap("unknown", "· mine"), {"t": "· x"}, "/h"), [])
        # glyph change alone renames
        self.assertEqual(t.plan(snap("working", "○ x"), {"t": "○ x"}, "/h"),
                         [("t", "○ x", "◐ x")])
        # manual name untouched, even with a glyph-like prefix
        self.assertEqual(t.plan(snap("idle", "○ mine"), {"t": "○ x"}, "/h"), [])
        self.assertEqual(t.plan(snap("idle", "mine"), {}, "/h"), [])

    def test_strip_label(self):
        self.assertEqual(t.strip_label("◐ api ⊞3"), "api")
        self.assertEqual(t.strip_label("api ⊞12"), "api")  # legacy
        self.assertEqual(t.strip_label("◐ api · 3"), "api")
        self.assertEqual(t.strip_label("api · 12"), "api")
        self.assertEqual(t.strip_label("api ·"), "api")  # zoom marker
        self.assertEqual(t.strip_label("◐ api · 3 ·"), "api")  # count + zoom
        self.assertEqual(t.strip_label("api · 3 · 4"), "api · 3")  # one suffix only
        self.assertEqual(t.strip_label("api · ·"), "api ·")  # one marker only
        self.assertEqual(t.strip_label("api·"), "api·")  # no leading space: kept
        self.assertEqual(t.strip_label("api · 3·"), "api · 3·")
        self.assertEqual(t.strip_label("api · 3x"), "api · 3x")
        self.assertEqual(t.strip_label("◐ api ³"), "api")  # legacy superscript
        self.assertEqual(t.strip_label("api ¹²"), "api")
        self.assertEqual(t.strip_label("api ³ ⊞2"), "api ³")  # one suffix only
        self.assertEqual(t.strip_label("api ²x"), "api ²x")
        self.assertEqual(t.strip_label("api³"), "api³")
        self.assertEqual(t.strip_label("api 3"), "api 3")
        self.assertEqual(t.strip_label("○ api"), "api")
        self.assertEqual(t.strip_label("api"), "api")
        self.assertEqual(t.strip_label("api ⊞"), "api ⊞")
        self.assertEqual(t.strip_label("api⊞3"), "api⊞3")
        self.assertEqual(t.strip_label(None), "")

    def test_build_label(self):
        self.assertEqual(t.build_label("x", "", 1), "x")
        self.assertEqual(t.build_label("x", "◐", 1), "◐ x")
        self.assertEqual(t.build_label("x", "", 2), "x · 2")
        self.assertEqual(t.build_label("x", "◐", 3), "◐ x · 3")
        self.assertEqual(t.build_label("x", "◐", 0), "◐ x")
        self.assertEqual(t.build_label("x", "◐", 2, True), "◐ x · 2 ·")
        self.assertEqual(t.build_label("x", "", 1, True), "x ·")
        self.assertEqual(t.build_label("x", "", 1, False), "x")
        long = t.build_label("y" * 60, "◐", 12)
        self.assertTrue(long.startswith("◐ y") and long.endswith("… · 12"))
        self.assertEqual(len(long), 2 + 40 + 5)

    def test_plan_pane_count(self):
        def snap(label, count=None, npanes=1, status=None):
            tab = {"tab_id": "t", "label": label, "agent_status": status}
            if count is not None:
                tab["pane_count"] = count
            return {"tabs": [tab], "layouts": [],
                    "panes": [{"pane_id": "p%d" % i, "tab_id": "t", "cwd": "/a/x"}
                              for i in range(npanes)]}
        # suffix only when count > 1
        self.assertEqual(t.plan(snap("1", 1), {}, "/h"), [("t", "1", "x")])
        self.assertEqual(t.plan(snap("1", 3), {}, "/h"), [("t", "1", "x · 3")])
        # fallback: count snapshot panes
        self.assertEqual(t.plan(snap("1", None, 2), {}, "/h"), [("t", "1", "x · 2")])
        self.assertEqual(t.plan(snap("1", None, 1), {}, "/h"), [("t", "1", "x")])
        # count change alone renames; so does dropping back to one pane
        self.assertEqual(t.plan(snap("x · 2", 3), {"t": "x · 2"}, "/h"),
                         [("t", "x · 2", "x · 3")])
        self.assertEqual(t.plan(snap("x · 3", 1), {"t": "x · 3"}, "/h"),
                         [("t", "x · 3", "x")])
        # older label without suffix is recognised
        self.assertEqual(t.plan(snap("○ x", 2, status="idle"), {"t": "○ x"}, "/h"),
                         [("t", "○ x", "○ x · 2")])
        # glyph + count together, unchanged: no rename
        self.assertEqual(t.plan(snap("◐ x · 2", 2, status="working"), {"t": "◐ x · 2"}, "/h"), [])
        # manual label untouched
        self.assertEqual(t.plan(snap("x ⊞2", 2), {"t": "x ⊞2"}, "/h"), [("t", "x ⊞2", "x · 2")])  # legacy label migrates
        # legacy superscript label set by the plugin migrates to the new form
        self.assertEqual(t.plan(snap("x ²", 2), {"t": "x ²"}, "/h"), [("t", "x ²", "x · 2")])
        self.assertEqual(t.plan(snap("◐ x ³", 3, status="working"), {"t": "◐ x ³"}, "/h"),
                         [("t", "◐ x ³", "◐ x · 3")])
        self.assertEqual(t.plan(snap("mine · 2", 3), {"t": "x · 2"}, "/h"), [])

    def test_session_key(self):
        a, b = t.session_key("/tmp/a.sock"), t.session_key("/tmp/b.sock")
        self.assertNotEqual(a, b)
        self.assertEqual(a, t.session_key("/tmp/a.sock"))
        self.assertEqual(len(a), 8)


class Panes(unittest.TestCase):
    def snap(self, **kw):
        p = {"pane_id": "w1:p1", "agent": "claude", "terminal_title": "✳ Fix bug"}
        p.update(kw)
        return {"panes": [p, {"pane_id": "w1:p2", "terminal_title": "vim"}]}

    def test_sets_cleaned_title_only_for_agents(self):
        self.assertEqual(t.plan_panes(self.snap(), {}), [("w1:p1", "", "Fix bug")])

    def test_status_glyph(self):
        for st, g in (("working", "◐ "), ("blocked", "× "), ("done", "✓ "), ("idle", "○ "), ("unknown", "")):
            self.assertEqual(t.plan_panes(self.snap(agent_status=st), {}), [("w1:p1", "", g + "Fix bug")])

    def test_glyph_only_change_replaces_ours(self):
        s = self.snap(agent_status="done", label="◐ Fix bug")
        self.assertEqual(t.plan_panes(s, {"w1:p1": "◐ Fix bug"}), [("w1:p1", "◐ Fix bug", "✓ Fix bug")])
        self.assertEqual(t.plan_panes(self.snap(agent_status="done", label="◐ mine"), {"w1:p1": "x"}), [])

    def test_empty_title_and_unchanged(self):
        self.assertEqual(t.plan_panes(self.snap(terminal_title="✳ Claude Code"), {}), [])
        self.assertEqual(t.plan_panes(self.snap(label="Fix bug"), {}), [])
        self.assertEqual(t.plan_panes(self.snap(agent_status="idle", terminal_title="✳ Claude Code"), {}), [])

    def test_truncates(self):
        (_, _, new), = t.plan_panes(self.snap(terminal_title="x" * 60, agent_status="idle"), {})
        self.assertEqual(len(new), 42)

    def test_guard(self):
        self.assertEqual(len(t.plan_panes(self.snap(label="claude"), {})), 1)
        self.assertEqual(len(t.plan_panes(self.snap(label="old"), {"w1:p1": "old"})), 1)
        self.assertEqual(t.plan_panes(self.snap(label="mine"), {"w1:p1": "old"}), [])
        self.assertEqual(t.plan_panes(self.snap(label="mine"), {}), [])

    def test_sync_state(self):
        calls = []
        orig = t.run_herdr
        t.run_herdr = lambda *a: calls.append(a) or type("R", (), {"returncode": 0})()
        try:
            with tempfile.TemporaryDirectory() as d:
                path = os.path.join(d, "p.json")
                t.save_state(path, {"gone": "x"})
                t.sync_panes(path, self.snap())
                self.assertEqual(calls, [("pane", "rename", "w1:p1", "Fix bug")])
                self.assertEqual(t.load_state(path), {"w1:p1": "Fix bug"})
        finally:
            t.run_herdr = orig


class Watch(unittest.TestCase):
    def loop(self, results, checks=None, max_failures=3):
        """Drive watch_loop with scripted tick outcomes (True ok, False raise)."""
        ticks, sleeps = iter(results), []
        checks = iter(checks or [])

        def tick():
            if not next(ticks):
                raise RuntimeError("snapshot failed")

        def check():
            return next(checks, None)

        reason = t.watch_loop(tick, check, sleeps.append, 3.0, max_failures)
        return reason, len(sleeps)

    def test_exits_after_n_consecutive_failures(self):
        self.assertEqual(self.loop([True, False, False, False]), ("failures", 3))

    def test_success_resets_failures(self):
        reason, n = self.loop([False, False, True, False, False, True, False, False, False])
        self.assertEqual((reason, n), ("failures", 8))

    def test_check_stops_before_tick(self):
        self.assertEqual(self.loop([True, True], [None, None, "socket gone"]),
                         ("socket gone", 2))
        self.assertEqual(self.loop([], ["disabled"]), ("disabled", 0))

    def test_check_exception_is_failure_tick(self):
        sleeps = []

        def boom():
            raise RuntimeError("bad state")

        reason = t.watch_loop(lambda: None, boom, sleeps.append, 3.0, 3)
        self.assertEqual((reason, len(sleeps)), ("failures", 2))

    def test_identity_uses_import_time_mtime(self):
        self.assertEqual(t.watcher_identity()["mtime"], t.SCRIPT_MTIME)

    def test_watcher_action(self):
        me, other = {"script": "/a", "mtime": 1, "bin": "h"}, {"script": "/b", "mtime": 1, "bin": "h"}
        self.assertEqual(t.watcher_action(True, {}, me, False), "spawn")
        self.assertEqual(t.watcher_action(True, other, me, False), "spawn")
        self.assertEqual(t.watcher_action(False, me, me, False), "none")
        self.assertEqual(t.watcher_action(False, other, me, False), "retarget")
        self.assertEqual(t.watcher_action(False, {}, me, False), "retarget")
        self.assertEqual(t.watcher_action(True, {}, me, True), "none")

    def test_watch_check(self):
        with tempfile.TemporaryDirectory() as d:
            p = t.paths(d, "k")
            sock = os.path.join(d, "sock")
            me = {"script": "/a", "mtime": 1, "bin": "h"}
            self.assertEqual(t.watch_check(sock, p["disabled"], p["watcher"], me), "socket gone")
            open(sock, "w").close()
            self.assertIsNone(t.watch_check(sock, p["disabled"], p["watcher"], me))
            self.assertIsNone(t.watch_check("", p["disabled"], p["watcher"], me))
            t.save_state(p["watcher"], me)
            self.assertIsNone(t.watch_check(sock, p["disabled"], p["watcher"], me))
            t.save_state(p["watcher"], dict(me, mtime=2))
            self.assertEqual(t.watch_check(sock, p["disabled"], p["watcher"], me), "retarget")
            open(p["disabled"], "w").close()
            self.assertEqual(t.watch_check(sock, p["disabled"], p["watcher"], me), "disabled")

    def test_locked_sync_coalesces(self):
        with tempfile.TemporaryDirectory() as d:
            p = t.paths(d, "k")
            calls = []
            with open(p["lock"], "w") as mine, open(p["lock"], "w") as other:
                # someone else holds the lock: skip, leave it to them
                fcntl.flock(other, fcntl.LOCK_EX)
                self.assertFalse(t.locked_sync(p["state"], mine, p["rerun"], calls.append))
                fcntl.flock(other, fcntl.LOCK_UN)
                self.assertEqual(calls, [])
                # a rerun flag set during our sync makes us run once more
                def sync(path):
                    calls.append(path)
                    if len(calls) == 1:
                        open(p["rerun"], "w").close()
                self.assertTrue(t.locked_sync(p["state"], mine, p["rerun"], sync))
                self.assertEqual(len(calls), 2)
                # an exception unlocks before propagating
                def boom(path):
                    raise RuntimeError("x")
                with self.assertRaises(RuntimeError):
                    t.locked_sync(p["state"], mine, p["rerun"], boom)
                fcntl.flock(other, fcntl.LOCK_EX | fcntl.LOCK_NB)  # free again

    def test_sync_once_idle_writes_nothing(self):
        snap = {"tabs": [{"tab_id": "t", "label": "x"}],
                "panes": [{"pane_id": "p", "tab_id": "t", "cwd": "/a/x"}]}
        with tempfile.TemporaryDirectory() as d:
            path = os.path.join(d, "labels.json")
            self.assertEqual(t.sync_once(path, snapshot=snap), [])
            self.assertFalse(os.path.exists(path))
            t.save_state(path, {"t": "x", "gone": "y"})
            t.sync_once(path, snapshot=snap)
            self.assertEqual(t.load_state(path), {"t": "x"})  # pruned closed tab

    def test_tabs_value(self):
        self.assertEqual(t.tabs_value(2), "2")
        self.assertEqual(t.tabs_value(12), "12")
        self.assertEqual(t.tabs_value(1), "")
        self.assertEqual(t.tabs_value(None), "")

    def test_plan_tabs(self):
        snap = {"workspaces": [{"workspace_id": "w1", "tab_count": 3},
                               {"workspace_id": "w2", "tab_count": 1}]}
        self.assertEqual(t.plan_tabs(snap, {}), [("w1", "3")])
        self.assertEqual(t.plan_tabs(snap, {"w1": "3"}), [])
        # count change, and dropping to one tab clears
        self.assertEqual(t.plan_tabs(snap, {"w1": "2", "w2": "2"}),
                         [("w1", "3"), ("w2", "")])

    def test_sync_tabs_state(self):
        snap = {"workspaces": [{"workspace_id": "w1", "label": "a", "tab_count": 2}]}
        calls = []
        real = t.run_herdr
        t.run_herdr = lambda *a: calls.append(a) or type("R", (), {"returncode": 0})()
        base = ("workspace", "report-metadata", "w1", "--source", "tab-names")
        try:
            with tempfile.TemporaryDirectory() as d:
                path = os.path.join(d, "tabs.json")
                self.assertEqual(t.sync_tabs(path, snap), [("w1", "2")])
                # first pass clears the old title token, then sets tabs
                self.assertEqual(calls, [base + ("--clear-token", "title"),
                                         base + ("--token", "tabs=2")])
                self.assertEqual(t.sync_tabs(path, snap), [])  # remembered
                self.assertEqual(len(calls), 2)
                snap["workspaces"][0]["tab_count"] = 3
                self.assertEqual(t.sync_tabs(path, snap), [("w1", "3")])
                self.assertEqual(calls[2:], [base + ("--token", "tabs=3")])  # no re-clear
                snap["workspaces"][0]["tab_count"] = 1
                self.assertEqual(t.sync_tabs(path, snap), [("w1", "")])
                self.assertEqual(calls[3:], [base + ("--clear-token", "tabs")])
                self.assertEqual(t.load_state(path)["values"], {})
        finally:
            t.run_herdr = real


if __name__ == "__main__":
    unittest.main()
