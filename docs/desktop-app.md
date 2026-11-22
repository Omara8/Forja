# The desktop app

[← Forja](../README.md)

The desktop app is the main way to use Forja. It shows every product on this computer and lets you work each one from its
dashboard; every job runs in the engine the app starts ([running a job](running.md)). Installing the app and its first launch: [installing](installing.md#the-desktop-app).

The app does no work itself: it starts Forja's engine (`forja serve --json`, below) and sends it every action. The terminal runs
the same engine code, so both refuse the same things with the same words, and both write the same products and the same log.

One Forja desktop runs at a time: opening it again brings the open one up, closes it and opens it again. While a job is working it asks
first (Close and reopen, or Keep it open); a job waiting for your answer is never lost and continues after the start.

## The screens

| Screen | What it shows | What you do there |
|---|---|---|
| **Guide** | What Forja can do, read from the code itself: the six kits with their skills and approving roles; for each product type, when each area opens (and, for an existing or live product, what a ticket fills in); four ways to work: a new idea, MVP or PoC; an existing product straight to development; an existing product straight to a test plan; legacy code understood first. With a product open, which of its areas are open now and why the others are not | Pick a path and start its first step for the open product |
| **Ask about this product** | A side panel beside any screen of a product; × closes it | 0.11.3: Forja-Orchestrator (Product)'s proposals at the top (the same list as the dashboard, each with Start and ×). Ask Forja-Orchestrator (Product) a question about the product; it answers from the items, what the documents say and the code, citing item ids, as a job that reads only (0.11.0). An item opens on the product page's own details screen, with what you can do with it in the bar above |
| **Home** | Every product on this computer (name and folder, type, the Forja version that wrote it, platforms, ticket key, idle or busy), Being worked across all products, and Waiting for you (open clashes and offline reviews) | Open a product, start a New product, watch a job. A product whose folder was moved outside Forja is listed under Folder not found: Locate folder… points Forja at it again |
| **New product** | One page, in order: 1. new product or existing software; 2. documents about it (files, a folder or a note), or "No documents exist yet" (then no job asks); 3. the name (its folder is made inside Forja's products folder, Settings → Storage) and ticket key (a key is suggested from the name); 4. the platforms (Other asks right there what it is, for example java library); 5. each platform's repositories, or "No code yet" for it | Create the product. A product from another computer comes in through Settings → Storage, never here |
| **Migration** | A product written by an older Forja: the steps from its version to this one, with their time | Migrate it. Nothing else opens it until it is migrated |
| **A product's dashboard** | See [the dashboard](#the-dashboard) | Everything about one product |
| **Questions** | One area's question groups, one group on one page | Answer, check the group, settle what the check finds. Moving on with nothing typed skips a group that has no required question (Skip this group does the same; open it again any time to answer); a required question must be answered first. When every group of a skill is folded or skipped, its job starts at once and writes the items from those answers, asking nothing the groups hold |
| **A job** | One job while it runs: its questions (each with "? Explain this question"), the step running now (a step of several parts says how many run at a time and how many are done), every AI call, newest first, with how long it took, its model, tokens and cost (estimates; what runs now on top, the parts still waiting as one line, ten rows at a time, the rest by scrolling), its end. A job Forja picked up after it started again opens by itself | Answer its questions; go back to any earlier answer (its cost is shown first); open each AI call's own log (Log); stop it |
| **Product page** | The product page inside the app: the Overview (what fills each part still empty, and which step fills it), the Design map, a tab for each kind of item, Documents (with what write-docs wrote) | Read; every id is a link |
| **Reports** | The product, area and skill reports, code insight's reports, and every file a run kept (Kept by runs: write-docs' documents, a plan) | Read; export as `.md` or `.html`; Open folder for a run's file |
| **Offline reviews** | Every one across products, each with its status: Open, Answered, or Closed with the reason | Answer an offline review's points; Close review (a reason is required); a closed one is read-only |
| **A product's Settings** | Under each product in the menu: ticket key, type, repositories, Export, Delete | Rename the ticket key, add or move a repository, export the product, remove or delete it |
| **Job log** | Every job that ended, per product | Read what ran, how it ended and why; a row opens its job |
| **Log** | Forja's one log on this computer | Find the detail behind an error; export a copy |
| **Settings** | See [Settings](#settings) | |

While a job writes a product, that product is **busy**: the app says where (this app or a terminal), everything can still be read,
and actions wait until the job ends.

## The dashboard

Every open item shows in exactly one section, in this order.

| Section | What is in it |
|---|---|
| **Next step** | The one step to take next, with Start, and marked Next in its area. A new product: Requirements, Architecture and Planning in order (question groups first, then each skill, then the stage's review). An existing product, while its code is not recorded yet: code insight's report on the system's structure (it ends with the design map as built), then Map what the product does today. While a repository is shown apart from the design map, refreshing the map across every repository is the next step. A step already done asks before it runs again |
| **Needs you** | "Showing x of y open items" beside the title, and Hide at the right (folds the box until Forja is closed). Filter chips with their counts: Clashes, Offline reviews, Sign-offs, Open questions, and Tickets needing details (off by default). Each item has one button (Resolve, Answer, Sign off, Open or Fill in) and a ×: the row is hidden from Needs you for good, stays open and is listed in To answer (0.11.2). An open question's Answer opens its page, where Answer takes one answer per point; saved, it waits in review to be folded in |
| **Areas** | The seven areas (Code insight, Requirements, Architecture, Planning, Test readiness, Development, Test execution), each open, approved or locked. A locked area says why; an open one lists its skills (✓ once a job of it finished): a skill with questions opens its groups, the others start as a job. Approve the stage, and the stage's review, open once every skill before the review finished (the first approval); until then the area says which ones are left. Tickets and bugs come from the skills (0.12.0: no New ticket or Report a bug button) |
| **To answer** | Question groups not settled yet, by area, with Continue; and the Needs you rows hidden with their ×, each with its button |
| **To review** | Drafted items waiting for their stage's review and approval (a new product), with Approve, Edit and Reject |
| **Being worked** | Jobs running or waiting for you, and stories In Progress, with Watch |
| **Ready to build** | Approved stories and bugs in To Do, with Build or Fix; the ones blocked by unfinished work, with what blocks them |
| **Recently changed** | The last items written: id, title, why, by whom, when |

The terminal shows the same sections as one numbered list (Open a product in the menu).

## Product types and gates

| Product type | Areas |
|---|---|
| **New product (MVP / PoC / Fresh Idea)** | Requirements: always. Code insight: once the product has a repository. Architecture: once the scope is approved (the requirements stage, or every define-scope item) or a code-insight job finished. Planning: once the architecture stage is fully approved. Test readiness and development: once at least one feature, epic or story is approved |
| **Existing or live** | Every area open, no stage approvals. Work fills the earlier stages it implies (a ticket's feature, the need it serves, the components it touches) as items not approved yet; they wait under Sign-offs, where you approve, edit (directly, no AI) or reject each one |

The type is chosen on the New product page and changed in the product's Settings. A product migrated from an earlier Forja gets a type
from what it holds, and its dashboard asks once: "Is that right?" with 1) Yes, keep it and 2) No, it is the other type.

## Question groups

Every question a skill asks belongs to one group, and the app shows one group on one page: the technical intake's areas, one group
per platform area in design-sections, the purpose, size, data and access, release and other groups of elicit-requirements,
team-pace in estimate-delivery, the calendar, team, releases and risks of plan-iterations, one group per test environment in
prepare-test-resources, and a start group (repository, ticket, conventions) for the others. Answers are saved as drafts of their group; a
skill started after its groups are settled never asks them again.

When you check a group, nothing is written yet:

1. Plain code tries the answers on a throw-away copy of the product (the write gate and the consistency check).
2. The group-validator agent judges what code cannot: an answer that contradicts something agreed earlier, or one too vague to write.
3. Each answer **folds**, has a **gap** (one follow-up question), or **clashes** (with the earlier item or answer, its severity and why).
   "Not decided yet" is accepted and never written. A minor point goes into its tickets' review notes and never blocks.

A clash is never accepted. **Resolve the clash** shows both sides with their reasoning, and you pick, with a reason:

1. Keep my answer: the earlier item changes to agree
2. Keep the earlier item: my answer changes to match it
3. Something else: you say what it should be

Everything is simulated on a throw-away copy, and the page says so at every step. Whatever your resolution breaks comes back to
you the same way. Nothing is written until nothing is left; stop at any point and the clash stays open on the group.

## Environments (0.12.0)

Each product's menu has **Environments**: where Test execution runs the tests. Forja never starts, deploys or changes an
environment; it checks it is up and tests it. **+ Add environment** names a new one (optionally read-only: only scenarios that
change no data run there; Copy keys from… another). Each environment is a table of rows: Type (String, Number, Boolean, URL,
Secret, File, Folder), Repository, Key and Value, with Check now and how many values are missing. The kits add keys, never values:
you add each value here. A File or Folder keeps only its path, on this computer (a Folder's builds are offered highest version
first). A Secret is typed once into this computer's own store (macOS Keychain, Windows Credential Manager; Linux: a secrets file
only you can read) or kept in your own environment variable (the page names it: ticket key, environment, key); it is masked, can
be replaced, never shown again, and no AI ever reads it.

## Edit

Every item's page has one **Edit**, as in Jira: every field and every link of the item can be changed. Each link is a chip with
×; type 3 characters or more in a link's box and the product's items that match show, narrowing with each character, only of
the types that link takes (a link always points at an item the product holds). A ticket's description sections are edited one
by one.

**Save** writes nothing by itself: it starts the job that carries the change, with your edit already in it, and opens it. The
job puts your words into the product's structure and wording, tries the change on a throw-away copy and shows what it affects
before anything is written; you approve it there.

| You edit | The job Save starts |
|---|---|
| A requirement (need, feature request, rule, criterion …) | Add to the requirements (`append-requirements`) |
| A design item (component, interface, platform section …) | Add to the design (`append-design`) |
| A feature, epic, story, task, sub-task or spike | Add to the plan (`append-plan`) |
| A test item (scenario, test data, quality assurance story or task …) | Add or change test items (`append-tests`) |
| A bug | Report bugs (`report-bugs`), on that same bug: it is updated, never a second one |

The new item replaces the old one (the old one is closed as the stage's skill says), except a bug, which is updated in place. An
open question is answered on its page, not edited. Edit works whatever the state of the item's area: the item exists, so a
stage that isn't open yet never stops a change to it.

## Errors and the Log

A failure that stops what you were doing opens one dialog: what failed and what to do next, in plain words. Show details has the
error's code, time, job, product and the technical detail. Retry is offered only when trying again can succeed, and only runs when
you press it. Copy details and Open in log take you further. The same error again within a few seconds adds to a count instead of
a second dialog. If the engine stops, its own dialog offers Restart engine.

The **Log** screen reads Forja's one log on this computer (`<archive>/_local/logs/forja.jsonl`), newest first, a page at a time:
filter by level (every level, info and up, warnings and errors, errors only), source (app, engine, jobs, agents, AI tools),
product, job or text; Load older entries; Export log… writes a copy. Secrets are removed before an entry is written, and an entry
never holds an answer, a prompt or a file's contents, only ids and sizes. The log keeps five files of 5 MB at most.

## Settings

| Tab | What |
|---|---|
| AI tools | Each AI tool found, whether it is signed in, and its version; exactly one is in use and every agent runs on it (Use this switches, from the next agent call). When it hits its usage limit, Forja pauses until you switch here or the limit resets. Then the model for light, normal and heavy work (empty: the tool's own choice), and the limits: agents at once, steps per job |
| Storage | The products folder (Change… shows what moves, then moves Forja's own folders there: `_local` and each product folder directly in the old one; nothing else is touched); Import a product; products in the folder not added yet |
| Safety | The guards (agents stay in their files · what a repository's listing leaves out: git-ignored, git's own folder, hidden folders the profile does not name, generated), each on or off; a job says when one is off. Secrets and the prompt gate are always on. Then the hooks, MCP servers and allow rules in your AI tools' user settings that Forja did not write |
| Notifications | Tell me when a job needs me (0.11.1): when a job asks a question (a usage limit's Resume too), fails or stops and waits for Retry, Resume or Discard, or leaves an offline review while Forja is not the window in front. Notification (on): a system notification, "<the job> needs you" and its question; coming back to Forja opens that job. Icon count (on): the number of jobs waiting, on Forja's icon in the Dock or taskbar where the system shows one. Flash (on): the taskbar button flashes, or the Dock icon bounces, once. Sound (off): a tone under a second, once per new question. All of it clears the moment Forja comes to the front, answered or not; only a new question tells you again |
| About | Forja's version, Check for an update, and the `forja` command |

Each product's own Settings (under it in the menu): its ticket key (Preview the rename), its type, its repositories (each repository's folder on this computer, kept here only, and its platform, changed here: one Forja knows or Other, typed, for example java library; Add a repository, with its own platform: one the product doesn't have yet is added to it, and the design has no section for it until the next architecture report), Export, and Delete… (Cancel, Remove only: Forja forgets it and its folder stays, Delete all: its folder is deleted too).

**Export and import.** Export (the product's Settings) writes one `.forja` file (a zip) holding the product's record with every
item's version, its documents and reports; never your code, this computer's repository paths, its settings or AI accounts, nor the
library cache, which is rebuilt. Your copy stays as it is: an export is a backup, or the product on another computer.

An import takes a `.forja` file or a product folder in two steps:

1. Read it: Forja shows what it holds (name, Forja version, product type, counts), whether this computer has it (then the import updates it), what the gate found (text written for an AI, file by file), its repositories with a Choose folder… for each (optional:
   a product that is only an idea needs none; set them later in the product's Settings), and which files it will build again: pages,
   reports and generated documents are never taken from the file, they are rebuilt from the imported data.
2. Import (or Update) it: nothing is added until you confirm; when the gate found something, you confirm keeping it too.

An update takes everything new or newer in the file; when an item here is newer than the file's (it changed here since the
export), nothing is taken and Forja names the items. The copy it replaces is kept in `_local/taken-back/`. Both sides must run the
same Forja version: a file from any other version, a patch release too, is refused. An import also refuses an Archive folder that
already holds the product, any entry outside the product folder, links, files over 50 MB (100 MB in all) and items that break
Forja's model. The imported product is marked as from outside until a person here has read it through and marked it reviewed.

## The engine: `forja serve --json`

The app starts the engine as a sidecar, after checking its SHA-256 against the value built into the app, and talks to it over
standard input and output only, never a network port. Each message is one line of JSON:

```text
app → engine   {"id": 7, "op": "dashboard", "args": {"product": "my-shop"}}
engine → app   {"id": 7, "ok": true, "result": {…}}
engine → app   {"id": 7, "ok": false, "error": {"code": "closed", "message": "…", "hint": "…", "log_id": "…", "retryable": false}}
engine → app   {"event": "job.finished", "data": {"job": "job-12", "state": "finished", …}}
```

Standard error carries logs only. Work that asks questions or writes runs as a job: the op answers `{"job": "job-12"}` at once, its
questions arrive as `ask` events (answered with the `answer` op) and its end as `job.finished`. The error codes, the ops and the
events are listed in `docs/dev/0.10.0-design.md` in the private repository. You never start it yourself; it is what the app runs.

## The log in the terminal: `forja log`

```text
forja log                         the newest 40 entries: id, time, level, source, job, message
forja log --level warning         warnings and errors only
forja log --job job-12            one job's entries
forja log <id>                    one entry whole, with its detail
```

A failure in a terminal command prints what failed, what to do, and `Details: forja log <id>`.

## Times are GMT

Forja keeps and shows every time in GMT, on every computer: the engine log, the job log, a job's "What happened" lines, the
agents' logs and refusal records, run folder names (`runs/20261110-130839-write-docs` started at 13:08:39 GMT) and the times in
its files. One reference for everyone who reads the same product or log, wherever they are: add your own offset to read it as
your local time (GMT+2: 13:08 GMT is 15:08).
