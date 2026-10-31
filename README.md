<p align="center">
<picture><source media="(prefers-color-scheme: light)" srcset="docs/assets/readme/hero-day.svg"><img src="docs/assets/readme/hero-night.svg" alt="Forja: your AI kits, headless, from one terminal command. A hammer strikes the anvil and the A of FORJA tips over into the prompt."></picture>
</p>

<p align="center">
<img src="https://img.shields.io/badge/forja-0.7.3-e8571c?style=flat-square&labelColor=20242b" alt="Forja 0.7.3">
<img src="https://img.shields.io/badge/lifecycle-requirements%20%E2%86%92%20code-2f6fb5?style=flat-square&labelColor=20242b" alt="Lifecycle: from requirements to code">
<img src="https://img.shields.io/badge/kits-6%20·%2037%20skills%20·%2056%20agents-d9b45a?style=flat-square&labelColor=20242b" alt="6 kits, 37 skills, 56 agents">
<img src="https://img.shields.io/badge/runs%20on-claude%20·%20codex%20·%20copilot-69727f?style=flat-square&labelColor=20242b" alt="Runs on Claude Code, Codex or GitHub Copilot">
<img src="https://img.shields.io/badge/macOS%20·%20Linux%20·%20Windows-69727f?style=flat-square&labelColor=20242b" alt="macOS, Linux and Windows">
<img src="https://img.shields.io/badge/license-proprietary-69727f?style=flat-square&labelColor=20242b" alt="Proprietary license">
</p>

<p align="center"><b><a href="#install">Install</a> · <a href="#update-and-uninstall">Update</a> · <a href="#how-a-run-works">How a run works</a> · <a href="#the-lifecycle">The lifecycle</a> · <a href="#kits-and-skills">Kits and skills</a> · <a href="#safety">Safety</a> · <a href="#commands">Commands</a></b></p>

Forja runs AI kits from one terminal command: understanding a legacy system, requirements, architecture, delivery planning, test preparation and development. You answer the questions; agents do the work in the background with Claude Code, Codex or GitHub Copilot, on your subscription or an API key. Every kit writes into one product: tickets for the work, objects for every fact, each field owned by one role. Secrets and hidden AI instructions are stopped before any agent reads a thing, and every agent is fenced to its own step. Forja runs on one computer, from one terminal, offline.

> 0.7.x is an experimental line: Forja installed with brew, curl or PowerShell, compiled, with its prompts encrypted.

## Install

| Computer | Command |
|---|---|
| macOS or Linux, brew | `brew tap Omara8/forja https://github.com/Omara8/Forja && brew install omara8/forja/forja` |
| macOS or Linux, curl | `curl -fsSL https://raw.githubusercontent.com/Omara8/Forja/main/install.sh \| sh` |
| Windows, PowerShell | `irm https://raw.githubusercontent.com/Omara8/Forja/main/install.ps1 \| iex` |

Then type `forja`. The first run sets up this computer: where your archive goes and which AI tools to use (`forja setup` runs it again).

| You need | |
|---|---|
| One AI tool, signed in | `claude`, `codex` or `copilot` |
| Nothing else | Forja brings its own Python 3.13 |

| Where | What |
|---|---|
| `~/forja` (macOS, curl) · `/opt/forja` (Linux, curl) · `%USERPROFILE%\forja` (Windows) · brew's own folder (brew) | Forja itself: `bin/` (the command), `python/`, `app/` |
| `~/forja/config` | Your settings, kept on every update |
| `Desktop/Forja-Archive` by default, on this computer | Your products, runs and this computer's caches. Uninstalling never deletes them |

Nothing is installed in a hidden folder, except brew's own on Linux (`/home/linuxbrew/.linuxbrew`). Every download is checked against its SHA-256 before anything is replaced. More: [installing, updating, uninstalling](docs/installing.md).

## Update and uninstall

| | brew | curl or PowerShell |
|---|---|---|
| Update | `brew upgrade omara8/forja/forja` | Run the install command again |
| From Forja | `forja upgrade` | `forja upgrade` |
| Uninstall | `forja uninstall`, then `brew uninstall omara8/forja/forja` | `forja uninstall` |

