# The lifecycle

[← Forja](../README.md)

Forja 0.11.2 keeps every product on one source of truth, the backbone: **tickets** for Jira work and **objects** for every fact,
read and written only through Forja's write gateway. Forja runs offline, on one computer, from its desktop app, and only one job
writes a product at a time. How the app looks: [the desktop app](desktop-app.md).

## Stages, roles and what each writes

| Stage | Approving role | Objects | Tickets | Review skill |
|---|---|---|---|---|
| Requirements | product owner | need, scope-item, business-rule, flow, acceptance-criterion, nfr | | review-requirements |
| Architecture | tech lead | architecture-option, component, contract, module, foundation, platform-section, constraint, nfr | | review-architecture |
| Planning | delivery lead | plan | feature, epic, story, task, sub-task, spike | planning-check |
| Test plan | QA lead | test-strategy, test-scenario, test-resource | qa stories, test tasks | review-test-coverage |
| Development | `<platform>` developer (backend developer, web developer …) | open questions | bugs | none: tickets move through their workflow |
| Any stage | the role named on each | open-question, decision, finding, team-rule | | never frozen by an approval |

code-insight reads existing code and writes reports only (`repos/<repo>/insight/<report>/`): it owns no object. scope-clarity writes the requirements from a modernize report; requirements written from it need the sign-off of both the product owner and the tech lead.

## Product types and gates

Each product has a type (`product.json` `product_type`), chosen when it is added and changed later in the app's the product's Settings.

| Product type | What it is for | Areas |
|---|---|---|
| New product (MVP / PoC / Fresh Idea) | Software built with Forja from the start | Gated (below); stage approvals |
| Existing or live | Code your team already has, live or in development | Every area open; no stage approvals |

Each of the six areas (code insight, requirements, architecture, planning, test readiness, development) is open or closed. In a new
product:

| Area | Opens when |
|---|---|
| Requirements | Always |
| Code insight | The product has at least one repository |
| Architecture | The scope is approved (the requirements stage, or every define-scope item), or a code-insight job finished. While the requirements stage itself is not approved, Forja offers to wait for it |
| Planning | The architecture stage is fully approved |
| Test readiness | At least one plan item (feature, epic or story) is approved |
| Development | At least one plan item is approved; Ready to build lists approved stories only |

There is no "start anyway": a closed area says what must be approved first. Once an
area has opened, it stays open: later items are added by the append skills through the same chain, and old items are never gated
again.

In an **existing or live** product every area is open, nothing is frozen, and there are no stage approvals. Work fills the earlier
stages it implies instead: a ticket saved in the ticket form (or a Jira ticket a development job is given) gets its feature, the
need it serves and the components it touches as items marked not approved yet (`approval: "pending"`, `filled_from` the ticket).
They wait under Sign-offs on the dashboard, where you approve, edit (directly, no AI) or reject each one. In the
terminal, its first screen offers "Understand the code first (code-insight)", which reverse-engineers the whole codebase and takes
time and AI usage, or "Go straight to development".

| Starting point | Where it starts |
|---|---|
| New product, no code yet | Requirements |
| Legacy product | code-insight's reports, then requirements |
| Existing or live product | Any area; development straight away on a ticket |

## Tickets and objects

