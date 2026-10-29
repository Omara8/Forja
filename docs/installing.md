# Installing, updating and removing Forja

[← Forja](../README.md)

Forja installs all six kits at once, plus `shared/`, the files they all use. From 0.7.0 it comes ready to run: compiled, with its own Python 3.13, from github.com/Omara8/Forja.

## Requirements

- macOS (Apple Silicon or Intel), Linux (x64) or Windows (x64).
- At least one AI tool, signed in with a subscription or an API key: Claude Code (`claude`), OpenAI Codex (`codex`) or the GitHub Copilot command line (`copilot`).
- Nothing else: no Python to install.

## Install

| Computer | Command | Forja goes in |
|---|---|---|
| macOS or Linux, brew | `brew tap Omara8/forja https://github.com/Omara8/Forja && brew install forja` | brew's own folder (`/opt/homebrew`, `/usr/local`, or `/home/linuxbrew/.linuxbrew` on Linux) |
| macOS, curl | `curl -fsSL https://raw.githubusercontent.com/Omara8/Forja/main/install.sh \| sh` | `~/forja` (no administrator password) |
| Linux, curl | the same command | `/opt/forja` (sudo once), and the `forja` command in `/usr/local/bin` |
| Windows, PowerShell | `irm https://raw.githubusercontent.com/Omara8/Forja/main/install.ps1 \| iex` | `%USERPROFILE%\forja` (no administrator rights) |

The installers download the release for your computer, check its SHA-256 and only then put it in place. `FORJA_VERSION=0.7.0` installs a given release; `FORJA_ROOT=<folder>` another folder (never a hidden one).

The first `forja` (or `forja setup` at any time) sets up this computer:

| # | Question | Notes |
|---|---|---|
| 1 | **Archive location** | New install: `Desktop/Forja-Archive`. A folder inside OneDrive (its Desktop backup included), Dropbox, Google Drive, iCloud or another synced folder gets a warning: the archive stays on this computer |
| 2 | **Earlier archives** (only when found) | Forja before 0.6.0, Dev-Archive, Modernize-Archive: moved into `_old_archive/` untouched, kept where they are, or cancel |
| 3 | **Forja 0.6.x in the archive** (only when found) | Its `_tools/` folder is replaced: its settings move to `~/forja/config`, its hooks and PATH entry go. Your products stay where they are |
| 4 | **AI tools** | The tools found, how each is signed in, which ones to use and the default |
| 5 | **Secret protection in your own AI sessions** | During Forja runs the AI never reads the files secretgate flagged. Yes applies the same protection when you open the AI tool yourself |
| 6 | **Self-test** | One tiny call per AI tool |

## Where things go

| What | Where |
|---|---|
| Forja itself | `<install folder>/bin` (the `forja` command), `python/` (Python 3.13), `app/` (Forja: compiled modules, encrypted prompts, `BUILD.json`, `IT-NOTE.md`) |
| Your settings | `~/forja/config` (`%USERPROFILE%\forja\config`): `forja.json`, `models.json`. Kept on every update |
| This computer's own state | `Forja-Archive/_local/`: `paths.json` (each repo's folder here), `active-runs.json`, `cache/`, `kits/<kit>/` |
| Earlier archives | `Forja-Archive/_old_archive/` |
| Products kept on this computer | `Forja-Archive/<product>/` (a product can also live in a synced folder: Products → Move) |
| The `forja` command on PATH | brew: brew's `bin`. macOS curl: `~/forja/bin`, added in `.zshrc`. Linux curl: `/usr/local/bin/forja`. Windows: `%USERPROFILE%\forja\bin` on the user PATH |
| Guard hooks (settings that point at Forja's guard) | `~/.codex/hooks.json`, `~/.copilot/hooks/`, and `~/.claude/settings.json` only when you answer yes to question 5. These are the AI tools' own settings files: Forja writes an entry there, and the guard itself runs from Forja's folder |

No Forja file is ever run from a hidden folder. The one hidden folder Forja is ever in is brew's own on Linux.

## Update

| Installed with | Update |
|---|---|
| brew | `brew upgrade forja` (or `forja upgrade`) |
| curl | Run the install command again (or `forja upgrade`) |
| PowerShell | Run the install command again (or `forja upgrade`, which runs it in a new window) |

An update replaces `app/`, `python/` and `bin/` only. On its next start, Forja points its hooks at the new version by itself.

## Uninstall

```bash
forja uninstall                     # brew: then  brew uninstall forja  and  brew untap omara8/forja
```

This removes Forja's hooks and settings, then (curl, PowerShell) Forja itself and its PATH entry, and asks about the archive:

| Choice | What happens |
|---|---|
| Keep the archive | Products, runs and earlier archives stay; a later install picks them up again |
| Delete the archive too | The whole archive folder goes, for good. You type `delete` to confirm; anything else keeps it. Forja refuses to delete a folder that is not a Forja archive |
| Cancel | Nothing changes |

## For IT and security teams

| | |
|---|---|
| Signing | Every download has a SHA-256 the installers check, and a Sigstore (cosign) signature from Forja's release workflow. macOS: every native file is signed ad hoc (no Apple Developer ID). Windows: `python.exe` is signed by the Python Software Foundation; Forja's own `.pyd` files are not signed |
| What runs | `bin/forja` → `python/` → `app/core/forja_main.py` (a one-line loader) → Forja's compiled modules. No `.py` source and no prompt in plain text ships |
| Fingerprints | `app/IT-NOTE.md` lists the SHA-256 of every file; `forja doctor` compares them |
| Network | Forja's own code makes no network calls. `forja upgrade` runs brew or the installer, which download from github.com |

## Forja 0.6.4 and earlier (from a zip)

0.6.4 installed from its release zip with Python 3.9 or later on the computer: `unzip forja-0.6.4.zip && cd forja-0.6.4 && ./install.sh` (Windows: `py install.py`). Forja lived in the archive, in `Forja-Archive/_tools/`, with its settings in `_tools/config/`, and `Forja-Archive/_tools/uninstall.sh` removed it. Setting up 0.7.0 on such a computer replaces that `_tools/` folder (question 3 above).
