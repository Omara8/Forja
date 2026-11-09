# The desktop app

[← Forja](../README.md)

The desktop app is the main way to use Forja. It shows every product on this computer and lets you work each one from its
dashboard; every job runs in the engine the app starts ([running a job](running.md)). Installing the app and its first launch: [installing](installing.md#the-desktop-app).

The app does no work itself: it starts Forja's engine (`forja serve --json`, below) and sends it every action. The terminal runs
the same engine code, so both refuse the same things with the same words, and both write the same products and the same log.

## The screens

| Screen | What it shows | What you do there |
|---|---|---|
| **Guide** | What Forja can do, read from the code itself: the six kits with their skills and approving roles; for each product type, when each area opens (and, for an existing or live product, what a ticket fills in); four ways to work: a new idea, MVP or PoC; an existing product straight to development; an existing product straight to a test plan; legacy code understood first. With a product open, which of its areas are open now and why the others are not | Pick a path and start its first step for the open product |
| **Ask about this product** | A side panel beside any screen of a product | Ask a question about the product; the answer comes from its own items, citing their ids, as a job that reads only |
| **Home** | Every product on this computer (name and folder, type, the Forja version that wrote it, platforms, ticket key, idle or busy), Being worked across all products, and Waiting for you (open clashes and offline reviews) | Open a product, start a New product, watch a job. A product whose folder was moved outside Forja is listed under Folder not found: Locate folder… points Forja at it again |
| **New product** | One page, in order: 1. new product or existing software; 2. where the code is (or "It has no code yet"); 3. the name and ticket key (a key is suggested from the name); 4. the platforms and each platform's repos | Create the product. A product from another computer comes in through Settings → Import / Export, never here |
| **Migration** | A product written by an older Forja: the steps from its version to this one, with their time | Migrate it. Nothing else opens it until it is migrated |
| **A product's dashboard** | See [the dashboard](#the-dashboard) | Everything about one product |
| **Questions** | One area's question groups, one group on one page | Answer, check the group, settle what the check finds. Moving on with nothing typed skips a group that has no required question (Skip this group does the same; open it again any time to answer); a required question must be answered first. When every group of a skill is folded or skipped, its job starts at once and writes the items from those answers, asking nothing the groups hold |
| **Ticket form** | One ticket as in Jira | Create, edit or fill in a ticket; Save, or Save and build |
| **A job** | One job while it runs: its questions (each with "? Explain this question"), its agents with model, tokens and cost so far (estimates), its end | Answer its questions; go back to any earlier answer (its cost is shown first); stop it |
| **Product page** | The product page inside the app: the Overview, the Design map, and a tab for each kind of item | Read; every id is a link |
| **Reports** | The product, area and skill reports | Read; export as `.md` or `.html` |
| **Change requests** and **Offline reviews** | The open ones, across products | Raise, simulate on a throw-away copy, decide; answer an offline review's points |
| **Job log** | Every job that ended, per product | Read what ran, how it ended and why |
| **Log** | Forja's one log on this computer | Find the detail behind an error; export a copy |
| **Settings** | See [Settings](#settings) | |

While a job writes a product, that product is **busy**: the app says where (this app or a terminal), everything can still be read,
and actions wait until the job ends.

## The dashboard

Every open item shows in exactly one section, in this order.

| Section | What is in it |
|---|---|
| **Needs you** | Filter chips with their counts: Clashes, Offline reviews, Sign-offs, Open questions, Change requests, and Tickets needing details (off by default). Each item has one button: Resolve, Answer, Sign off, Open or Fill in |
| **Areas** | The six areas (Code insight, Requirements, Architecture, Planning, Test readiness, Development), each open, approved or locked. A locked area says why; an open one lists its skills (✓ once a job of it finished): a skill with questions opens its groups, the others start as a job. Approve the stage, and the stage's review, open once every skill before the review finished (the first approval); until then the area says which ones are left. Development also offers New ticket and Report a bug |
| **To answer** | Question groups not settled yet, by area, with Continue |
| **To review** | Drafted items waiting for their stage's review and approval (a new product), with Approve, Edit and Reject |
| **Being worked** | Jobs running or waiting for you, and stories In Progress, with Watch |
| **Ready to build** | Approved stories and bugs in To Do, with Build or Fix; the ones blocked by unfinished work, with what blocks them |
| **Recently changed** | The last items written: id, title, why, by whom, when |

The terminal shows the same sections as one numbered list (Open a product in the menu).

## Product types and gates

| Product type | Areas |
|---|---|
| **New product (MVP / PoC / Fresh Idea)** | Requirements: always. Code insight: once the product has a repo. Architecture: once the scope is approved (the requirements stage, or every define-scope item) or a code-insight job finished. Planning: once the architecture stage is fully approved. Test readiness and development: once at least one feature, epic or story is approved |
| **Existing or live** | Every area open, no stage approvals. Work fills the earlier stages it implies (a ticket's feature, the need it serves, the components it touches) as items not approved yet; they wait under Sign-offs, where the owning role approves, edits (a change request) or rejects each one |

The type is chosen on the New product page and changed in Settings → Product. A product migrated from an earlier Forja gets a type
from what it holds, and its dashboard asks once: "Is that right?" with 1) Yes, keep it and 2) No, it is the other type.

## Question groups

Every question a skill asks belongs to one group, and the app shows one group on one page: the technical intake's areas, one group
per platform area in design-sections, the purpose, size, data and access, release and other groups of elicit-requirements,
team-pace in estimate-delivery, the calendar, team, releases and risks of plan-iterations, one group per test environment in
prepare-test-resources, and a start group (repo, ticket, conventions) for the others. Answers are saved as drafts of their group; a
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

## The ticket form

A ticket as in Jira. Required: **id**, **type** and **status** (for example `CLF-109`, feature, In Progress). Optional: title,
description, acceptance criteria (one per line, Given … When … Then …), priority (Medium when left empty), component (one of the
product's repos), links (Parent, Blocked by, Relates to) and attachments (read into the product's library through the document
reader and the gate, like any document).

A link to an id the product does not have yet makes a **placeholder ticket**: you give its type and status, and it waits under
Tickets needing details until its owner fills in the rest. In an existing or live product, saving a development ticket also fills
in its feature, the need it serves and the components it touches, marked not approved yet. Save and build starts the development
job on it straight away (a story, task or bug).

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
| AI tools and accounts | Each AI tool found, its version and path, whether it is signed in, which ones Forja may use and the default; agents at once |
| Models | One model per tier (cheap, mid, strong) and tool; empty follows the tool itself |
| Product | Each product's ticket key and type; its repos (each repo's folder on this computer, kept here only; Add a repo); the roles you hold |
| This machine | The Forja-Archive folder, the theme (night or day), the `forja` command |
| Import / Export | Import a product another computer exported, or take back one you handed off; export (hand off) a product as one file; forget a product on this computer (its folder stays) |
| Hooks and servers | Hooks, MCP servers and allow rules in your AI tools' user settings that Forja did not write |
| About | The engine's version, and Check for an update |

