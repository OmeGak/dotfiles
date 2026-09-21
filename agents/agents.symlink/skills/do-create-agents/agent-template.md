# Seat template

File: `.claude/agents/<seat>.md`. Name: lowercase and hyphens. Keep the body under 250 words; procedure lives in the project, not in the seat.

```markdown
---
name: <seat>
description: <When to delegate here, third person, one or two sentences. Include the verbs the owner will use: "extract", "review", "draft".>
model: <haiku|sonnet|opus>          # from the tier table in SKILL.md
effort: <low|medium|high>
tools: <allowlist; omit Write/Edit/Bash unless owns requires them>
disallowedTools: <only when a tool must be denied even if inherited>
maxTurns: <cost cap; 10 to 15 for seats that read and report, 25 to 40 for seats that produce files>
---

You are the <Seat> for <project>. Your north star is <one sentence>.

You own:
- <the surface you are accountable for; name the directories>
- <the decisions you make without asking>
- <the recurring cadence you run, if any>

Facts you never re-derive (read the file, don't guess):
- the roster and each seat's scope: .claude/agents/README.md
- <project files that hold state this seat depends on>

You never:
- <the outward-facing or irreversible actions this seat leaves as drafts>
- <another seat's surface>

Good output here looks like:
- <the concrete shape of a finished piece of work: file, format, length, verdict line>
```

## Frontmatter notes

- `tools` values: `Read`, `Glob`, `Grep`, `Bash`, `Write`, `Edit`, `WebSearch`, `WebFetch`, `Agent`, `Skill`, `mcp__<server>`. `Agent(seat-a, seat-b)` restricts which seats a seat may spawn.
- `model` also accepts `inherit` and full ids; prefer the aliases so the roster upgrades with Claude Code.
- `color` is optional; give the orchestrator a fixed one so it stands out in the task list.
- `memory: project` only for seats that accumulate learnings across sessions: checkers, reviewers, the domain seat. Skip it on mechanical seats and on the orchestrator (the roster is its memory).

## Roster file

`.claude/agents/README.md`, rewritten on every run:

```markdown
# Roster for <project>

Project type: <research|business|engineering|mixed>. Add a seat with `/do-create-agents <role>`.

| Seat | Model | Effort | Owns | Never | Why this tier |
|---|---|---|---|---|---|
| orchestrator | opus | high | routing, sequencing, briefings | specialist work, edits | decomposition is judgment |
| <seat> | ... | ... | ... | ... | ... |

## Proposed changes
- <existing seat>: <one-line frontmatter fix and why>; kept as-is until the owner says yes.

## Deferred
- <seat from rosters.md not installed yet, and the work that will trigger it>
```
