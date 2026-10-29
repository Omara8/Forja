# Which model runs what

[← Forja](../README.md)

Every agent step is tagged with a tier: cheap, mid or strong. Each skill's README lists its agents and their tiers.

| Tier | Claude Code | Codex | GitHub Copilot |
|---|---|---|---|
| cheap | `haiku` | the model set in Codex, reasoning effort low | the model set in Copilot |
| mid | `sonnet` | the model set in Codex, reasoning effort medium | the model set in Copilot |
| strong | `opus` | the model set in Codex, reasoning effort high | the model set in Copilot |

The Claude names are aliases, so they always mean the newest version of each model. To change the mapping, edit `~/forja/config/models.json` (`%USERPROFILE%\forja\config\models.json` on Windows; Forja 0.6.x: `Forja-Archive/_tools/config/models.json`). Choose the AI tool per run with `--tool claude|codex|copilot`.
