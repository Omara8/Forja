# Running Forja from the terminal

[← Forja](../README.md)

The desktop app is the main way to use Forja: [the desktop app](desktop-app.md). The terminal (`forja`) does the same work as
numbered menus and stays for CI, scripts and anyone who prefers it. Both run the same engine on the same products; while one of
them writes a product, the other can only read it.

## Where to run it

Any terminal, any folder. Forja finds the product from where you are:

| Where you are | What happens |
|---|---|
| In a repo this computer mapped to a product | One line confirms it: `Use <product> (you are in its repo <repo>)?` |
| In a product folder this computer doesn't know yet | Refused: a product comes onto this computer only through Import (a teammate exports it) |
| In a code folder no product knows | One line offers to add it to your Forja Archive as an existing project: its name (the folder's, or one you type), the platform read from the code |
| Anywhere else | "What are you adding?": one already on this computer, a new product, an existing project (the path of its code, then its name, for example my-shop-Android-1.0; the platform read from the code, asked only when nothing is recognised), or a product a teammate exported |
| `--product <name>` | That product |

The menu's first choice, Open a product, shows the product's dashboard as a numbered list, in the same order as the app: Needs you
(with each count), the six areas (open, or closed with the reason), the question groups to answer, the items to review, what is
being worked on, what is ready to build, and what changed recently. Pick a number to act on it: an open area offers its skills, a
group asks its questions one by one and then checks the group, a ready story starts its development job. The same list offers Ask
about this product (answered from its items, citing their ids), Add or edit a ticket (the ticket form), and Settings (repos,
platforms, ticket key, product type, export, move, remove). The main menu's How to use Forja shows what the app's Guide screen
shows: the kits and their skills, when each area opens for each product type, and the four ways to work. A product gets more repos from Settings → Add a repo.

## Products

| Menu → Products | What it does |
|---|---|
| Add a product | "What are you adding?" 1) One already on this computer: pick it from the list. 2) A new product: its name, its folder, its platforms (every product needs at least one); its areas open through gates, each stage approved before the next opens. 3) An existing project: the path of its code, then its name (the code folder's, or one you type); the platform is read from the code; every area is open, with no stage approvals; the first screen offers code-insight (it reverse-engineers the whole codebase: time and AI usage) or development straight away, neither recommended. 4) A product a teammate exported: the full path of their `.forja` or `.forja-product.zip` file, or of a product folder (100 MB at most); Forja first shows what it holds, which generated files it will build again (pages, reports and generated documents are never taken from the file), and every text written for an AI; nothing is added until you confirm; every item is checked against the model, and a product this computer already has is refused. The product type can be changed later in the product's Settings (or the app's Settings → Product). There is no shared folder to join and no sync: teammates pass a product by Export and Import. A folder given on the command line opens what it is: a product this computer already added, or code (an existing project); a product folder copied in by hand is refused: Import is the only way in |
| A product's Settings (from its dashboard) | Reports; add a repo; change its platforms (at least one always stays; for each object that lists platforms, Forja asks whether it applies to a new one); set a repo's folder on this computer; the ticket key; the product type (new, or existing or live); export it (one `<name>-<date>.forja-product.zip` file for a teammate: its record, documents and reports, never your code, repo paths or the library cache; Forja lists what goes in and you can leave out source-documents/); move it to another folder on this computer; remove it |
| Remove a product | Forja forgets it: its entry in `_local/paths.json`, its job locks and its repo cache. The product folder is never touched; deleting it is yours to do. Forja never deletes a product folder, and uninstalling never deletes products |
| Picking a product | Forja checks the version that wrote it: a product from an older Forja (0.7.3 on) is migrated first, no opt-out. A product made before 0.7.3 is moved whole, untouched, into `<archive>/legacy/<date>/` on install, on update and by `forja migrate` (one kept outside the archive is only forgotten; its folder stays where it is). A product without any platform asks for them first. Then every ticket and object is checked against the model: a file that breaks it is listed as a warning, the product still opens, and skills skip that item until you fix it by hand. Open questions whose items changed go stale, ticket previews are rebuilt, temporary folders a crash left are cleared, jobs whose process is gone are stopped (saying so), and Forja says when the app or another terminal is writing the same product (one writer at a time) |

A repo you do not work on is never asked for: each repo's folder is asked only when a job needs it.

## What a job looks like in the terminal

| Moment | What you see |
|---|---|
| A question | The same everywhere: the question, one context line (why it is asked), the numbered options, then one hint line. Nothing is assumed: Enter picks nothing (the sizing reference excepted). A recommended option says why: `(Recommended: <reason>)`; technical questions name who to consult ("Not sure? Ask the mobile lead."). Typing the start of an option's words picks it. Keys typed while Forja is busy are thrown away, so they never answer the next question. Long options and table cells wrap to your terminal's width; nothing is cut. |
| A Python project | The first run asks which Python runs the tests (usually the project's virtual environment) and keeps the answer for the repo on this computer only (every skill, fix-bug included, uses it; nobody is asked twice). Forja checks its version and the packages the project declares and stops with a message when they do not fit. It installs nothing. When no test command is found, the tech lead is asked for it once and it is kept for the repo, shared by the product |
| A story that does not work yet | It stays In Progress and lists why (a compile error, a failing test, tests that could not run or a test file that could not load); run it again (where the checks can run) to finish it. A ticket is Done only when the code compiles and the full unit-test suite passes; there is no Done anyway. A story's own problems are not raised as bug tickets |
| After every skill | The skill's report and its kit's report are written (`reports/SKILL-<skill>.md`, `reports/KIT-<kit>.md`) and the product page is rebuilt (`<Product name>.html`: Overview, Design map, Requirements, Architecture, Plan, Tests, Questions, Changes, Documents and History in one file that opens in any browser; every id, run and status in it is a link, Back and Forward keep your place, items not yet approved are marked). The product report is written when you ask for it |
| After an architecture skill | Forja asks whether to generate the updated design map now or continue with the next skill |
| An empty document | It is flagged at once and never read again: delete it from the product's documents, or keep it and add data before the next run |
| Something new or changed later | Run append-requirements, append-design or append-plan. It adds new items next to the old ones and never edits an old one. For each old item it replaces you say small (a change request) or major (the old item is discarded when nothing was built from it, else replaced; a ticket is closed `won't do` if not started, `cancelled` if in progress), and Forja lists the plans built from what was replaced so you can check them |
| Bugs | fix-bug lists the open bugs as `(id) Title` and lets you report one nobody has raised yet; no other skill offers bug tickets (fix the bug first), and fix-bug takes bugs only. A bug stays In Progress until the project works and its tests ran |
| Tests after a change | When production code changes, the whole test suite of its module runs, not only the new tests. A feature or change ends with unit tests for its ticket; you may decline them, and the reason is recorded with the run and shown in the report |
| Single choice | The last option is always **Other**: pick its number, or just type your own answer. Lists that can only be one of their items (jobs, reports, products, menu actions) have no Other: type part of a name to pick it. |
| Several choices | Numbers and your own words, mixed, with any separator: `1, 3, Wear OS` · `1 3` · `1+3` · `2-4` · `1 and 3` · `TV / Car`. A question that needs at least one says so; an `(optional)` one takes Enter as none. |
| Yes or no | Two numbered choices, each saying what it does: `1) Yes: install every agent` · `2) No: pick which ones`. Type 1 or 2. Every question in Forja is answered by number (or by typing part of an option's words). |
| Typed or pasted text | Up to 10 lines: one Enter finishes. A paste longer than 10 lines shows a highlighted reminder under it (`▶ 42 lines received · press Enter again to finish`): press Enter once more. Blank lines inside a paste are kept. Ctrl+D (Windows: Ctrl+Z, then Enter) always finishes. Terminals that mark pastes (macOS Terminal, iTerm, Linux terminals, Windows Terminal with Git Bash or WSL) never cut a paste that has no final line break; in Git Bash's own mintty window an empty Enter finishes text. |
| Text written for an AI | Anything you type or paste, and every document, passes the gate first: secret-looking lines are removed, and invisible characters, hidden comments, hidden Word or web text, encoded blobs, role markers or phrases that tell an AI what to do stop it. Each place is shown by line; rejecting all of it is recommended, and a rejected answer is asked again |
| Documents | One prompt for files and text: type file paths (one per line), or paste text. Enter on an empty line ends the paths; text follows the rule above. Everything is checked for secrets before any AI reads it; Forja flags pasting as CRITICAL first, so you can redact before you paste. Files that cannot be checked are left out unless you confirm each one by hand. |
| Your own words (Other) | Inside a run, the answer interpreter reads what you typed against every answer so far, the product's tickets and objects and its documents. It shows how it read your words, names a conflict (for example online only earlier, offline editing now) and asks one follow-up when something is missing, at most three. Keep its answer, answer the follow-up, change your words, or keep your exact words. An answer may give each part its own choice (for example a CI tool per platform): each part is kept apart. |
| `!` at a technical question | The recommender suggests one to three choices for this product, each with why it fits (the earlier answer it follows from) and its trade-off. It never answers for you. Not offered in requirements. |
| `+` at a question that must meet requirements | The question names the requirement objects it must meet (`Must meet nfr-7: …`), written from earlier answers such as the technical intake; every option stays offered. `+` asks the requirement expander what those objects mean for this question: what they ask, which options meet them as they are, which need more work, and what they leave open. It never answers for you. |
| `?` at any question | The question-helper explains it in plain words: what it asks, why it matters, what each choice leads to, and every Forja word in it (from the glossary). Every question Forja asks has a written explanation; a question built during a run (a finding, an open point) is explained by the question-helper agent on the run's AI tool. |
| Exit at any question | Every numbered question ends with `Exit (saved, resume later)`; in a question where several numbers can be picked, Exit is typed on its own. Every typed question's hint says how: `Enter = submit · type stop to exit (saved, resume later) · ? explains` (a paste, a list of files or documents: `Enter twice = submit · …`). Inside a run, the run stops there, everything finished so far is kept, and `forja resume` asks the same question again; outside a run (the menus), Forja closes and nothing is started. Esc does nothing. Forja reads the keys itself in a real terminal: Left and Right, Home and End (or Ctrl+A, Ctrl+E), Backspace and Delete edit anywhere in the answer, Ctrl+U and Ctrl+K clear before or after the cursor, and a long answer that wraps is redrawn in place; in Git Bash's mintty window, or with `FORJA_PLAIN_INPUT=1`, the editing keys are the terminal's own. |
| Saved and found answers | Always first, always the same words: `Keep: <value>` and `Use what was found in <where>: <value>`. |
| One answer per question | Each question keeps one answer: a new choice replaces the earlier one. "Not decided yet" erases the answer and retires what was written from it. A must question cannot be skipped and offers no "Not decided yet"; a skipped optional question stores nothing. |
| `<` (going back) | Inside a run, `<` goes back one question: that question is asked again with your earlier answer first (`Keep: <value>`), and the ones after it are asked again with their earlier answers first; a follow-up that no longer applies is not asked. It goes back as far as the last AI step: before that, change an answer with change-answer. In a menu, `<` goes back to the previous menu. The hint line shows `< goes back` wherever it works. |
| Before an AI step | The answers it works on are listed once, numbered: `Type a number to change one, Enter if all are right`. A number goes back to that question, the same way as `<`. |
| change-answer after an AI step used it | A draft changes at once. An approved item: when nothing built from it has started, Forja simulates the change and shows a short summary (each field old → new, what it touches) for you to accept or refuse; when work built from it has started, it becomes a change request for its role. When later items rely on the item you changed, Forja offers to redo the step that wrote them, in fix mode, for those items only. Nothing is redone without asking. |
| Job names | `--name` gives a job its name (a ticket number is best); a name already used is refused. `forja status` and `forja resume` show when each job started and where it waits; `forja jobs` lists the job log. |
| Something running | A loading line with a spinner, what runs and for how long, for every agent and every check: `⠹ checking the repo for secrets · 0:07`. Agents running together share one line. `FORJA_NO_SPINNER=1` turns it off; `FORJA_ASCII=1` uses plain characters. |
| A plan | Can be opened in the pager (`less`): scroll with the arrow keys, Space or PgDn, and press `q` to come back. |
| Waiting for you | The terminal bell rings and the window title changes, for example `Forja · waiting for you`. macOS Terminal and iTerm bounce the Dock icon, Windows Terminal flashes the taskbar, most Linux terminals mark the tab. `FORJA_BELL=0` turns the bell off. |
| A plan that can't be applied | Forja shows every reason (a file with secrets, a file that doesn't exist, a module or build file that isn't this repo's) and sends the plan back to the planner once. If it's still wrong, you choose what happens; it never repeats on its own. A planning step that ends without writing its plan counts as failed, with Retry / Stop. |
| A usage limit | Forja always waits for you and offers `1) Retry this step` · `2) Exit (saved, resume later)`. A job that waits continues with `forja resume` (or from Being worked in the app), on the AI tool it started with (unless you pass `--tool`). |
| A development job that waits | `forja resume` offers to continue it or abandon it. Before abandoning, Forja checks that nothing relies on its work folder: another job or an item pointing at its files, or changes the job made that are not committed or not pushed (if something does, it is listed and you decide). Then it deletes the folder and restores the ticket status. Nothing forces a job's state. |
| The end | The job's tickets and objects in the product, its line in the job log, its record and outputs in `runs/<id>/`, and `FORJA-USAGE.md` with time, tokens and cost per agent. Copilot does not report tokens. The skill that usually comes next is offered. |

## The product report

Reports (main menu, or a product's Settings → Reports; in the app, the product's Reports) write the status as Markdown, at three levels, with no AI, into `generated-documents/reports/`: `forja report` writes `PRODUCT-REPORT.md` (Overview, What needs attention, Technical details: every kit in lifecycle order); `forja report --kit <kit>` writes `KIT-<kit>.md` (its skills, what comes next, what it wrote); `forja report --skill <skill>` writes `SKILL-<skill>.md` (every job of it). Each job shows its state, every question it asked with the answer given (`<id>#<n>`) and the role that answered, and what it wrote with what that is now. A job's own report stays under Reports → A job's own report. A product migrated from an earlier Forja keeps its old skill reports inside the area reports (`AREA-<area>.md`).

| A kit that... | Its section shows |
|---|---|
| never ran on the product | "<kit> wasn't run for this product." |
| ran | its jobs (when, skill, state, questions and answers, what each wrote and what it is now) |

What needs attention lists open findings, open, stale and in-review questions, open change requests and outdated work.

## Jira

Tickets mirror Jira's issue types (feature, epic, story, task, sub-task, bug, spike), fields, links and workflow one to one, so a
future connection maps them directly. A ticket's component is the repository that builds it; its labels are its platforms (or qa,
foundation, change); a change ticket links `replaces` to the ticket it replaces; `blocked_by` links say what waits for what. There is no CSV export.

## How many agents at once

3 by default, which keeps you clear of subscription rate limits and keeps a run's cost easy to follow. Raise it per run with `--parallel 6` on an API key or a higher plan.

## Steps that happen outside the terminal

| Step | Why it stays outside |
|---|---|
| Offline review (`offline-review-<n>`): the points one fix round could not settle, most severe first, and disputed change requests; each point's answer is entered in Approvals and change requests | People settle what Forja cannot |
| A design section designed by someone outside Forja: the bundle travels by chat, email or a shared drive | The person who knows the stack designs it |
| Committing the changes a development run made | Forja never handles git |
| fix-bug temporary logs: you reproduce the bug on your device; Forja waits | Only you can drive the app |
| Device or interface checks a plan lists as manual | They need a device |
| Signing in to an AI tool: `claude`, `codex login` or `copilot` | Once, in the tool itself |

How the stages fit together, approvals and change requests: [the lifecycle](lifecycle.md).

## The document library

A new run starts by offering the product's documents: a folder or files (requirements, briefs, designs and screenshots,
diagrams, notes, exports in md, txt, pdf, docx, xlsx, pptx, json, html, csv, or pictures). They are kept in
`<product>/source-documents/`, converted and checked for secrets on this computer (`<product>/library/docs/`), and read once by the
document reader, which keeps what they say with quotes and places in `<product>/library/library.json`. Later runs offer the
library again (use it, add more, read again, or none); only new or changed files are read again. A skill started from the one
before keeps the same choice without asking.

When a document answers a question, the question shows it first:

```
  ┌ From your documents
  │ "deployed internally through Microsoft Intune only"   brief.md › Distribution
    1) Confirm what was found: Company devices through a device management system …
    2) Edit it
    3) …
```

Nothing is taken silently: confirm it, edit it (your edit goes to the answer interpreter), or pick another answer. Each run
keeps `DOCUMENT-FINDINGS.md` in its `outputs/`: every answer the documents gave and what you did with it. Pictures are read by
AI tools that open images (Claude Code); others list them as not read. Every answer you give is kept in the job that asked it
(`runs/<id>/run.json`), or as a draft answer of its question group until a job takes it; the follow-up questions and the helper agents read the newest answer per question.

