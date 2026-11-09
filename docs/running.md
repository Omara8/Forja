# Running a job

[← Forja](../README.md)

Every piece of work in Forja is a job: a skill, a group check, a stage approval, a change, a migration. Jobs run in Forja's
engine; the desktop app starts them, shows them and answers their questions ([the desktop app](desktop-app.md)). While a job
writes a product, everything else can only read it.

## Products

| In the app | What it does |
|---|---|
| Home → New product | A new product: its name, its platforms (every product needs at least one); its areas open through gates, each stage approved before the next opens. Or an existing project: the path of its code; the platform is read from the code; every area is open, with no stage approvals, and the dashboard offers code-insight (it reverse-engineers the whole codebase: time and AI usage) or development straight away, neither recommended |
| Settings → Import / Export | A product a teammate exported: the full path of their `.forja` file or of a product folder (100 MB at most). Forja first shows what it holds, which generated files it will build again (pages, reports and generated documents are never taken from the file), every text written for an AI, and its repos with an optional folder for each; nothing is added until you confirm; every item is checked against the model; the Forja versions must match exactly. There is no shared folder and no sync: a product is handed off by Export (your copy is read-only, "With <name> since <date>", until it comes back; Undo the hand-off on the dashboard) and taken back by importing their export: everything new or newer is taken, and an item changed here meanwhile refuses it. An export is one `<name>.forja` file: its record with every item's version, documents and reports, never your code, repo paths or the library cache |
| Removing a product | Forja forgets it: its entry in `_local/paths.json`, its job locks and its repo cache. The product folder is never touched; deleting it is yours to do. Uninstalling never deletes products |
| Opening a product | Forja checks the version that wrote it: a product from an older Forja (0.7.3 on) is migrated first, no opt-out (the app shows the steps and their time). A product made before 0.7.3 is moved whole, untouched, into `<archive>/legacy/<date>/` on install, on update and by `forja migrate`. Every ticket and object is checked against the model: a file that breaks it is listed under Needs you, the product still opens, and skills skip that item until you fix it by hand. A question whose subject changed since it was asked says so under Needs you |

A repo you do not work on is never asked for: each repo's folder is asked only when a job needs it. Settings → Product → Repos sets each repo's folder on this computer (or adds a repo); a repo with no folder here is listed under Needs you. A product whose folder moved is found again from Home (Locate folder…).

## What a job does

