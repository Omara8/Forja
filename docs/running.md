# Running Forja

[← Forja](../README.md)

## Where to run it

Any terminal, any folder. Forja finds the product from where you are:

| Where you are | What happens |
|---|---|
| In a repo this computer mapped to a product | One line confirms it: `Use <product> (you are in its repo <repo>)?` |
| In a product folder not added on this computer (a teammate shared it) | One line offers to add it and use it |
| In a code folder no product knows | One line offers to add it to your Forja Archive as a new product: its name (the folder's, or one you type), the platform read from the code |
| Anywhere else | "Is this product already in your Forja Archive?" Yes: pick it from the list. No: the path of its code, then its name in the Archive (the code folder's name, or another, for example EVC-Android-1.0); the product is added with that folder as its repo, the platform read from the code (asked only when nothing is recognised) |
| `--product <name>` | That product |

Start a run asks for the product first, then the kit and the skill. A product gets more repos from Products → the product → Add a repo.

## Products

| Menu → Products | What it does |
|---|---|
| Add a product | "Is this product already in your Forja Archive?" Your Forja Archive keeps what Forja knows about each product, one folder per product, never your code. 1) Yes: pick it from the list (the Archive's products and the product folders this computer used before), or type its path. 2) No: the path of its code, then its name (the code folder's, or one you type); the platform is read from the code. 3) A product folder your team shares (OneDrive, Dropbox …): its path; id, name, platforms and repos come with it. 4) No code yet: an empty product record (its name, its folder, its platforms). Forja tells folders apart: product.json is a product folder; _tools/ or _local/ is an Archive (its products are listed); a folder that is already a product's repo opens that product |
| A product | Change its platforms (every item's platform scope is checked), add a repo, set a repo's folder on this computer, move the product, forget it on this computer |
| Import from an old archive | A product of Forja before 0.6.0 becomes drafts (source: import); what cannot be mapped stays in `_old_archive/` |

A repo you do not work on is never asked for: each repo's folder is asked only when a run needs it.

## What a run looks like

| Moment | What you see |
|---|---|
| A question | The same everywhere: the question, one context line (why it is asked), the numbered options, then one hint line. Nothing is assumed: Enter picks nothing (the sizing reference excepted). A recommended option says why: `(Recommended: <reason>)`; technical questions name who to consult ("Not sure? Ask the mobile lead."). Typing the start of an option's words picks it. Keys typed while Forja is busy are thrown away, so they never answer the next question. Long options and table cells wrap to your terminal's width; nothing is cut. |
| Single choice | The last option is always **Other**: pick its number, or just type your own answer. Lists that can only be one of their items (runs, reports, products, menu actions) have no Other: type part of a name to pick it. |
| Several choices | Numbers and your own words, mixed, with any separator: `1, 3, Wear OS` · `1 3` · `1+3` · `2-4` · `1 and 3` · `TV / Car`. A question that needs at least one says so; an `(optional)` one takes Enter as none. |
| Yes or no | Two numbered choices, each saying what it does: `1) Yes: install every agent` · `2) No: pick which ones`. Type 1 or 2. Every question in Forja is answered by number (or by typing part of an option's words). |
| Typed or pasted text | Up to 10 lines: one Enter finishes. A paste longer than 10 lines shows a highlighted reminder under it (`▶ 42 lines received · press Enter again to finish`): press Enter once more. Blank lines inside a paste are kept. Ctrl+D (Windows: Ctrl+Z, then Enter) always finishes. Terminals that mark pastes (macOS Terminal, iTerm, Linux terminals, Windows Terminal with Git Bash or WSL) never cut a paste that has no final line break; in Git Bash's own mintty window an empty Enter finishes text. |
| Documents | One prompt for files and text: type or drag file paths (one per line), or paste text. Enter on an empty line ends the paths; text follows the rule above. Everything is checked for secrets before any AI reads it; Forja flags pasting as CRITICAL first, so you can redact before you paste. Files that cannot be checked are left out unless you confirm each one by hand. |
| Your own words (Other) | Inside a run, the answer interpreter reads what you typed against every answer so far, the product's items and its documents. It shows how it read your words, names a conflict (for example online only earlier, offline sync now) and asks one follow-up when something is missing, at most three. Keep its answer, answer the follow-up, change your words, or keep your exact words. An answer may give each part its own choice (for example a CI tool per platform): each part is kept apart. |
| `!` at a technical question | The recommender suggests one to three choices for this product, each with why it fits (the earlier answer it follows from) and its trade-off. It never answers for you. Not offered in requirements. |
| `+` at a question that must meet requirements | The question names the requirement items it must meet (`Must meet non-functional-requirement-7: …`), written from earlier answers such as the technical intake; every option stays offered. `+` asks the requirement expander what those items mean for this question: what they ask, which options meet them as they are, which need more work, and what they leave open. It never answers for you. |
| `?` at any question | The question-helper explains it in plain words: what it asks, why it matters, what each choice leads to, and every Forja word in it (from the glossary). Every question Forja asks has a written explanation; a question built during a run (a finding, an open point) is explained by the question-helper agent on the run's AI tool. |
| Exit at any question | Every numbered question ends with `Exit (saved, resume later)`; in a question where several numbers can be picked, Exit is typed on its own. Every typed question's hint says how: `Enter = submit · type stop to exit (saved, resume later) · ? explains` (a paste, a list of files or documents: `Enter twice = submit · …`). Inside a run, the run stops there, everything finished so far is kept, and `forja resume` asks the same question again; outside a run (the menus), Forja closes and nothing is started. Esc does nothing. Forja reads the keys itself in a real terminal: Left and Right, Home and End (or Ctrl+A, Ctrl+E), Backspace and Delete edit anywhere in the answer, Ctrl+U and Ctrl+K clear before or after the cursor, and a long answer that wraps is redrawn in place; in Git Bash's mintty window, or with `FORJA_PLAIN_INPUT=1`, the editing keys are the terminal's own. |
| Saved and found answers | Always first, always the same words: `Keep: <value>` and `Use what was found in <where>: <value>`. |
| `<` (going back) | Inside a run, `<` goes back one question: that question is asked again with your earlier answer first (`Keep: <value>`), and the ones after it are asked again with their earlier answers first; a follow-up that no longer applies is not asked. It goes back as far as the last AI step: before that, change an answer with change-answer. In a menu, `<` goes back to the previous menu. The hint line shows `< goes back` wherever it works. |
| Before an AI step | The answers it works on are listed once, numbered: `Type a number to change one, Enter if all are right`. A number goes back to that question, the same way as `<`. |
| change-answer after an AI step used it | When later items rely on the item you changed, Forja offers to redo the step that wrote them, in fix mode, for those items only. Nothing is redone without asking. |
| Run names | Every run has a unique name; a name already used is refused. A ticket number is best. `forja status` and `forja resume` show when each run started and when it was last updated. |
| Something running | A loading line with a spinner, what runs and for how long, for every agent and every check: `⠹ checking the repo for secrets · 0:07`. Agents running together share one line. `FORJA_NO_SPINNER=1` turns it off; `FORJA_ASCII=1` uses plain characters. |
| A plan | Can be opened in the pager (`less`): scroll with the arrow keys, Space or PgDn, and press `q` to come back. |
| Waiting for you | The terminal bell rings and the window title changes, for example `Forja · waiting for you`. macOS Terminal and iTerm bounce the Dock icon, Windows Terminal flashes the taskbar, most Linux terminals mark the tab. `FORJA_BELL=0` turns the bell off. |
| A plan that can't be applied | Forja shows every reason (a file with secrets, a file that doesn't exist, a module or build file that isn't this repo's) and sends the plan back to the planner once. If it's still wrong, you choose what happens; it never repeats on its own. A planning step that ends without writing its plan counts as failed, with Retry / Stop. |
| A usage limit | Forja always waits for you and offers `1) Retry this step` · `2) Exit (saved, resume later)`. A stopped run continues with `forja resume`, on the AI tool it started with (unless you pass `--tool`). |
| The end | The run's items in the product, its report, and `FORJA-USAGE.md` with time, tokens and cost per agent. Copilot does not report tokens. The skill that usually comes next is offered. |

## The product report

Reports (main menu, or Products → a product → Reports) write the status as Markdown, at three levels, with no AI: `forja report` writes `PRODUCT-REPORT.md` (every kit in lifecycle order, every skill, a What's next per kit); `forja report --kit <kit>` writes `reports/KIT-<kit>.md` (its skills, its stage, what comes next); `forja report --skill <skill>` writes `reports/SKILL-<skill>.md` (every run of it). Each run shows its state, time, tokens and cost, every question it asked with the answer given and the role that answered, the items it wrote, the repo files, what it was built from, outdated work, and its own reports. A run's own report stays under Reports → A run's own report.

| A kit that... | Its section shows |
|---|---|
| never ran on the product | "<kit> wasn't run for this product." |
| ran | its runs (when, skill, state, fix runs, items written), the stage's items by status, every review with its outcome, findings and how each was settled (fixed, fixed in place, open question, accepted with the reason), the approvals, open questions with their answers, change requests on its items, and its own figures: scope, decisions, plan totals, test coverage, story progress |

## Jira

| Step | What happens |
|---|---|
| Export | `planning/jira-import.csv`, rebuilt from the plan's items: Jira's levels one to one (Feature > Epic > Story). Issue Id is the item's number (feature, epic and story share one sequence, so it is unique); Parent is the number of the item one level up. Map Issue Id to Issue Id when importing |
| Labels and components | Labels: the platform (a feature or an epic carries its stories' platforms). Component: the repo that builds the story, by its name, across every platform (each microservice, app or library); a feature or an epic carries every repo of its stories. Map the Component columns to Components when importing |
| Links | Blocks and Relates columns hold the other issue's Issue Id: "A depends on B" is written on B's row (B blocks A) |
| Jira's keys | A feature, epic or story can hold its Jira key (`key: ABC-4`) next to Forja's id: changing it changes no version |

## How many agents at once

3 by default, which keeps you clear of subscription rate limits and keeps a run's cost easy to follow. Raise it per run with `--parallel 6` on an API key or a higher plan.

## Steps that happen outside the terminal

| Step | Why it stays outside |
|---|---|
| The product owner's sign-off with `SIGNOFF.md`, marked by hand, then review-requirements again | A person signs off on the scope, on purpose |
| Offline review: the team's meeting for change requests in review (disputed, taken offline) and outdated work; its decision is entered in Approvals and change requests | People settle what Forja cannot |
| A design section designed outside the shared product folder: the bundle travels by chat, email or a shared drive | The person who knows the stack designs it |
| Committing the changes a development run made | Forja never handles git |
| fix-bug temporary logs: you reproduce the bug on your device; Forja waits | Only you can drive the app |
| Device or interface checks a plan lists as manual | They need a device |
| Signing in to an AI tool: `claude`, `codex login` or `copilot` | Once, in the tool itself |

How the stages fit together, approvals and change requests: [the lifecycle](lifecycle.md).

## The document library

A new run starts by offering the product's documents: a folder or files (requirements, briefs, designs and screenshots,
diagrams, notes, exports in md, txt, pdf, docx, xlsx, pptx, json, html, csv, or pictures). They are kept in
`<product>/documents/`, converted and checked for secrets on this computer (`<product>/library/docs/`), and read once by the
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
writes `DOCUMENT-FINDINGS.md` in its folder: every answer the documents gave and what you did with it. Pictures are read by
AI tools that open images (Claude Code); others list them as not read. Every answer you give is also kept for the whole
product in `<product>/answers.json`, which the follow-up questions and the helper agents read.