An update keeps your settings, archive and products. Products made before 0.7.3 are moved whole, untouched, into `<archive>/legacy/<date>/`. Uninstalling never deletes the archive or the products.

<picture><source media="(prefers-color-scheme: light)" srcset="docs/assets/readme/terminal-day.svg"><img src="docs/assets/readme/terminal-night.svg" alt="A Forja run in the terminal: Forja confirms the repo, checks it for secrets, applies the project's own skills, runs the agents with their cost, asks you to approve the plan, then reports the result. You review and commit the changes yourself."></picture>

## How a run works

<picture><source media="(prefers-color-scheme: light)" srcset="docs/assets/readme/runflow-day.svg"><img src="docs/assets/readme/runflow-night.svg" alt="Six steps: you start one command in any folder; secretgate finds and fences secrets; the gate stops hidden AI instructions in anything given to the agents; the kit's scripts gather facts, checks and plans; agents run as one fresh call per step, each writing only its own sandbox; the product keeps the tickets, the objects, the reports and the run record. Only the agents spend AI tokens."></picture>

| | |
|---|---|
| **One fresh call per step** | Each agent gets only the files it needs, no shell, no web, and ends; nothing carries over |
| **Agents answer, Forja writes** | A writing agent never writes the product. It gets its own sandbox in the run and writes one JSON file per item there: `sandbox-business-rule-1.json` for a new item (its links name its other new items by those sandbox names, existing items by their real ids), `changes/flow-3.json` for a change to an existing item, then `DONE.json` last. When the agent stops, Forja takes its sandbox in turn (first come, first served): it gives each new item its real id, rewrites the links, writes the whole set through the write gateway, all or nothing, and clears the sandbox. A sandbox that touches what an earlier one just wrote is checked again by its agent; one that fails gets one re-run with the reasons, then one fresh retry, then Forja stops and tells you why all three failed. Review agents return their findings in a JSON file |
| **You decide** | Drafts are shown for review; writing skills show their plan first: all of it, part of it, or ask for changes |
| **Nothing assumed** | No technical question has a default. Each shows the recommended option with its reason; you choose |
| **One way to answer** | Pick by number; every choice ends with Other (type your own): the answer interpreter reads your words against everything answered so far and asks a follow-up until the answer is solid. `?` explains any question; `!` at a technical question recommends one to three choices for this product (you still choose); `+` explains the requirement objects a question must meet |
| **Document library** | A new run first asks for the product's documents (requirements, designs, screenshots, exports): read once, secrets removed first; each later question they answer shows the quote and the file, for you to confirm or edit |
| **Exit any time** | Every numbered question ends with Exit (saved); `forja resume` continues at the same question |
| **Runs are the history** | Each run keeps its record in `runs/<run-id>/run.json`: every question with its raw answer (`<run-id>#<n>`), the versions it read, its outcome; `outputs/` keeps what the run produced. Working files live in `_local/tmp/` and go when the run ends; one lock per run in `_local/locks/` |
| **Runs named by ticket** | A run's name is how resume and reports find it (`ABC-200`) |

More: [running Forja](docs/running.md).

## The lifecycle

| Stage | Kit | Command | Approving role | Review skill: what it approves |
|---|---|---|---|---|
| Understand the existing system | code-insight | `forja insight` | none | Writes reports only (`repos/<repo>/insight/`); owns no object |
| Requirements | scope-clarity | `forja requirements` | product owner | review-requirements: APPROVED-SCOPE.md |
| Architecture | architecture-blueprint | `forja architecture` | tech lead | review-architecture: HIGH-LEVEL-DESIGN.md, DESIGN-MAP.html |
| Planning | delivery-cadence | `forja planning` | delivery lead | planning-check: PLAN.md and the Jira tickets |
| Test plan | test-readiness | `forja test-plan` | QA lead | review-test-coverage: TEST-PLAN.md, COVERAGE.md |
| Development | code-velocity | `forja development` | `<platform>` developer | None: tickets move through their workflow (Backlog → To Do → In Progress → Done) |