| Moment | What happens |
|---|---|
| A question | The question, one line on why it is asked, and its options. Nothing is assumed: a technical question has no default. A recommended option says why: `(Recommended: <reason>)`; technical questions name who to consult ("Not sure? Ask the mobile lead."). Every single choice has Other (type your own); an optional question has Skip |
| A Python project | The first job asks which Python runs the tests (usually the project's virtual environment) and keeps the answer for the repo on this computer only (every skill, fix-bug included, uses it; nobody is asked twice). Forja checks its version and the packages the project declares and stops with a message when they do not fit. It installs nothing. When no test command is found, the tech lead is asked for it once and it is kept for the repo, shared by the product |
| A story that does not work yet | It stays In Progress and lists why (a compile error, a failing test, tests that could not run or a test file that could not load); run it again (where the checks can run) to finish it. A ticket is Done only when the code compiles and the full unit-test suite passes; there is no Done anyway. A story's own problems are not raised as bug tickets |
| After every job | The skill's report and its kit's report are written (`reports/SKILL-<skill>.md`, `reports/KIT-<kit>.md`) and the product page is rebuilt (Overview, Design map, Requirements, Architecture, Plan, Tests, Questions, Changes, Documents and History; every id, run and status in it is a link, items not yet approved are marked) |
| After an architecture skill | Forja offers to build the updated design map now or continue with the next skill |
| An empty document | It is flagged at once and never read again: delete it from the product's documents, or keep it and add data before the next job |
| Something new or changed later | Run append-requirements, append-design or append-plan. It adds new items next to the old ones and never edits an old one. For each old item it replaces you say small (a change request) or major (the old item is discarded when nothing was built from it, else replaced; a ticket is closed `won't do` if not started, `cancelled` if in progress), and Forja lists the plans built from what was replaced so you can check them |
| A Jira ticket in a file | In an existing project a run can be for a Jira ticket saved as a file: Jira's XML export (recommended), its Word export (.doc), a PDF of the ticket, or a .txt / .md named after it. Every field the file holds becomes that field of the ticket: type, key, summary, description (a bug's Steps to reproduce / Expected / Actual when it has those headings), priority, status (moved only as the workflow allows: In Progress in Jira waits as To Do until the run starts it; Done keeps its resolution), component (when it names a repo of the product, else the run's repo), platform labels, story points, a spike's time box, parent or epic, issue links and sub-tasks (a key the product lacks becomes a placeholder), assignee, sprint and fix versions (shown in the ticket's field line). Acceptance criteria, other labels and components and attachment names go into the ticket's Notes. Comments and the reporter are never kept. Only what the file lacks is asked; everything read passes the gate, and an XML file that declares its own document type or entities is refused |
| Bugs | fix-bug lists the open bugs as `(id) Title` and lets you report one nobody has raised yet; no other skill offers bug tickets (fix the bug first), and fix-bug takes bugs only. A bug stays In Progress until the project works and its tests ran |
| Tests after a change | When production code changes, the whole test suite of its module runs, not only the new tests. A feature or change ends with unit tests for its ticket; you may decline them, and the reason is recorded with the job and shown in the report |
| Text written for an AI | Anything you type or paste, and every document, passes the gate first: secret-looking lines are removed, and invisible characters, hidden comments, hidden Word or web text, encoded blobs, role markers or phrases that tell an AI what to do stop it. Each place is shown; rejecting all of it is recommended |
| Your own words (Other) | The answer interpreter checks what you typed against every answer so far, the product's tickets and objects and its documents. It shows how it read your words and how serious a conflict is; for a conflict it lists what your answer would break (for example online only earlier, offline editing now) and asks one follow-up when something is missing. Keep its reading, answer the follow-up, change your words, or keep your exact words anyway with a reason (kept with the answer) |
| Recommend an answer | At a technical question, the recommender suggests one to three choices for this product, each with why it fits and its trade-off. It never answers for you. Not offered in requirements |
| What the requirements say | At a question that must meet requirements, the requirement expander says what those objects mean for this question: what they ask, which options meet them as they are, which need more work, and what they leave open. It never answers for you |
| Explaining a question | Every question has its explanation: what it asks, why it matters, what each choice leads to, and every Forja word in it (from the glossary) |
| Saved and found answers | Always first, always the same words: `Keep: <value>` and `Use what was found in <where>: <value>` |
| Question groups | An area's questions come in groups, one group on one page. An optional group you leave empty is skipped when you move on (or with Skip this group) and its questions are never asked again; a required question must be answered. Once every group of a skill is folded or skipped, the skill's job starts and writes the items from your answers. A stage's first review and approval open only after every skill before its review finished |
| One answer per question | Each question keeps one answer: a new choice replaces the earlier one. A must question cannot be skipped and offers no "Not decided yet"; a skipped optional question stores nothing |
| Changing an earlier answer | On the job's page, back to any earlier answer of the job. Forja first shows what it costs: the AI steps that run again, the items redone, the answers after it and the steps that changed code. What the job wrote in the product after that answer is undone; code a step already changed stays in the repo (Forja never reverts with git), and once your new answer is in, the job's agents rework that code from where it is to fit it, taking out what no longer fits; the answers after it are offered again, lists too, and once the changed answer is in they are checked against it: one it makes wrong is asked again with the reason |
| Leaving a job | A job that asks waits for you under Being worked (the dashboard and the title bar), even after the app is closed and opened again. Stop ends it and undoes what it half wrote |
| A usage limit | Forja waits for you and offers to retry the step or stop |
| A plan that can't be applied | Forja shows every reason (a file with secrets, a file that doesn't exist, a module or build file that isn't this repo's) and sends the plan back to the planner once. If it's still wrong, you choose what happens; it never repeats on its own |
| The end | The job's tickets and objects in the product, its line in the job log (`forja jobs` in the terminal), its record and outputs in `runs/<id>/`, and `FORJA-USAGE.md` with time, tokens and cost per agent. Copilot does not report tokens. The skill that usually comes next is offered |

## The product report

The product's Reports write the status as Markdown, at three levels, with no AI, into `generated-documents/reports/`:
`PRODUCT-REPORT.md` (Overview, What needs attention, Technical details: every kit in lifecycle order), `KIT-<kit>.md` (its skills,
what comes next, what it wrote) and `SKILL-<skill>.md` (every job of it). Each job shows its state, every question it asked with the
answer given (`<id>#<n>`) and the role that answered, and what it wrote with what that is now. A product migrated from an earlier
Forja keeps its old skill reports inside the area reports (`AREA-<area>.md`).

| A kit that... | Its section shows |
|---|---|
| never ran on the product | "<kit> wasn't run for this product." |
| ran | its jobs (when, skill, state, questions and answers, what each wrote and what it is now) |

What needs attention lists open findings, open and in-review questions, open change requests and outdated work.

## Jira

Tickets mirror Jira's issue types (feature, epic, story, task, sub-task, bug, spike), fields, links and workflow one to one, so a
future connection maps them directly. A ticket's component is the repository that builds it; its labels are its platforms (or qa,
foundation, change); a change ticket links `replaces` to the ticket it replaces; `blocked_by` links say what waits for what. There is no CSV export.

## How many agents at once

3 by default, which keeps you clear of subscription rate limits and keeps a job's cost easy to follow. Raise it in Settings → Tools
(Agents at once) on an API key or a higher plan.

## Steps that happen outside Forja

| Step | Why it stays outside |
|---|---|
| Offline review (`offline-review-<n>`): the points one fix round could not settle, most severe first, and disputed change requests; each point's answer is entered in the app's Offline reviews | People settle what Forja cannot |
| A product handed to someone else (Export): they work on it in their own Forja and export it back; you take it back by Import | Forja has no sync |
| Committing the changes a development job made | Forja never handles git |
| fix-bug temporary logs: you reproduce the bug on your device; Forja waits | Only you can drive the app |
| Device or interface checks a plan lists as manual | They need a device |
| Signing in to an AI tool: `claude`, `codex login` or `copilot` | Once, in the tool itself |

How the stages fit together, approvals and change requests: [the lifecycle](lifecycle.md).

## The document library

A new job starts by offering the product's documents: a folder or files (requirements, briefs, designs and screenshots,
diagrams, notes, exports in md, txt, pdf, docx, xlsx, pptx, json, html, csv, or pictures). They are kept in
`<product>/source-documents/`, converted and checked for secrets on this computer (`<product>/library/docs/`), and read once by the
document reader, which keeps what they say with quotes and places in `<product>/library/library.json`. The product keeps the
choice (use it, add more, read again, or none); only new or changed files are read again.

When a document answers a question, the question shows it first, with its quote and file: confirm it, edit it (your edit goes to
the answer interpreter), or pick another answer. Nothing is taken silently. Each job keeps `DOCUMENT-FINDINGS.md` in its
`outputs/`: every answer the documents gave and what you did with it. Pictures are read by AI tools that open images (Claude Code);
others list them as not read. Every answer you give is kept in the job that asked it (`runs/<id>/run.json`), or as a draft answer
of its question group until a job takes it.