| Rule | What it means |
|---|---|
| Objects | `objects/<type>/<id>.json`. Every fact is a field (values, lists, tables, measurable targets); prose only in the type's listed text sections |
| Tickets | `tickets/<type>/<id>.md`: a JSON data block, then the ticket as a person reads it in Jira (summary, a field line, its prose sections, then every object it references in plain English, child issues and linked issues). The generated parts are rebuilt, never read back |
| Ids | `<prefix>-<n>` per object type (need-4, rule-12, criterion-7), one number sequence for all tickets (feature-1, epic-2, story-12), fixed ids for one-per types (plan, test-strategy, platform-section-web). Never padded, never reused |
| Versions | A content change makes a new version; the previous one is kept in `_versions/`. A state change (a status, a story's rank) makes none |
| Version log | Each ticket and object has a version log, `<type>/_versions/<id>.log.json`: one line per content version with its time, run and cause. Items carry no run or cause field |
| Links | Stored once, on the "from" side; the inverse is computed. Some links are pinned to a version (an open question's asks_about) |
| Ownership | `model/ownership.json`: one owner per field. The write gateway checks every field of every change before it writes |
| Write gateway | The one function every write goes through: it checks the model (who may write which field, allowed status moves, field shapes, links), writes all or nothing, and adds a line to each changed item's version log |
| Agents | A writing agent writes one JSON file per item into its own sandbox (new items named sandbox-<full type name>-<n>, changes named after the existing item's id), then DONE.json. When it stops, Forja takes the sandbox in turn, gives the new items their real ids, rewrites the links, writes the set through the write gateway and clears the sandbox. Agents never write product files; review agents return their findings in a JSON file |
| Broken files | A file that breaks the model is listed as a warning when the product is opened. The product still opens; skills skip that item until it is fixed by hand |
| Platforms | A product always has at least one platform: creating one without any is refused, and opening one without any asks for them first |
| Change sets | A change set is validated whole and written whole, or refused whole: nothing is half-written |
| Never deleted | An object is retired, discarded or replaced; a ticket is resolved won't do, duplicate or cancelled |
| Placeholder tickets | A link to a ticket id the product does not have yet makes a placeholder: only its id, type and status (`placeholder: true`). It is listed under Tickets needing details until someone fills it in |

| Workflow | States |
|---|---|
| Tickets | Backlog → To Do (planning approval) → In Progress (a build run starts) → Done (with a resolution: done, done with known problems, won't do, duplicate, built outside Forja, cancelled); a stopped run puts back the status it found. A Done ticket is never reopened. Bugs are never frozen: edited or cancelled at any time |
| Stage objects | draft → in review → approved; in review → draft when the review leaves findings open or the approving role answers "Not yet". An item a newer one replaces (link `replaces`) becomes **discarded** when nothing was built from it, **replaced** when something was; an item no longer wanted is retired |
| Open questions | open → in review (every point answered) → done (the answer approved and folded in); paused; stale (what it asks about changed); cancelled |
| Findings | open → settled (a decision) → closed (a fix run wrote it, or the decision accepts it) |

## Reviews and approvals

| Step | What happens |
|---|---|
| 1 Forja's checks | The stage gate (`model/stages.json`): for example "every component has a repository", "every story has story points and a component", "every criterion verified by a scenario covered by a qa story"; every object and ticket valid against the model; open questions raised in the stage |
| 2 The stage-reviewer | An agent reads every live item of the stage together, against what they rely on and what relies on them |
| 3 Findings | Each is a finding object. The owning role decides: fix it (your words are the decision the fixing skill applies), raise an open question, or accept it with a reason. Each decision is a decision object |
| 4 No longer needed | Forja lists the items nothing needs any more: all their links point at retired, cancelled, discarded, replaced or out-of-scope items, or a criterion, flow or scenario points at nothing. The approving role keeps or cancels them one by one, or cancels them all |
| 5 Approval | With no open findings, the approving role approves. The approval run freezes only what the review read, each item at that version; approving without a review is refused. The requirements sign-off records a mark per item (items written from a modernize report: by the product owner and the tech lead). Objects move to approved; planning moves the plan's tickets to To Do, the test plan its qa stories and test tasks. "Not yet" puts the items back to draft |

Since 0.9.0 a review never loops and never asks per finding: minor findings are written into the tickets they are about, blockers
and majors get one fix round inside the review, and whatever it does not settle goes to a numbered offline review (see "One loop,
then an offline review (0.9.0)" below).

Every review covers every live item of the stage. An approved stage where nothing changed since its approval has nothing to review.
A review's temporary folder is deleted when the stage is finalized.

## Changing approved work (0.11.0)

Forja is used by one person, who decides a change on the spot. A change to approved (frozen) work, from Change item or from a job
that needs one, is tried on a throw-away copy of the product, all the way down what relies on it; the change-simulator reads what
the meaning change breaks. You see each field old → new and what it touches, and accept or refuse it in that job.

| Case | What happens |
|---|---|
| The copy checks clean | Accept writes it, recorded as a decision: the stage stays approved. Refuse writes nothing |
| The copy breaks something | Accept, and settle what it breaks: for each broken item you say in your own words how it should read; Forja-Agent turns your words into fields and the whole chain is checked again on the copy. Nothing is written until it checks clean; each round is your decision, never an AI loop |
| A ticket built from it is In Progress | It is replaced by a new change ticket (label `change`, link `replaces`) in the Backlog for the next sprint and closed Done with resolution `cancelled`; a Done ticket stays Done |
| A draft | Not frozen: edited directly from its details screen (Edit), no AI |

Bugs are never frozen: they are edited or cancelled at any time. Everything an accepted change creates counts as approved.
A product from before 0.11.0 has its open change requests turned into open questions when it migrates; decided ones stay as history.

## Offline reviews

A run of its own between the roles concerned, with one point per open finding.
Forja writes `offline-review-<n>.md` for the meeting; each answer recorded afterwards becomes a decision,
and the fixing skills apply them once.

## Jobs

Every piece of work is a job: a skill, a group check, an approval, an offline review, a change to approved work, a migration. Jobs
are not something to manage: the dashboard shows the ones being worked on, and the product's job log (`work/jobs.jsonl`, append
only) keeps one line for each job that ended: its number (`job-12`, never reused), what ran, when, how it ended (finished, stopped
or failed) and why. A job's record keeps the answers it was given, what it read at which versions, and for a build the versions it
was built from and the files it wrote (`runs/<id>/run.json`, files it keeps in `runs/<id>/outputs/`). Its working files live in
`Forja-Archive/_local/tmp/` and go when it ends; leftovers from a crash are cleared when the product is opened.

A development job that waits can be continued or abandoned. Before abandoning, Forja checks that nothing relies on its work folder:
another job or an item pointing at its files, or changes the job made that are not committed or not pushed (if something does, it
is listed and you decide). Then Forja deletes the folder and restores the ticket status. Nothing forces a job's state.

A job that reads an item which changes while it works is asked to update, continue on the old version, or take it offline.
A finished build made from an older version than the current one is outdated work (computed, never written into the job).

## Export and import

A product leaves this computer only whole, by Export (the product's Settings) and Import (Settings → Storage). Your copy stays as it is.

| Step | What happens |
|---|---|
| Export | One `<name>.forja` file with every item's version: a backup, or the product on another computer |
| Import of a product this computer has | An update: everything new or newer in the file is taken; generated files are built again. An item newer here refuses it, and Forja names the item. The old copy is kept in `_local/taken-back/` |
| A different Forja version | Refused: both sides run the same Forja version |

## From a planned story to code

| Step | What happens |
|---|---|
| Start | A development run on a story ticket moves it (and its sub-tasks) to In Progress and reads the ticket and everything it references, at their versions |
| Built | Only when it compiles and its tests pass: Done, resolution done (or done with known problems, each offered as a bug) |
| Disagreement | The developer changes the object in the job (for example decision-4), tried on a copy first and accepted there; a correction can be kept as a team rule for the repository |
| Later change | An accepted change to something a story relies on creates a new change ticket in the Backlog for the next sprint; the story stays Done, or is cancelled when it is still In Progress |

## Reviews never loop (0.8.3; replaced by the one-loop rule in 0.9.0)

A stage review is run once. Only two statements or items that directly contradict each other (a *conflict*) are critical: they
go straight to an offline review between the roles concerned, with no per-finding questions and no fix round. Anything else
(a gap, a missing test case, wording, a duplicate, an open question) is a *minor* finding: it is recorded and closed at once with
its own decision, listed in the reports, and never blocks an approval or starts a loop. An offline review is recommended for the
minor ones and required for the critical ones. The meeting's answer is the last word: its findings are closed once the fixing
skills have applied it. A reviewer that did not finish is not a pass: the review says so and is run again.


## Ticket keys, titles in reviews, and the page from the start (0.8.4)

- **Ticket key.** Each product may have a short key (CLF for Campus Lost and Found), asked when the product is made (it can be skipped) and
  changed any time in the product's menu (Ticket key). Every ticket (feature, epic, story, task, sub-task, bug, spike) is then `CLF-1`,
  `CLF-2` ... in one sequence; its type is a field shown next to the id. Objects (needs, rules, components, tests, questions) keep their own
  prefixes. Setting or changing the key renames every ticket id in every file of the product and keeps the old ids as aliases
  (`product.json` `ticket_aliases`), so an old id still finds the same ticket.
- **Reviews show titles.** The "Looks right: go on" review lists every item as `id: title`, never only ids and never cut off at a few.
- **The product page exists from the start.** It is built when the product is made, again before each review, and after every skill.
- **Smaller fixes.** A returned architecture bundle's own open questions are no longer mistaken for the product's questions of the same id;
  a story blocked by unbuilt work offers to build that first; a partial team is asked about the platforms nobody covers; a run whose process
  vanished says which step it was at and when it last saved, and a stop signal (kill, closed terminal) is recorded as such; a young Python
  project names its interpreter before the first test run.
- **Migration.** `forja migrate` (or opening a product) runs the `ticket-key` step: product.json gains `ticket_key` and `ticket_aliases`
  and the page is rebuilt. Nothing else in the product changes.


## One loop, then an offline review (0.9.0)

The rule, everywhere data can clash (a review, a writing agent's change, the check after every skill):

| Step | What happens |
|---|---|
| 1 Plain code first | The status sweep and the consistency check run after every skill and before every approval. The check reads the whole product and sorts what it finds: **blocker** (an item breaks the product's rules, or two items cannot both be true), **major** (a link to nothing or to a retired item, a foundation no ticket builds, a ticket whose parent is gone), **minor** (prose naming an id that does not exist, wording, a gap). What code settles alone is settled and is never a loop. |
| 2 Minor points | Written into the tickets they are about (a ticket's Review notes; for an object, the tickets that reference it). They never block and never start a loop. |
| 3 One fix round | Blockers and majors get exactly one AI fix round: in a review, the skills that write those items; for a writing agent whose change was refused or would break the product, the same agent once more from an empty sandbox, told exactly why. Every change, including the fix, is first applied to a throw-away copy of the product and checked there; a change that would add a blocker or a major is not written. |
| 4 Settled | When the round settles everything, the run carries on from where it was: the next step, question or skill. No second review. |
| 5 Offline review | When it does not, an offline review opens at once: `offline-review-<n>`, every point most severe first, every detail in `offline-review-<n>.md` in the product's cache (`_local/cache/products/<product id>/offline-reviews/`). Answer it in the app's Offline reviews → `offline-review-<n>` (or right away when a job opened it) with one block of text: one paragraph for every point, or `1- ... / 2- ...` (`1=`, `1)`, `1.`, `1:` also work). Forja applies the answers once; nothing goes round again. A job that opened one waits for it (saying so) and carries on with the answers. If even the answers cannot be written, that change is left out, the review says so, and the run carries on. |

What no longer exists: the loop limit (product settings), the "fix now, then review again" offer, the "another review round"
choice, the retry menus of a stopped step (a step that fails runs once more by itself, then stops saying why; one that stops
twice is given the person's answer to what it says it misses, once).

Other 0.9.0 changes:

- **Agents get the rules the gate enforces.** Each writing agent's format file is generated from the model, and now lists, for every
  relation it may set, the only types it may point at; when its instructions and that file disagree, the file wins.
- **Agents see the whole product.** Next to their slice, writing agents get `PRODUCT_MAP`: every live item as id, type, status,
  title and links.
- **A run that does not finish leaves nothing half done.** A run that crashed, was refused by the write gate, was killed or whose
  process vanished has its items undone: what it created is retired (a ticket: Done, won't do), what it changed gets back the
  content it had before the run (a new version saying why). Nothing is deleted. A job waiting for an answer keeps
  its work: it continues from the app.
- **Documents and the product page never crash a run.** An object with empty fields is shown by its title and id; a document that
  cannot be rebuilt keeps its last good copy and says why.
- **A changed answer says what it affects.** Changing an earlier answer lists the items written from it, with their titles, and
  offers one pass of the step that wrote them; open questions asked about the changed item are marked stale.
- **Migration.** Every product from 0.7.3 on migrates straight to 0.9.0 in one jump (`one-loop`): `loop_limit` leaves
  product.json, the ticket key fields are made sure of, and the documents, the product report and the page are rebuilt. No item
  gets a new version.

- **Starting from anywhere.** A run started in a folder no product knows never takes that folder for the project: "Which project
  is this run for?" picks one from the Archive or asks the path of the project's code first (the starting folder is only a
  suggestion), then the product's name (the whole product, not one repository), checked before it is offered: code already in a product
  is used, a folder a crashed add left behind is reused, and a taken name gets the next free one as its suggestion. The detected
  platform is confirmed, and the ticket key is offered.
- **The Jira ticket of a development run.** Read from a file (a .txt named after the ticket with its text inside, or a PDF exported
  from Jira; recommended) or pasted, ending with a line that has only a dot, so a paste never spills into the next question on any
  terminal. The ticket is built as the run's own story (it moves to In Progress, then Done), the AI reads it, and later runs find it
  by its Jira key. A run with no ticket and no documents asks what to build. In an existing project the "no requirements, design or
  plan" question recommends continuing and is asked once per repository. `forja dev`, `forja code-velocity` and the other kit names work
  as commands.
- **Uninstall.** On Windows Forja's files are removed as soon as the uninstaller's window closes (they were locked while it was
  open, so the folders stayed and `forja` still answered); anything that could not be removed is logged, and a new terminal is
  needed afterwards.


## The desktop app, gates and question groups (0.10.0)

- **The desktop app.** Forja is used from a desktop app (macOS Apple Silicon, Windows, Linux); the terminal keeps the commands that ask nothing.
  Each product is worked from its dashboard. [The desktop app](desktop-app.md) describes every screen.
- **Product types and gates.** A new product (MVP / PoC / Fresh Idea) opens its areas through gates; an existing or live product has
  every area open and fills earlier stages as items not approved yet (see "Product types and gates" above).
- **Question groups.** Every question a skill asks belongs to one group (for example the technical intake's areas, one group per
  platform area in design-sections, team-pace in estimate-delivery). The app shows a group on one page. Before anything is written,
  the group is checked: plain code tries the answers on a throw-away copy of the product, then the group-validator agent judges what
  code cannot (an answer that contradicts an earlier agreed detail, or one too vague to write). Each answer folds, gets one
  follow-up question (a gap), or clashes. A clash is never accepted: you change your answer, change the earlier item (a change
  request its owner decides), or let the agent fix it once; what that one fix does not settle becomes an offline review. A skill
  started after its groups are answered asks none of them again.
- **The ticket form.** A ticket as in Jira: id, type and status required (for example `CLF-109`, feature, In Progress); title,
  description, acceptance criteria (Given … When … Then …), priority (Medium when left empty), component, links and attachments are
  optional. A link to an id the product does not have makes a placeholder ticket.
- **Words.** An item a newer one replaces is discarded (nothing was built from it) or replaced (something was); the link is
  `replaces` / `replaced_by`.
- **Jobs, not runs.** Work shows as jobs; the job log replaces the list of runs.
- **Errors and the log.** Every failure says what failed and what to do, with a log entry for the technical detail. One log on this
  computer (`<archive>/_local/logs/forja.jsonl`, five files of 5 MB at most), secrets removed before anything is written, never an
  answer, a prompt or a file's contents. The app's Log screen and `forja log` read it.
- **Security.** Forja's own files are checked at every start; hooks, MCP servers and allow rules Forja did not write are listed and
  a Claude Code user hook stops a start; PDFs are read on this computer and pass secretgate; imports are hardened; releases are
  pinned, signed and published only after the owner approves them.
- **Apple Silicon only.** Intel Macs stay on 0.9.0.
- **Migration.** Every product from 0.7.3 on migrates to 0.10.0 in one jump (`jobs-and-drafts`): items an old word marked as replaced become
  discarded or replaced and the link becomes `replaces`; finished and stopped runs become job-log lines with the same number, and item
  histories name jobs; the answers of a paused job become draft answers of its question groups; skill reports merge into the area
  reports; links to ticket ids that do not exist become placeholder tickets (type and status guessed, marked so); the product type is
  set (the product's earlier mode; else existing when it has code-insight output, or a repository with code and no requirements stage),
  stages already approved count as passed gates, and the app asks you to confirm the type once. Open offline reviews and change
  requests stay as they are.

## Agents lead the jobs (0.11.0)

- **Forja-Agent.** One agent sits in the middle of every job: every kit's skills and Forja's own jobs (resolving a clash,
  changing an item, a spike). Each kit gives it a playbook (what that kind of job needs). It reads, only after the gates, the
  documents as cleaned copies, every answer, the product's items and the cleaned code of repositories already checked; works in turns
  over the job's notebook; runs Forja's tools (never a shell); asks only what it can't settle; proposes its reading for the
  person to confirm; and prefills the job's questions with its answers, evidence and reasons (an answer the gate stops, or words
  where an option is needed, is dropped and the question asked as usual). Scripts check what it proposes; Forja still owns the
  order of the safety steps (the gates first, the person's approval before any write, the build check after). When its AI call
  can't run, the job says so and goes on without it.
- **Notes by content hash.** Forja-Agent reads a document or a code file once and keeps notes on it (on this computer, by the
  file's SHA-256); a later job is given the notes while the content is unchanged and reads only what is new or changed.
- **Documents kept only as cleaned copies.** A document is cleaned the moment it is taken (converted, secret-looking lines
  removed, held when it holds text written for an AI) and the copy as given is deleted; a file that can't be checked waits as
  it is. What the gate held and files that can't be checked are decided in each job, for that job only. A finished
  development run keeps its documents as cleaned copies too, with that run's own decisions.
- **A usage limit pauses Forja.** The job waits for Resume, every other job waits at its next AI step, and nothing new starts
  until the limit resets (or another AI tool is active). The readers
  of documents may work out what a document means, marked as such for the person.
- **The design map.** The architecture report reads every file once (facts kept by content hash; a later run reads only what
  changed). What each repository is made of comes from its build files, read by a script (0.11.1); the AI describes the units
  and never decides them. Repositories are linked by their build files' coordinates; a vendored file is confirmed on both sides.
  Freshness is checked in skill runs only, on every file, new and deleted files included.
- **The build doctor.** A failing compile, build or test run is explained (what, why, before the job or not) with one
  recommended fix; the person applies it, types what they want instead, or stops. Until it passes or they stop.
- **Other on every question.** A typed answer to a question whose step needs one of its choices is read into the choice it
  means and shown back.
- **The gate.** A line counts only when it talks to an AI: a ticket's field table ("Developer: Ahmed") and business rules
  ("do not show the password to the user") pass. A held ticket file is shown line by line and the person keeps or rejects it.
- **Secrets.** A file that can't be checked (too large, not text) is asked apart from files with flagged lines: it can only be
  skipped or read whole, never redacted.
- **Platforms.** A repository's platform can be typed (java library): it becomes the product's platform.
- **Migration.** One step, `cleaned-documents`: each document an older Forja kept as given (`source-documents/`) whose cleaned
  copy the library already has is deleted; every other one is cleaned now (the next job asks what the gate held and what can't
  be checked) and then deleted; the finished development runs of the product's repositories on this computer keep only cleaned copies.
  `source-documents/` goes. Every older node reaches 0.11.0 in one jump.

## A strict secrets check, the structure from the build files (0.11.1)

- **Secrets.** The secrets check is strict by default and is checked against a permanent set of over 200 secret lines in every
  stack that must all be caught: a name and its value written in any form (`key = value`, `key: value`, a call's argument, a
  setter, a dictionary entry, a two-line name and value), a secret inside a connection string, a URL or a command line, a
  fallback value (`getenv("X", "real-value")`), more secret names and provider token formats. Credential files (Maven
  `settings.xml`, NuGet configs, Composer `auth.json`, `.s3cfg`, `.boto`, `.my.cnf`, keytabs, Terraform credentials, Apple `.p8`
  keys, Docker and Kubernetes credentials) are never read. The
  cleaned copy an agent reads is kept for the whole job, and made again on the spot when it is missing.
- **Structure.** What each repository is made of is read from its build files by a script, for every build system Forja knows,
  without running them: an app is a component; a library one app uses sits inside it; one several use is shared (no owner); one
  nothing uses is marked; tests and build logic are listed under the repository. The AI describes these units and never adds,
  drops or moves one. One repository builds on another when its build names the other's coordinates; a vendored jar or AAR,
  or a near name, is a candidate the recorder confirms in the code.
- **Contracts.** The architecture report never records contracts. A contract whose request, response (an event or a file sends
  one way) or example is empty or "not shown" is refused everywhere, Define contracts included.
- **The design map** is one graph (see [running](running.md)).
- **Alerts.** While Forja is in the background, a job that needs you is told by a notification, a count on the icon, one flash
  and (off by default) a short tone: Settings → Notifications.
- **Migration.** One step, `fresh-scan`, for every product and repository: what the AI read before the check was made strict,
  and what was written from it, is deleted, so the next job starts fresh. Deleted: the cleaned copies of the code, the secrets
  checks' records and decisions (asked again), per-file facts, scan notes, Forja-Agent's notes, jobs' working folders, agents'
  logs, code reports and code-insight's run outputs, the draft components, modules, platform sections and foundations the
  architecture report recorded, every contract it wrote (approved too: they held no fields), every other contract whose request, response or
  example is empty or "not shown", and the links to them; the design
  map starts over. Kept: approved items, tickets, documents, settings, offline reviews. This computer's files are wiped once:
  a product imported later never wipes what Forja has made since. Every older node reaches 0.11.1 in one jump.

## The build files read closer, targeted reading, Needs you (0.11.2)

- **Structure.** A build with subprojects never makes its root a unit (it only configures them; what it applies to the whole
  repository is read for outside systems), and a plugin listed with `apply false` is not applied. A module with no code (only a
  manifest, icons or strings) is left out. Coordinates are read from `publishing {}` blocks and from `GROUP` /
  `POM_ARTIFACT_ID`, and a project takes its root's group. A bundled JAR or AAR is a dependency, never dropped: on the
  repository that builds it when its classes' packages (or an AAR's manifest package) are that repository's own, else on an
  outside system named after the file. A Gemfile that only installs fastlane is an outside system used by the units its lanes
  build (else by the repository's apps). One outside system per name for the whole product: one box, a line from each user.
- **The design map.** Everything is centred: each row in its frame, the modules inside each app, every box's words. A frame is
  named by the platform chosen for its repository (Android, Android SDK, Java SDK), with the repository's name only when two
  share a platform. Selecting an outside system lists each user with what it uses it for. A refresh moves what a replaced box
  held (a root project now its repository's library, a module now a component): its calls, stories, decisions and words, and
  what pointed at it.
- **Targeted reading.** The architecture report asks how much code to read: Targeted (the default) or Every file. Targeted
  reads only the files that show how the system works: a script gathers each file's evidence (its imports of network, storage,
  security, injection or outside libraries; system calls an import can't show; addresses; entry points; what it declares; how
  many files import it), a strong agent (file-picker) picks per unit from that evidence, never from a name, and a script checks
  the pick: a file with evidence is read or has the agent's reason. Units of five code files or fewer are read whole. Every run
  says what it did with every file of the repository, and FILES.md lists each one. Facts kept from earlier runs are reused in
  both; the recorder describes only units whose files changed.
- **Offline reviews.** A writer's offline review lives and ends with its job: answered on its page, the answers go to the job's
  own question; the job ending closes it. A point said twice is one point. A platform section created again for its platform
  is a change to it, never a refusal.
- **Needs you.** Each row has a ×: the row is hidden from Needs you for good, stays open, and is listed in To answer. Hide folds
  the whole box until Forja is closed. An open question is answered on its page (Answer), and waits in review to be folded in.
- **Migration.** One step, `outdated-reviews`: every offline review an older Forja opened closes as outdated, an open question
  with answers moves to in review, the recorder's frame names go, and a design map recorded by the older build reader asks for
  a refresh across every repository (the next step on the dashboard; what was read is reused). Nothing is deleted. Every older
  node reaches 0.11.2 in one jump.
