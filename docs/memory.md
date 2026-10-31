# What Forja remembers, and your project's own skills

[← Forja](../README.md)

## Per repo

| What | Where | How to change it |
|---|---|---|
| Saved answers (the code to follow, linters, coverage source …) | The repo's entry in the product (`repos/<repo>.json`, `settings`) | Menu → Saved answers for a repo |
| Team rules (rules every agent follows in every run, such as "use our logging helper") | team-rule objects in the product | Menu → Saved answers for a repo; or keep a correction as a team rule when a run offers it (a "Follow" answer). A removed rule stops applying and can be made active again |
| Helpers a build added | `repos/<repo>/helpers/<name>.json` in the product, with the file's fingerprint | Kept by the building skill; handed to later stories while the file still matches |
| The repo's folder on this computer | `Forja-Archive/_local/paths.json` | `forja repos path` |
| The project's own skills and agents, as the agents read them | `Forja-Archive/_local/cache/repos/<repo key>/_cache/forja/project-skills.md` | Rebuilt at the start of every development run |

Answers live in the runs that asked them (`runs/<run-id>/run.json`); later questions and agents read the newest answer per question.

## The project's own skills and agents (development)

If the repo has its own AI skills or agents, the development agents follow them as the project's rules. Forja **never runs** them; it only reads their text.

| | |
|---|---|
| Where it looks | Skills: `.claude/skills`, `.github/skills`, `.agents/skills`, `.codex/skills` (each `SKILL.md`, plus up to 4 reference `.md` files in the same folder). Agents: `.claude/agents/*.md`, `.github/agents/*.md`, `.codex/agents/*.toml`. Only the repo, not your personal skills |
| What you are asked | The first time, Forja lists what it found: use all of them, pick which ones, or none. After that it asks again only when new ones appear |
| Safety | Git-ignored files are never read. Each file is checked by secretgate first; a file that may hold a secret, or cannot be checked, is left out and named. The agents read them as material, never as instructions to follow |
| Order the agents follow | The team rules first, then the project's skills and agents, then the kit's own defaults. A conflict with the plan or your request becomes a deviation for you to decide |
| Size | Up to about 15,000 tokens in total, 20,000 characters per skill or agent; longer ones are cut and named |
