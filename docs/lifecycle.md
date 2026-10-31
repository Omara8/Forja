# The lifecycle

[← Forja](../README.md)

Forja 0.7.3 keeps every product on one source of truth, the backbone: **tickets** for Jira work and **objects** for every fact,
read and written only through Forja's write gateway. Forja runs offline, on one computer, from one terminal at a time.

## Stages, roles and what each writes

| Stage | Approving role | Objects | Tickets | Review skill |
|---|---|---|---|---|
| Requirements | product owner | need, scope-item, business-rule, flow, acceptance-criterion, nfr | | review-requirements |
| Architecture | tech lead | architecture-option, component, contract, module, foundation, platform-section, constraint, nfr | | review-architecture |
| Planning | delivery lead | plan | feature, epic, story, task, sub-task, spike | planning-check |
| Test plan | QA lead | test-strategy, test-scenario, test-resource | qa stories, test tasks | review-test-coverage |
| Development | `<platform>` developer (backend developer, web developer …) | open questions | bugs | none: tickets move through their workflow |
| Any stage | the role named on each | open-question, decision, change-request, finding, team-rule | | never frozen by an approval |

code-insight reads existing code and writes reports only (`repos/<repo>/insight/<report>/`): it owns no object. scope-clarity writes the requirements from a modernize report; requirements written from it need the sign-off of both the product owner and the tech lead.

| Starting point | Where it starts |
|---|---|
| New product | Requirements |
| Legacy product | code-insight's reports, then requirements |
| Existing product | Add its repos, then the first stage not approved yet (see the stage order below) |
| One folder | The folder becomes a one-repo product; with only code (no requirements and no plan), code-velocity runs as is |

| Stage | May start when |
|---|---|
| Requirements | Any time |
| Architecture | Any time; while the requirements are not approved, Forja offers to wait for them first |
| Planning | The requirements and the architecture are approved |
| Test plan | Planning is approved |
| Development | Planning is approved |

There is no "start anyway": a stage that may not start yet names what must be approved first.

This order is for **a new product**. **An existing project** (code your team already has; the mode is set once, when it is added) has no stage order and no approvals: any kit runs at any time, nothing is frozen, edits stay simple, and Approvals shows only its open questions and outdated work. Its first screen offers "Understand the code first (code-insight)", which reverse-engineers the whole codebase and takes time and AI usage, or "Go straight to development". A development run asks for the Jira ticket it is for: you name its type (feature, epic, story, task, sub-task, bug or spike) and it becomes exactly that ticket. Filling in the earlier stages of an existing project later is not offered.

## Tickets and objects

