---
name: do-create-agents
description: Use when the user invokes /do-create-agents, when a project needs project-level Claude Code subagents under .claude/agents/, when an existing roster lacks a seat for the work at hand, or when the main session cannot route a task to any existing seat.
---

# Create Agents

Install a **roster of seats** in `.claude/agents/`: one file per role, each sized to the intelligence its work needs. Re-run any time a seat is missing. **There is no orchestrator seat**: the main session orchestrates under the global orchestrator policy (`~/.claude/CLAUDE.md`), and this skill gives it project context through an `## Orchestration` section in the project's `CLAUDE.md`.

**Core rule:** pay for judgment, not for volume. A seat's model and effort follow the *hardest decision it makes*, never the owner's mood about cost or the desire to "set up the full team today".

## Workflow

1. **Read what exists.** `.claude/agents/*.md`, `.claude/agents/README.md` (the roster), and the project `CLAUDE.md`. Re-runs *add* seats and rewrite the roster. An existing seat changes only when the owner names it; naming it licenses a full rewrite to the template, frontmatter included. If an existing seat sits at the wrong tier or lacks `maxTurns`, leave the file alone and list the one-line fix under "proposed changes" in the report; the owner says yes. A legacy `orchestrator.md` is a proposed change too: recommend retiring it and moving its project facts into the Orchestration section; never delete it unasked.
2. **Classify the project** from README, CLAUDE.md, and the tree: research, business, engineering, or mixed. Pick seats from rosters.md for that type.
3. **Pick the smallest roster.** First run: seats for work already on the table (max 3 to 4 specialists). Never a speculative full team. A missing seat costs one re-run; an unused seat costs tokens forever.
4. **Size each seat** with the tier table below. Write the reason in the roster.
5. **Write each seat** with agent-template.md (frontmatter plus the five-part body).
6. **Write the Orchestration section** in the project `CLAUDE.md` from examples/orchestration-section.md: the state files the main session never re-derives, the dates briefs serve, the project's own gate, the briefing format. Create `CLAUDE.md` if missing; on re-runs, update the section in place and touch nothing else in the file.
7. **Update `.claude/agents/README.md`**: table of seat, model, effort, owns, never, plus a "Proposed changes" section for existing seats kept below tier. This is the file every seat reads instead of guessing the others' scope.
8. **Report** the table, any proposed changes to existing seats, what was deferred and why, and how to add a seat later: run `/do-create-agents <role>`.

## Model and effort tiers

| Hardest decision the seat makes | model | effort | Typical seats |
|---|---|---|---|
| Lookup, formatting, high-volume mechanical work | haiku | low | scout, indexer, swarm worker |
| Skilled work with a known procedure | sonnet | medium | extractor, docs, test writer, analyst |
| Verification where a miss is expensive | sonnet | high | evidence checker, reviewer |
| Judgment, design, novel reasoning | opus | high | architect, drafter, lead reviewer |
| Only on explicit request | fable | max | none by default |

Add `maxTurns` to every seat. That is the cost cap, not a lower tier. Add `memory: project` only to seats that learn recurring patterns across sessions: checkers, reviewers, the domain seat.

**Orchestration is not sized here.** It runs in the main session on whatever model the owner selected; the roster never contains it. If routing quality is the complaint, sharpen the Orchestration section, not a seat.

## The gate

Seats prepare, the owner moves. Outward-facing or irreversible actions (send, publish, deploy, push, pay, delete, run migrations) are always in a seat's **never** list: the seat leaves a draft or a recommendation. In-repo edits are fine when scoped to named directories and reviewable in git.

When the owner asks to remove a gate, keep it, grant the largest in-repo equivalent (mark final, stage, queue), and say so in the report.

## Orchestration

The main session routes, never does specialist work, and reads the project `CLAUDE.md` Orchestration section before its first brief. Routing lives there rather than in a seat because a seat cannot talk to the owner: it returns one report and stops, while the main session holds the conversation, surfaces one decision at a time, and spawns seats in parallel. When no seat fits a task, the main session **invokes this skill** with the role needed, then routes.

## Fan-out, not seats

A hundred identical items is a swarm: the main session decomposes, haiku/low workers with no seat file each take one item, one sonnet/high validator checks the merge. Do not create a seat per item.

## Rationalizations

| Excuse | Reality |
|---|---|
| "Owner wants the full team now" | Six speculative seats cost more than one re-run. Install what today's work needs. |
| "An orchestrator seat makes routing reusable" | Routing already lives in the main session under the global policy. A routing seat is a second hop that cannot ask the owner anything. Put the project facts in the Orchestration section instead. |
| "Adding later is easy, just copy a file" | Copying skips sizing and the roster update. The re-run path is this skill. |
| "It writes the changelog itself, that saves a step" | Saves a step, removes the gate. Draft to a file the owner merges. |
| "Six agents, no Orchestration section, the owner routes" | The owner is then the orchestrator on the most expensive model: their attention. The main session routes; give it the section. |

## Red flags

- A new `orchestrator.md` in the roster (routing belongs to the main session)
- No `## Orchestration` section in the project `CLAUDE.md` after the run
- Any seat at `low` effort making a judgment call, or any seat at `opus` doing lookup
- A seat with `Bash` and a deploy, send, or publish verb in its **owns** list
- More than four specialists on a first run
- No `.claude/agents/README.md` after the run
