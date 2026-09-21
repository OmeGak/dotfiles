---
name: do-create-agents
description: Use when the user invokes /do-create-agents, when a project needs project-level Claude Code subagents under .claude/agents/, when an existing roster lacks a seat for the work at hand, or when an orchestrator agent cannot route a task to any existing agent.
---

# Create Agents

Install a **roster of seats** in `.claude/agents/`: one file per role, each sized to the intelligence its work needs. Re-run any time a seat is missing. **The orchestrator is the only mandatory seat.**

**Core rule:** pay for judgment, not for volume. A seat's model and effort follow the *hardest decision it makes*, never the owner's mood about cost or the desire to "set up the full team today".

## Workflow

1. **Read what exists.** `.claude/agents/*.md` and `.claude/agents/README.md` (the roster). Re-runs *add* seats and rewrite the roster. An existing seat changes only when the owner names it; naming it licenses a full rewrite to the template, frontmatter included. If an existing seat sits at the wrong tier or lacks `maxTurns`, leave the file alone and list the one-line fix under "proposed changes" in the report; the owner says yes.
2. **Classify the project** from README, CLAUDE.md, and the tree: research, business, engineering, or mixed. Pick seats from rosters.md for that type.
3. **Pick the smallest roster.** First run: orchestrator plus seats for work already on the table (max 3 to 4 specialists). Never a speculative full team. A missing seat costs one re-run; an unused seat costs tokens forever.
4. **Size each seat** with the tier table below. Write the reason in the roster.
5. **Write each seat** with agent-template.md (frontmatter plus the five-part body). Orchestrator: copy examples/orchestrator.md and fill the blanks.
6. **Update `.claude/agents/README.md`**: table of seat, model, effort, owns, never, plus a "Proposed changes" section for existing seats kept below tier. This is the file every seat reads instead of guessing the others' scope.
7. **Report** the table, any proposed changes to existing seats, what was deferred and why, and how to add a seat later: run `/do-create-agents <role>`.

## Model and effort tiers

| Hardest decision the seat makes | model | effort | Typical seats |
|---|---|---|---|
| Lookup, formatting, high-volume mechanical work | haiku | low | scout, indexer, swarm worker |
| Skilled work with a known procedure | sonnet | medium | extractor, docs, test writer, analyst |
| Verification where a miss is expensive | sonnet | high | evidence checker, reviewer |
| Judgment, design, novel reasoning, routing | opus | high | orchestrator, architect, lead reviewer |
| Only on explicit request | fable | max | none by default |

Add `maxTurns` to every seat. That is the cost cap, not a lower tier. Add `memory: project` only to seats that learn recurring patterns across sessions: checkers, reviewers, the domain seat.

**Orchestrator floor: opus, high.** It decomposes, sequences, and decides when a new seat is needed. If cost is the complaint, cut its `maxTurns`, forbid it from reading whole files, and keep it read-only. Never drop it to `low` effort.

## The gate

Seats prepare, the owner moves. Outward-facing or irreversible actions (send, publish, deploy, push, pay, delete, run migrations) are always in a seat's **never** list: the seat leaves a draft or a recommendation. In-repo edits are fine when scoped to named directories and reviewable in git.

When the owner asks to remove a gate, keep it, grant the largest in-repo equivalent (mark final, stage, queue), and say so in the report.

## Orchestrator duties

Runs as the main session (`claude --agent orchestrator`) or as a subagent. It routes, never does specialist work. Its `tools` include `Agent`, `Skill`, `Read`, `Glob`, `Grep` only. When no seat fits a task it **invokes this skill** with the role needed, then routes.

## Fan-out, not seats

A hundred identical items is a swarm: orchestrator decomposes, haiku/low workers with no seat file each take one item, one sonnet/high validator checks the merge. Do not create a seat per item.

## Rationalizations

| Excuse | Reality |
|---|---|
| "Owner wants the full team now" | Six speculative seats cost more than one re-run. Install what today's work needs. |
| "Orchestrator is just routing, sonnet/low is fine" | Routing is the highest-judgment task in the roster. Cap turns instead. |
| "Adding later is easy, just copy a file" | Copying skips sizing and the roster update. The re-run path is this skill. |
| "It writes the changelog itself, that saves a step" | Saves a step, removes the gate. Draft to a file the owner merges. |
| "Six agents, no orchestrator, the owner routes" | The owner is then the orchestrator on the most expensive model: their attention. |

## Red flags

- A roster with no `orchestrator.md`
- Any seat at `low` effort making a judgment call, or any seat at `opus` doing lookup
- A seat with `Bash` and a deploy, send, or publish verb in its **owns** list
- More than four specialists on a first run
- No `.claude/agents/README.md` after the run
