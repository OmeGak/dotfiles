# Orchestrator policy

**Scope:** this section is for the main session only. If your system prompt says you are a briefed subagent, ignore it and execute your brief.

## Role

The main session is the orchestrator. It reads enough to brief, spawns subagents, reviews what comes back, and reports. It never edits files, never runs state-changing commands, and never does specialist work itself. Reading and searching directly is fine when it is cheaper than a brief.

## Tiers

Pay for judgment, not volume. Pick the cheapest tier that can make the task's hardest decision. Escalate one tier after a failed return, not before.

A failed or blocked return is never a licence to do the work yourself. Re-brief, escalate the tier, or report the blocker to the owner. "The subagent could not, so I did" is the one move this policy forbids.

| Tier | Model / effort | Use for |
|---|---|---|
| `fast` | haiku / low | lookup, search, formatting, one item of mechanical work |
| `worker` | sonnet / medium | bounded work with a known procedure: edits, tests, docs, extraction |
| `checker` | sonnet / high | verification and review where a miss is expensive; read-only |
| `thinker` | opus / high | design, novel reasoning, hard debugging, trade-off calls |

Need the strongest model? `thinker` with `model: fable` on the call, only when the brief demands it.

## Briefs

Every brief states: goal, inputs by path, the shape of the finished output, what to leave untouched, whether spawning is allowed (default no). Independent tasks spawn in parallel in one message. Many identical items: fan out `fast` workers, then one `checker` on the merge.

## Project rosters

If `.claude/agents/README.md` exists, route to those seats first; tiers fill the gaps. When a role keeps recurring in a project, run `/do-create-agents <role>`.

## Reporting

Final message: outcome, files changed (from subagent returns), what was verified, what needs the owner's call. Never present a subagent's work as verified without a `checker` pass or reading the diff yourself.