| Rule | What it means |
|---|---|
| Objects | `objects/<type>/<id>.json`. Every fact is a field (values, lists, tables, measurable targets); prose only in the type's listed text sections |
| Tickets | `tickets/<type>/<id>.md`: a JSON data block, then the ticket as a person reads it in Jira (summary, a field line, its prose sections, then every object it references in plain English, child issues and linked issues). The generated parts are rebuilt, never read back |
| Ids | `<prefix>-<n>` per object type (need-4, rule-12, criterion-7), one number sequence for all tickets (feature-1, epic-2, story-12), fixed ids for one-per types (plan, test-strategy, platform-section-web). Never padded, never reused |
| Versions | A content change makes a new version; the previous one is kept in `_versions/`. A state change (a status, a story's rank) makes none |
| Version log | Each ticket and object has a version log, `<type>/_versions/<id>.log.json`: one line per content version with its time, run and cause. Items carry no run or cause field |
| Links | Stored once, on the "from" side; the inverse is computed. Some links are pinned to a version (an open question's asks_about, a change request's changes) |
| Ownership | `model/ownership.json`: one owner per field. The write gateway checks every field of every change before it writes |
| Write gateway | The one function every write goes through: it checks the model (who may write which field, allowed status moves, field shapes, links), writes all or nothing, and adds a line to each changed item's version log |
| Agents | A writing agent writes one JSON file per item into its own sandbox (new items named sandbox-<full type name>-<n>, changes named after the existing item's id), then DONE.json. When it stops, Forja takes the sandbox in turn, gives the new items their real ids, rewrites the links, writes the set through the write gateway and clears the sandbox. Agents never write product files; review agents return their findings in a JSON file |
| Broken files | A file that breaks the model is listed as a warning when the product is opened. The product still opens; skills skip that item until it is fixed by hand |
| Platforms | A product always has at least one platform: creating one without any is refused, and opening one without any asks for them first |
| Change sets | A change set is validated whole and written whole, or refused whole: nothing is half-written |
| Never deleted | An object is retired or superseded; a ticket is resolved won't do, duplicate or cancelled |

| Workflow | States |
|---|---|
| Tickets | Backlog → To Do (planning approval) → In Progress (a build run starts) → Done (with a resolution: done, done with known problems, won't do, duplicate, built outside Forja, cancelled); a stopped run puts back the status it found. A Done ticket is never reopened. Bugs are never frozen: edited or cancelled at any time |
| Stage objects | draft → in review → approved (also superseded, retired); in review → draft when the review leaves findings open or the approving role answers "Not yet" |
| Open questions | open → in review (every point answered) → done (the answer approved and folded in); paused; stale (what it asks about changed); cancelled |
| Findings | open → settled (a decision) → closed (a fix run wrote it, or the decision accepts it) |
| Change requests | raised → simulated → applied or declined → in offline review (disputed); withdrawn; stale |

## Reviews and approvals

| Step | What happens |
|---|---|
| 1 Forja's checks | The stage gate (`model/stages.json`): for example "every component has a repository", "every story has story points and a component", "every criterion verified by a scenario covered by a qa story"; every object and ticket valid against the model; open questions raised in the stage |
| 2 The stage-reviewer | An agent reads every live item of the stage together, against what they rely on and what relies on them |
| 3 Findings | Each is a finding object. The owning role decides: fix it (your words are the decision the fixing skill applies), raise an open question, or accept it with a reason. Each decision is a decision object |
| 4 No longer needed | Forja lists the items nothing needs any more: all their links point at retired, cancelled, superseded or out-of-scope items, or a criterion, flow or scenario points at nothing. The approving role keeps or cancels them one by one, or cancels them all |
| 5 Approval | With no open findings, the approving role approves. The approval run freezes only what the review read, each item at that version; approving without a review is refused. The requirements sign-off records a mark per item (items written from a modernize report: by the product owner and the tech lead). Objects move to approved; planning moves the plan's tickets to To Do, the test plan its qa stories and test tasks. "Not yet" puts the items back to draft |

With findings open, the fix round is offered in the same session: the skills that write the named items fix them (one fixer
call each, no question asked again), the items that point at what changed are followed through once, and the review runs again.
After the product's loop limit (product settings, 1 by default) a loop that left findings open leads to an offline review.

Every review covers every live item of the stage. An approved stage where nothing changed since its approval has nothing to review.
A review's temporary folder is deleted when the stage is finalized.

## Change requests

A change to approved (frozen) work, from a run, an answer or a hand edit, takes one of two paths:

| Work built from it | What happens |
|---|---|
| Not started: neither it nor anything under it (feature > epic > story > sub-task, or for a requirement object the tickets built from it) is In Progress or Done | Forja simulates the change and shows a short summary: each field old → new, and what it touches. You accept (a new version; the stage stays approved) or refuse (nothing is written) |
| Started | A change request, raised automatically or by hand (Approvals and change requests → Raise a change request) |

Bugs are never frozen: they are edited or cancelled at any time. Everything an accepted change creates counts as approved.

| Step | What happens |
|---|---|
| Raised | The reason, the evidence and the proposal (set, create or retire), pinned to the target's version. The accepting role is the target's role |
| Simulated | The proposal is applied to a copy of the product on this computer (its temporary folder is deleted when the simulation ends); every item it touches and everything relying on them is checked, and the change-simulator reads what the meaning change breaks: passing or failing. Nothing is applied |
| Applied | The accepting role applies a passing request, in a run of its own, and a decision is recorded. It creates a new change ticket (label `change`, link `replaces` to the old ticket) in the Backlog for the next sprint. An old ticket still In Progress is cancelled (Done, resolution `cancelled`); a Done ticket stays Done. A changed object gets a new version (its version log names the request) and stays approved |
| Declined | Refused with a reason; the raising role can dispute it: an offline review decides (it may still apply it) |
| Stale | The target moved past the pinned version: the raising role checks it again |

## Offline reviews

A run of its own between the roles concerned, with one point per open finding (or per point of a disputed change request).
Forja writes `generated-documents/OFFLINE-REVIEW-<run-id>.md` for the meeting; each answer recorded afterwards becomes a decision,
and the fixing skills apply them once.

## Runs

Every action is a run with its own record, `runs/<run-id>/run.json`: skill runs, approvals, offline reviews, change-request
decisions and migrations. It holds the answers it asked (each referenced as `<run-id>#<n>`), what it read at which
versions, its outcome, and for a build the versions it was built from and the files it wrote. Files a run keeps go in
`runs/<run-id>/outputs/`; its working files live in `Forja-Archive/_local/tmp/` and go when it ends; leftovers from a crash are
cleared when the product is opened. While it runs it holds one lock file in `_local/locks/`. The run menu lists running and paused
runs only.

A paused development (code-velocity) run can be resumed or abandoned. Before abandoning, Forja checks that nothing relies on its
work folder: another run or an item pointing at its files, or changes the run made that are not committed or not pushed (if
something does, it is listed and you decide). Then Forja deletes the folder, restores the ticket status and the run ends
"abandoned". Nothing forces a run state.

A run that reads an item which changes while it works is asked to update, continue on the old version, or take it offline.
A finished build made from an older version than the current one is outdated work (computed, never written into the run).

## Handing a platform section to someone outside Forja

The tech lead runs `forja architecture design-sections`. For each platform it asks who designs the section.

| The answer | They run | Then |
|---|---|---|
| Here, now | Nothing: the section is designed in this run | — |
| Someone outside Forja: make a bundle to send | `forja architecture architecture-section --bundle <bundle.zip>` | They send back the return bundle; `forja architecture architecture-merge --bundle <return.zip>` shows each returned object that differs to decide on; a change to an approved object follows the rules for changing approved work |

## From a planned story to code

| Step | What happens |
|---|---|
| Start | A development run on a story ticket moves it (and its sub-tasks) to In Progress and reads the ticket and everything it references, at their versions |
| Built | Only when it compiles and its tests pass: Done, resolution done (or done with known problems, each offered as a bug) |
| Disagreement | The developer raises a change request on the object (for example decision-4); a correction can be kept as a team rule for the repo |
| Later change | An accepted change request on something a story relies on creates a new change ticket in the Backlog for the next sprint; the story stays Done, or is cancelled when it is still In Progress |
