# Rosters by project type

Pick from the type that matches. Install only the seats today's work needs; the rest arrive by re-run. No roster has an orchestrator seat: the main session orchestrates, briefed by the project CLAUDE.md Orchestration section (examples/orchestration-section.md).

## Research (a paper, a review, an analysis)

| Seat | Owns | Never | Tier |
|---|---|---|---|
| source-scout | candidate sources with DOI, year, one-line relevance | downloads, edits, inventing references | haiku / low |
| extractor | structured evidence rows from sources into `data/` | estimating unreported values, touching the manuscript | sonnet / medium |
| analyst | derived tables and figures from `data/` into `data/derived/` | editing source data, writing narrative | sonnet / medium |
| evidence-checker | page-cited verification of any claim, number, or citation | editing anything, verdicts without a quote | sonnet / high |
| drafter | manuscript sections from evidence on file, into `manuscript/` | citations or numbers not in `data/` or `notes/`, submitting | opus / high |
| peer-reviewer | numbered issues on logic, over-claiming, missing counter-evidence | editing, re-verifying numbers (route to evidence-checker) | opus / high |

## Business (a product, a company, a launch)

| Seat | Owns | Never | Tier |
|---|---|---|---|
| chief-of-staff | briefing (moved / blocked / needs a call), follow-up list closed to zero | building, publishing, moving money, making another seat's call | opus / high (only when the follow-up list outgrows the briefing the main session writes each run) |
| research-lead | the sourced answer to any "do we know" question | contacting anyone, acting on a finding | sonnet / high |
| content-lead | docs, changelog, comms drafts in `drafts/` | publishing; every draft waits for the owner | sonnet / medium |
| finance | pricing, unit economics, the ledger, compliance notes | moving a cent, touching a credential | sonnet / high |
| platform-ops | the judgment queue: what needs a human call, with a recommendation each | deciding any of it | sonnet / medium |
| domain seat (rename per product: customers, partners, community) | target lists, outreach drafts | sending anything | sonnet / medium |

## Engineering (a codebase, a service, a library)

| Seat | Owns | Never | Tier |
|---|---|---|---|
| architect | scoping and briefing an implementation; ADR drafts in `docs/adr/` | implementing, deploying | opus / high |
| implementer | code and tests for one briefed change, in a branch | pushing, merging, touching CI or infra config | sonnet / medium |
| reviewer | correctness, error handling, test coverage on a diff; verdict line first | editing, approving on the owner's behalf | sonnet / high |
| migration-reviewer (or other high-stakes reviewer) | safety of schema, infra, or security-sensitive changes | running anything against a live system | opus / high |
| docs | API reference and changelog drafts under `docs/` | editing source, inventing behaviour not in comments | sonnet / medium |
| test-writer | failing tests for a described behaviour, fixtures | changing production code to make tests pass | sonnet / medium |

## Mixed or unusual projects

Name the surfaces the owner touches weekly; each surface with its own hard decisions is a seat. Surfaces with only mechanical work share a haiku seat or become a swarm. Size with the tier table in SKILL.md.