Two modes, set once when the product is added. **A new product**: stages run in order, and there is no "start anyway": requirements start any time; architecture starts any time, but Forja offers to wait for the requirements while they are not approved; planning needs the requirements and the architecture approved; the test plan and development need planning approved. **An existing project** (code your team already has): any kit runs at any time, there are no approvals, and the first screen offers code-insight (it reverse-engineers the whole codebase: time and AI usage) or development straight away; a Jira ticket you paste becomes that same ticket type. Each kit's skills and the role each skill acts for are in its README. More: [the lifecycle](docs/lifecycle.md).

## Products, tickets and objects

| | |
|---|---|
| **Product** | Everything about one piece of software, one repo or ten. It lives in one folder on this computer (`Forja-Archive/<product>/` by default) |
| **Repos by name** | A product knows each repo by name; this computer keeps its folder in `_local/paths.json`, never in the product |
| **Objects** | Every fact: `objects/<type>/<id>.json` (need, scope-item, business-rule, component, contract, test-scenario …). Ids are the type's prefix and a number, never padded: rule-12, criterion-7 |
| **Tickets** | The Jira work: `tickets/<type>/<id>.md` (feature, epic, story, task, sub-task, bug, spike). A JSON block, the prose, then generated previews of what the ticket references |
| **Versions** | A content change makes a new version; the old one is kept in `_versions/`. A state change makes none. Each ticket and object has a version log (`<type>/_versions/<id>.log.json`): one line per content version with its time, run and cause. Items carry no run or cause field |
| **Ownership** | `ownership.json` gives every field one owner. The write gateway checks every change against it |
| **Write gateway** | The one function every write goes through. It checks the model (who may write which field, allowed status moves, field shapes, links), writes all or nothing, and adds a line to each changed item's version log |
| **Platforms** | A product always has at least one platform: creating one without any is refused, and opening one without any asks for them first |
| **Generated documents** | `generated-documents/`: SCOPE-DRAFT.md, APPROVED-SCOPE.md, HIGH-LEVEL-DESIGN.md, PLAN.md, TEST-PLAN.md, COVERAGE.md and the reports, rebuilt from the objects and tickets; never read back |
| **On pick** | Picking a product checks its version (migrating it when needed), checks every file against the model (a file that breaks it is listed as a warning: the product still opens, and skills skip that item until you fix it by hand), marks stale questions, rebuilds previews, clears temporary folders a crash left, pauses runs that stopped, and warns when another Forja has it open |
| **Products before 0.7.3** | Moved whole, untouched, into `<archive>/legacy/<date>/` on install, on update and by `forja migrate`. One kept outside the archive is only forgotten by this computer; its folder stays where it is |
| **Mode** | Set once when the product is added: a new product (stage order and approvals) or an existing project (any kit at any time, no approvals) |
| **Export and import** | No sync: a teammate gets a product only through Forja. Products → the product → Export it writes one `<name>-<date>.forja-product.zip` (its record, never your code, repo paths, generated documents or library); they add it with Products → Add a product → A product a teammate exported. A product their computer already has is refused. Before an export Forja lists what goes in (source-documents/ can be left out); before an import it shows what the file holds, checks every text in it for hidden instructions and every item against the model |
| **Remove** | Products → Remove forgets a product on this computer; its folder stays. Uninstalling Forja never deletes products |

## Reviews, approvals and change requests

