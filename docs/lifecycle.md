# The lifecycle

[← Forja](../README.md)

## Stages, roles and items

| Stage | Folder | Roles | Item types | Approved by |
|---|---|---|---|---|
| Requirements | `requirements/` | product owner, business analyst | stakeholder-need, scope-item, business-rule, user-flow, acceptance-criterion, glossary-term, requirements-overview | review-requirements |
| Architecture | `architecture/` | architect, platform lead | architecture-option, decision, component, contract, data-entity, foundation, non-functional-requirement, constraint, platform-section, module, architecture-overview | review-architecture |
| Planning | `planning/` | tech lead, product owner | feature, epic, story, planning-overview | plan-iterations |
| Test plan | `test-plan/` | quality assurance | test-scenario, test-data-set, test-environment, test-tool, test-strategy | review-test-coverage |
| Product level | the product folder | any role | open-question, change-request, standing-rule | none: they change state |

code-insight reads existing code and drafts into requirements and architecture; development (code-velocity) builds stories and updates only their progress fields.

| Starting point | Where it starts |
|---|---|
| New product | Requirements |
| Legacy product | code-insight: modernize drafts the requirements from the code |
| Existing product | Any stage: add its repos, then go to any kit |
| One folder | Any kit: the folder becomes a one-repo product |

## Items

| Rule | What it means |
|---|---|
| One file per item | `<stage>/<type-folder>/<id>.md`; an overview is one file at the stage's root; a platform's section is `platform-section-<platform>` |
| Ids | Full words, never padded: `business-rule-12`. Feature, epic and story share one number sequence |
| Versions | `version` and `status` (draft, approved, superseded) in the header; older versions in `_versions/<id>.v<n>.md`; each change adds a line under `## Revisions` (what, when, why, which role) |
| References | Always `id@version`; what depends on an item is computed, never written by hand |
| Progress fields | Changed in place with no new version: a story's progress, key, known problems, built by and tests; a feature's or epic's key; an open question's answer; a change request's state |
| Never deleted | An item that is no longer needed is superseded |

## Stage approval

| Step | What happens |
|---|---|
| 1 Forja's checks | References resolve, versions exist, scope gaps, duplicates; no AI |
| 2 Simulation | An AI reads the stage's items together and lists conflicts and gaps |
| 3 A decision per finding | Fix the draft, raise an open question for the role who knows, or accept with a written reason (kept with the approval) |
| 4 All together | Every item of the approval frozen at its version, recorded in `<stage>/_approvals.json`; the stage's documents are rebuilt |

From the stage's second review on, there is no new round by default: a finding is fixed now (the skill that writes it runs in
fix mode, Forja's own checks run again, and the stage is approved without another simulation), raised as an open question, or
accepted with a reason. Another full round happens only when the person picks it.

After the writing skills fix findings, they follow through: the items that refer to what changed (by reference or by naming it)
are brought in line by one more writer, and a skill earlier in the kit (the test strategy after scenarios were added or retired)
runs again in fix mode. A finding about wording carries a pattern, and every item holding it is fixed, not only those named.

A later approval covers only what changed since the last one. Starting a stage before the earlier one is approved is allowed: draft references are tracked and never block.

## Changes after approval

| Who changes it | What happens |
|---|---|
| The owning role, through its kit (`forja <kit> change-answer`) | A checked edit: simulated first; if nothing breaks, a new version with a revision line, and every reference moves along; if something breaks, it is refused: Forja shows why and what it would break, and nothing changes (raise a change request to have it decided with the other owners) |
| Another role | A change request to the owning role |

| Change request state | Detail kept with it | Next |
|---|---|---|
| waiting | simulation: not run, green or unfinished | The owner's next run simulates it on a copy of the product. Green: the owner uses it, refuses it with a reason, or takes it offline. Unfinished: it keeps waiting |
| declined | by: the simulation (something breaks) or the role that refused | The requester accepts it, or disputes it: it goes in review |
| in review | started by: the requester (a dispute), the owner (taken offline) or a loop found | The team's offline meeting decides; only the requester's blocked work waits. The decision is checked again before it applies: if it still breaks, it is forced in (recorded, each broken item gets its own change request) or stays in review |
| applied | forced: yes or no | Folded in: new versions, references moved, built stories marked change needed |
| withdrawn | the requester's reason | Taken back by the requester while waiting or in review; work it blocked runs again |

The offline meeting is the safety net: a change the simulation declined can be applied only there, never by one role alone.
A chain of changes that loops back to an item it started from is critical and goes in review.

## Runs and outdated work

Every run keeps `runs/<run-id>/run.json`: which items it read at which versions, which files it wrote from which items, and their fingerprints. When an item changes, the files built from its older version are flagged as outdated work (Approvals and change requests → Outdated work: rebuild, keep or take it offline). A run that reads an item which changes while it works is asked to update, continue on the old version, or take it offline.

## Handing a platform section to its platform lead

The architect runs `forja architecture design-sections`. For each platform it asks who designs the section; the answer decides what the platform lead (for example the mobile lead) runs.

| The architect's answer | The platform lead runs | Then |
|---|---|---|
| Here, now | Nothing: the architect designs it in this run | — |
| A teammate in the shared product folder | `forja architecture design-sections`, and picks their platform | The section and its modules are written straight into the shared product |
| Someone outside the shared folder: make a bundle to send | `forja architecture architecture-section --bundle <bundle.zip>` (nothing is registered on their computer) | They send back the return bundle; the architect runs `forja architecture architecture-merge --bundle <return.zip>`: each returned item that differs is shown and decided, an item changed on both sides is shown with both versions first, and another stage's item becomes a change request |

The platform lead owns the platform section and the modules of their platform; the architect keeps the high-level design, components and contracts.

## From a planned story to code

| Step | What happens |
|---|---|
| A development run on a story | It reads the story and what it relies on (business rules, criteria, components, contracts, modules, test scenarios) at their versions |
| Built | Only when it compiles and its tests pass: the story's progress, built by and tests are updated |
| Disagreement | The developer raises a change request on the item (for example decision-4); a correction can be kept as a standing rule for the repo |
| Later change | A used change request on something a built story relies on marks it change needed; change-feature changes the same story |
