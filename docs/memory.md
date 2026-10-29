# What Forja remembers, and your project's own skills

[← Forja](../README.md)

## Per repo

| What | Where | Shared with the team | How to change it |
|---|---|---|---|
| Saved answers (the code to follow, linters, coverage source …) | The repo's entry in the product (`repo.json`, `settings`) | Yes, with the product folder | Menu → Saved answers for a repo |
| Standing rules (corrections every run follows, such as "use our logging helper") | standing-rule items in the product | Yes | Menu → Saved answers for a repo; or keep a correction as a standing rule when a run offers it |
| The repo's folder on this computer | `Forja-Archive/_local/paths.json` | No | `forja repos path` |
| The project's own skills and agents, as the agents read them | `Forja-Archive/_local/cache/repos/<repo key>/_cache/forja/project-skills.md` | No | Rebuilt at the start of every development run |

## The project's own skills and agents (development)

If the repo has its own AI skills or agents, the development agents follow them as the project's rules. Forja **never runs** them; it only reads their text.

| | |
|---|---|
| Where it looks | Skills: `.claude/skills`, `.github/skills`, `.agents/skills`, `.codex/skills` (each `SKILL.md`, plus up to 4 reference `.md` files in the same folder). Agents: `.claude/agents/*.md`, `.github/agents/*.md`, `.codex/agents/*.toml`. Only the repo, not your personal skills |
| What you are asked | The first time, Forja lists what it found: use all of them, pick which ones, or none. After that it asks again only when new ones appear |
| Safety | Git-ignored files are never read. Each file is checked by secretgate first; a file that may hold a secret, or cannot be checked, is left out and named |
| Order the agents follow | The team's standing rules first, then the project's skills and agents, then the kit's own defaults. A conflict with the plan or your request becomes a deviation for you to decide |
| Size | Up to about 15,000 tokens in total, 20,000 characters per skill or agent; longer ones are cut and named |