**Import / Export.** A product passes between people like a baton: one works on it while the other waits. An export is one
`.forja` file (a zip) holding the product's record with every item's version, its documents and reports; never your code, this
computer's repo paths, its settings or AI accounts, nor the library cache, which is rebuilt. Export asks who it is for (optional)
and hands the product off: your copy is read-only and says "With <name> since <date>" on Home, the dashboard and here, until their
export comes back. Undo the hand-off, on the dashboard, makes it yours again when it is not coming back.

An import takes a `.forja` file or a product folder in two steps:

1. Read it: Forja shows what it holds (name, Forja version, product type, counts), whether this computer has it (then it is a take-back; the preview notes when it was never handed off, for
   example an older backup of your own), what the gate found (text written for an AI, file by file), its repos with a Choose folder… for each (optional:
   a product that is only an idea needs none; set them later in Settings → Product), and which files it will build again: pages,
   reports and generated documents are never taken from the file, they are rebuilt from the imported data.
2. Import (or Take back) it: nothing is added until you confirm; when the gate found something, you confirm keeping it too.

A take-back takes everything new or newer in their file; when an item here is newer than theirs (it changed here while the product
was away), nothing is taken and Forja names the items. The copy it replaces is kept in `_local/taken-back/`. Both sides must run the
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
events are listed in `docs/dev/0.10.0-design.md` in the private repo. You never start it yourself; it is what the app runs.

## The log in the terminal: `forja log`

```text
forja log                         the newest 40 entries: id, time, level, source, job, message
forja log --level warning         warnings and errors only
forja log --job job-12            one job's entries
forja log <id>                    one entry whole, with its detail
```

A failure in a terminal command prints what failed, what to do, and `Details: forja log <id>`.