| | |
|---|---|
| **Review** | Each stage's review skill runs the stage-reviewer over every live item of the stage: findings (gap, conflict, duplicate, coverage, quality), each open, settled or closed. The owner decides each one; fixes run up to the product's loop limit (Products → Settings) |
| **No longer needed** | After the review, Forja lists the items nothing needs any more (all their links point at retired, cancelled, superseded or out-of-scope items, or a criterion, flow or scenario points at nothing). The approving role keeps or cancels them one by one, or cancels them all |
| **Approval** | The approving role approves the stage: the approval freezes only what the review read, each item at its version (requirements also keep the product owner's mark per item). Approving without a review is refused; "Not yet" puts the items back to draft. Requirements written from a modernize report need the sign-off of both the product owner and the tech lead. States: draft, in review, approved. An approved object is never overwritten |
| **Changing approved work** | When nothing built from it has started (neither it nor anything under it is In Progress or Done: feature > epic > story > sub-task, or for a requirement object the tickets built from it), Forja simulates the change and shows a short summary: each field old → new, and what it touches. You accept (a new version; the stage stays approved) or refuse. When work has started, it is a change request |
| **Change an earlier answer** | `forja <kit> change-answer`: a checked edit of an object your kit owns; refused, with what it would break, when a check finds a problem |
| **Change request** | Asking the owning role to change approved work that has started. Simulated on a copy of the product. Once accepted, it creates a new change ticket (label `change`, link `replaces` to the old ticket) in the Backlog for the next sprint; an old ticket still In Progress is cancelled (Done, resolution `cancelled`); a Done ticket stays Done. Everything an accepted change creates counts as approved. States: raised, simulated, applied, declined, in offline review, withdrawn, stale |
| **Bugs** | Never frozen: a bug can be edited or cancelled at any time |
| **Offline review** | The team's decision outside a run: Forja writes `OFFLINE-REVIEW-<run-id>.md`, and the offline-review skill records the outcome with the role |
| **Open questions** | Raised for the role who knows. States: open, in review, done, paused, stale (what it asks about changed), cancelled |
| **Roles, never names** | Every decision is recorded by role (product owner, tech lead, delivery lead, QA lead, `<platform>` developer), never by person |

`forja approvals` lists everything waiting for you.

## Kits and skills

<!-- forja:kits -->
Forja is the tool. Each kit does one part of delivery and holds skills; a skill runs agents (AI) and scripts (no AI). Every skill runs the same way: `forja <command> <skill>`. 6 kits, 37 skills, 56 agents. One install brings all of them: [Install](#install).

| | Kit | Command | For | Skills |
|---|---|---|---|---|
| <img src="docs/assets/readme/kits/kit-code-insight.svg" width="20" height="20" alt=""> | **code-insight** | `forja insight` | Understanding legacy code and planning its rebuild | 4 |
| <img src="docs/assets/readme/kits/kit-scope-clarity.svg" width="20" height="20" alt=""> | **scope-clarity** | `forja requirements` | Requirements: needs, scope, acceptance criteria, sign-off | 5 |
| <img src="docs/assets/readme/kits/kit-architecture-blueprint.svg" width="20" height="20" alt=""> | **architecture-blueprint** | `forja architecture` | Architecture across every stack | 9 |
| <img src="docs/assets/readme/kits/kit-delivery-cadence.svg" width="20" height="20" alt=""> | **delivery-cadence** | `forja planning` | Planning delivery: one plan, each story in the repo that builds it | 5 |
| <img src="docs/assets/readme/kits/kit-test-readiness.svg" width="20" height="20" alt=""> | **test-readiness** | `forja test-plan` | Test preparation: plan, cases, coverage, data, automation | 5 |
| <img src="docs/assets/readme/kits/kit-code-velocity.svg" width="20" height="20" alt=""> | **code-velocity** | `forja development` | Writing, testing and reviewing code | 9 |

<details open>
<summary><img src="docs/assets/readme/kits/kit-code-insight.svg" width="28" height="28" align="absmiddle" alt=""> <b>code-insight</b> · <code>forja insight</code> · 4 skills<br><sub>Understand legacy code and plan its rebuild, with every claim traced to a file.</sub></summary>

| Skill | What it does |
|---|---|
| `feature-report` | One feature from the code: flows, possible bugs, the objects it confirms |
| `explain-code` | One file, method or class explained |
| `architecture-report` | The existing system's structure → ARCHITECTURE.md and DIAGRAMS.html |
| `modernize` | The legacy scope → one report: features, flows, rules, dead code and legacy bugs |

</details>

<details>
<summary><img src="docs/assets/readme/kits/kit-scope-clarity.svg" width="28" height="28" align="absmiddle" alt=""> <b>scope-clarity</b> · <code>forja requirements</code> · 5 skills<br><sub>Turn what stakeholders need into an approved scope, feature by feature, in business language.</sub></summary>

| Skill | What it does |
|---|---|
| `elicit-requirements` | Documents + your answers → needs, goals, scale and success measures |
| `define-scope` | Needs → scope items: what is in and what is out |
| `analyze-requirements` | Scope → business rules with their values, flows with their steps; gaps as questions |
| `define-acceptance-criteria` | Given / When / Then for every flow outcome and rule |
| `review-requirements` | Read-back, review, sign-off and approval → APPROVED-SCOPE.md |

</details>

<details>
<summary><img src="docs/assets/readme/kits/kit-architecture-blueprint.svg" width="28" height="28" align="absmiddle" alt=""> <b>architecture-blueprint</b> · <code>forja architecture</code> · 9 skills<br><sub>Design the whole product before it is built: one high-level design, one section per stack, every conflict answered.</sub></summary>

| Skill | What it does |
|---|---|
| `technical-intake` | Platforms, repositories, constraints and non-functional requirements |
| `evaluate-options` | Two or three ways to build it; you choose one |
| `high-level-design` | Components (each in a repository) and foundations |
| `define-contracts` | The contracts between the components |
| `design-sections` | One section per platform and its modules |
| `review-architecture` | Review and stage approval → HIGH-LEVEL-DESIGN.md |
| `architecture-map` | DESIGN-MAP.html from the objects |
| `architecture-section` | Design one section from a bundle someone sent you |
| `architecture-merge` | Bring a returned section bundle back |

</details>

<details>
<summary><img src="docs/assets/readme/kits/kit-delivery-cadence.svg" width="28" height="28" align="absmiddle" alt=""> <b>delivery-cadence</b> · <code>forja planning</code> · 5 skills<br><sub>Turn an approved scope and an architecture into one plan for the product: each platform plans only what it builds.</sub></summary>

| Skill | What it does |
|---|---|
| `decompose-work` | Features, epics and stories (tickets) from the requirements and architecture |
| `estimate-delivery` | Story points against the team's reference story |
| `map-dependencies` | What blocks what; what the code already has |
| `plan-iterations` | The plan: dates, team, capacity, increments, releases; the backlog order |
| `planning-check` | The planning review, then the approval: the plan's tickets move to To Do |

</details>

<details>
<summary><img src="docs/assets/readme/kits/kit-test-readiness.svg" width="28" height="28" align="absmiddle" alt=""> <b>test-readiness</b> · <code>forja test-plan</code> · 5 skills<br><sub>Prepare every test before development: the plan, the cases, coverage, test data per environment and the automated tests.</sub></summary>

| Skill | What it does |
|---|---|
| `plan-testing` | The test strategy: levels with their tools, environments, entry and exit criteria |
| `create-test-cases` | QA's scenarios per acceptance criterion, and a qa story per dev story |
| `review-test-coverage` | Coverage, the review, then the test plan approval → TEST-PLAN.md, COVERAGE.md |
| `prepare-test-resources` | Each environment's rules, then test resources and tasks (never data in production) |
| `build-test-automation` | QA's automated tests, written into the automation repo |

</details>

<details>
<summary><img src="docs/assets/readme/kits/kit-code-velocity.svg" width="28" height="28" align="absmiddle" alt=""> <b>code-velocity</b> · <code>forja development</code> · 9 skills<br><sub>Build, test, fix, document and review code the way your project already does it.</sub></summary>

| Skill | What it does |
|---|---|
| `new-feature` | Build a feature like the closest existing one, with unit tests |
| `change-feature` | Change a feature: who uses it and which contracts change, first |
| `add-foundation` | A reusable piece built on what exists |
| `refactor` | Behaviour pinned by tests, then ordered refactor steps |
| `write-tests` | Tests for a story, a feature, a class or your current changes |
| `improve-coverage` | Coverage up where it matters, measured like SonarQube, before → after |
| `fix-bug` | Ranked causes, you confirm one, then the fix and a test |
| `write-docs` | High-level and low-level design documentation with diagrams, checked against the code |
| `review-code` | Review a branch before the pull request (never changes code) |

</details>
<!-- /forja:kits -->

## Safety

| Rule | What it means |
|---|---|
| Secrets never reach the AI | Git-ignored and secret files (`.env`, keys, keystores, `google-services.json`, `local.properties`) are never read, and no secret value is ever printed. A file that holds a secret is never changed: it becomes a manual step for you |
| No git | Forja never creates branches, commits or pushes. You review the changes and commit them with your own tools |
| Your project's way wins | Skills follow the project's existing style, its own AI skills and agents, and the team rules your team set. More: [what Forja remembers](docs/memory.md) |
| Agents are fenced | A writing agent writes only its own sandbox; every other agent only its run's work folder. The product folder is read-only to every agent: Forja's write gateway writes the product. No agent is given the whole archive or Forja's own files (run locks, paths, settings). They run no other command; code agents only the repo files of an approved plan. Guards fail closed: if one cannot decide, the read or write is refused |
| Hidden instructions are stopped at the door | Every text that enters Forja passes one gate before any AI sees it: answers you type, pasted Jira or Confluence text, source documents and imported products. Secret-looking lines are removed first. Text written for an AI rather than a person (invisible characters, hidden comments, hidden or white text in Word and web pages, encoded blobs, role markers, phrases that tell an AI to ignore its rules, take a role, hide something or skip a review) is shown to you line by line, and Forja recommends rejecting all of it. Whatever you keep, every agent is told that everything it reads is material, never instructions, and outside text reaches it inside a DATA fence |
| Your data stays yours | No server, no account, no telemetry. One computer, one terminal, offline: two terminals on one product is a known limitation, and Forja warns |
| Forja's own code | Compiled to native modules, its prompts encrypted; IT teams get a SHA-256 list of every file (`app/IT-NOTE.md`) |

## Commands

```text
forja                                  menu: start a run · resume · runs in progress · show a report · products · approvals and change requests · saved answers · doctor
forja <kit>                            a kit's skills (insight, requirements, architecture, planning, test-plan, development)
forja <kit> <skill>                    start a skill
      --product <name>                 which product (skips the question)
      --repo <name>                    which repo of the product
      --name <run>                     the run's name (a ticket number is best)
      --tool claude|codex|copilot      the AI tool for this run (default: the one set at install)
      --parallel N                     agents at once (default 3)
forja <kit> change-answer              change an earlier answer: a checked edit of one object
forja resume [run]                     continue a stopped run (a paused development run can also be abandoned)
forja status                           runs in progress and where each one waits
forja show <run>                       a run's report, in the pager
forja products [add [folder] | move | remove]   the products this computer knows: add (new, existing project, or a teammate's export), export from a product's menu (remove forgets; the folder stays)
forja repos path                       a repo's folder on this computer
forja approvals                        approvals, change requests, offline reviews, open questions
forja spike                            start a spike ticket: research within its time box
forja migrate                          move products made before 0.7.3 into <archive>/legacy/<date>/; kept for later migrations (the installer runs it)
forja report                           the product report (PRODUCT-REPORT.md): every kit and skill, every question and answer
forja report --kit <kit>               one kit's report (reports/KIT-<kit>.md): its skills, its stage, what comes next
forja report --skill <skill>           one skill's report (reports/SKILL-<skill>.md): every run of it
forja doctor                           Python, AI tools, sign-in, hooks and file fingerprints
forja version                          the installed version
forja setup                            set up this computer again: the archive, the AI tools, the hooks
forja upgrade                          update Forja the way it was installed (brew, curl or PowerShell)
forja uninstall                        remove Forja; your products and the archive stay
```

Which model each agent uses: [models](docs/models.md).

<p align="center"><picture><source media="(prefers-color-scheme: light)" srcset="docs/assets/readme/heatband-day.svg"><img src="docs/assets/readme/heatband-night.svg" width="100%" alt=""></picture></p>

<p align="center"><picture><source media="(prefers-color-scheme: light)" srcset="docs/assets/readme/mark-day.svg"><img src="docs/assets/readme/mark-night.svg" width="160" alt="Forja"></picture><br><sub>Proprietary license · nothing leaves your machine except your AI tool's own calls</sub></p>
