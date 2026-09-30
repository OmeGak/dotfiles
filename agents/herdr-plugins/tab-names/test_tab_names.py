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
        self.assertEqual(t.plan(snap, {}, "/h"), [("t1", "1", "b ²")])
        # a busy agent in a secondary pane does not rename the tab
        snap["panes"][0].update(agent="claude", agent_status="working",
                                terminal_title="◐ Fix bug")
        self.assertEqual(t.plan(snap, {}, "/h"), [("t1", "1", "b ²")])
        # the main pane's title wins; the glyph is the tab-level status
        snap["panes"][1].update(terminal_title="main task")
        snap["tabs"][0]["agent_status"] = "working"
        self.assertEqual(t.plan(snap, {}, "/h"), [("t1", "1", "◐ main task ²")])

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
        self.assertEqual(t.strip_label("◐ api ³"), "api")
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
        self.assertEqual(t.build_label("x", "", 2), "x ²")
        self.assertEqual(t.build_label("x", "◐", 3), "◐ x ³")
        self.assertEqual(t.build_label("x", "◐", 0), "◐ x")
        long = t.build_label("y" * 60, "◐", 12)
        self.assertTrue(long.startswith("◐ y") and long.endswith("… ¹²"))
        self.assertEqual(len(long), 2 + 40 + 3)

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
        self.assertEqual(t.plan(snap("1", 3), {}, "/h"), [("t", "1", "x ³")])
        # fallback: count snapshot panes
        self.assertEqual(t.plan(snap("1", None, 2), {}, "/h"), [("t", "1", "x ²")])
        self.assertEqual(t.plan(snap("1", None, 1), {}, "/h"), [("t", "1", "x")])
        # count change alone renames; so does dropping back to one pane
        self.assertEqual(t.plan(snap("x ²", 3), {"t": "x ²"}, "/h"),
                         [("t", "x ²", "x ³")])
        self.assertEqual(t.plan(snap("x ³", 1), {"t": "x ³"}, "/h"),
                         [("t", "x ³", "x")])
        # older label without suffix is recognised
        self.assertEqual(t.plan(snap("○ x", 2, status="idle"), {"t": "○ x"}, "/h"),
                         [("t", "○ x", "○ x ²")])
        # glyph + count together, unchanged: no rename
        self.assertEqual(t.plan(snap("◐ x ²", 2, status="working"), {"t": "◐ x ²"}, "/h"), [])
        # manual label untouched
        self.assertEqual(t.plan(snap("x ⊞2", 2), {"t": "x ⊞2"}, "/h"), [("t", "x ⊞2", "x ²")])  # legacy label migrates
        self.assertEqual(t.plan(snap("mine ²", 3), {"t": "x ²"}, "/h"), [])

    def test_session_key(self):
        a, b = t.session_key("/tmp/a.sock"), t.session_key("/tmp/b.sock")
        self.assertNotEqual(a, b)
        self.assertEqual(a, t.session_key("/tmp/a.sock"))
        self.assertEqual(len(a), 8)


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


if __name__ == "__main__":
    unittest.main()
