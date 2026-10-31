# Installing, updating and removing Forja

[← Forja](../README.md)

Forja installs all six kits at once, plus `shared/`, the files they all use. It comes ready to run: compiled, with its own Python 3.13, from github.com/Omara8/Forja.

## Requirements

- macOS (Apple Silicon or Intel), Linux (x64) or Windows (x64).
- At least one AI tool, signed in with a subscription or an API key: Claude Code (`claude`), OpenAI Codex (`codex`) or the GitHub Copilot command line (`copilot`).
- Nothing else: no Python to install.

## Install

| Computer | Command | Forja goes in |
|---|---|---|
| macOS or Linux, brew | `brew tap Omara8/forja https://github.com/Omara8/Forja && brew install omara8/forja/forja` | brew's own folder (`/opt/homebrew`, `/usr/local`, or `/home/linuxbrew/.linuxbrew` on Linux) |
| macOS, curl | `curl -fsSL https://raw.githubusercontent.com/Omara8/Forja/main/install.sh \| sh` | `~/forja` (no administrator password) |
| Linux, curl | the same command | `/opt/forja` (sudo once), and the `forja` command in `/usr/local/bin` |
| Windows, PowerShell | `irm https://raw.githubusercontent.com/Omara8/Forja/main/install.ps1 \| iex` | `%USERPROFILE%\forja` (no administrator rights) |

The installers download the release for your computer, check its SHA-256 and only then put it in place. `FORJA_VERSION=0.7.3` installs a given release; `FORJA_ROOT=<folder>` another folder (never a hidden one).

The first `forja` (or `forja setup` at any time) sets up this computer:

| # | Question | Notes |
|---|---|---|
| 1 | **Archive location** | New install: `Desktop/Forja-Archive`. Forja works on one computer, offline: a folder a cloud service copies elsewhere gets a warning, because the archive and its products stay on this computer |
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
| This computer's own state | `Forja-Archive/_local/`: `paths.json` (each product's and repo's folder here), `locks/` (one file per running run), `tmp/` (runs' working files, deleted when each run ends), `cache/`, `kits/<kit>/` |
| Earlier archives | `Forja-Archive/_old_archive/` |
| Products made before 0.7.3 | `Forja-Archive/legacy/<date>/`, moved whole and untouched |
| Products | `Forja-Archive/<product>/` by default, or another folder on this computer (Products → Move) |
| The `forja` command on PATH | brew: brew's `bin`. macOS curl: `~/forja/bin`, added in `.zshrc`. Linux curl: `/usr/local/bin/forja`. Windows: `%USERPROFILE%\forja\bin` on the user PATH |
| Guard hooks (settings that point at Forja's guard) | `~/.codex/hooks.json`, `~/.copilot/hooks/`, and `~/.claude/settings.json` only when you answer yes to question 5. These are the AI tools' own settings files: Forja writes an entry there, and the guard itself runs from Forja's folder |

No Forja file is ever run from a hidden folder. The one hidden folder Forja is ever in is brew's own on Linux.

## Update

| Installed with | Update |
|---|---|
| brew | `brew upgrade omara8/forja/forja` (or `forja upgrade`) |
| curl | Run the install command again (or `forja upgrade`) |
| PowerShell | Run the install command again (or `forja upgrade`, which runs it in a new window) |

An update replaces `app/`, `python/` and `bin/` only. On its next start, Forja points its hooks at the new version by itself.

One Forja version is installed per computer. Installing a newer version migrates every product this computer knows to it before
anything else runs: forced, no opt-out, with progress per product (`forja migrate` runs the same step by hand). A product whose
folder isn't there is migrated when it is next picked. Products made before 0.7.3 are not migrated: on install, on update and by
`forja migrate`, the ones in the archive are moved whole, untouched, into `<archive>/legacy/<date>/`, and this computer forgets
them; one kept outside the archive is only forgotten (its folder stays where it is). `forja migrate` stays for later migrations.
When a product can't be migrated, a source install keeps the version you had in place and changes nothing.

## Uninstall

```bash
forja uninstall                     # brew: then  brew uninstall omara8/forja/forja  and  brew untap omara8/forja
```

This removes Forja's hooks and settings, then (curl, PowerShell) Forja itself and its PATH entry. It never deletes your products
or the archive: they stay where they are, and a later install picks them up again. Delete them yourself if you no longer need them.

## For IT and security teams

| | |
|---|---|
| Signing | Every download has a SHA-256 the installers check, and a Sigstore (cosign) signature from Forja's release workflow. macOS: every native file is signed ad hoc (no Apple Developer ID). Windows: `python.exe` is signed by the Python Software Foundation; Forja's own `.pyd` files are not signed |
| What runs | `bin/forja` → `python/` → `app/core/forja_main.py` (a one-line loader) → Forja's compiled modules. No `.py` source and no prompt in plain text ships |
| Fingerprints | `app/IT-NOTE.md` lists the SHA-256 of every file; `forja doctor` compares them |
| Network | Forja's own code makes no network calls. `forja upgrade` runs brew or the installer, which download from github.com |

## Forja 0.6.4 and earlier (from a zip)

0.6.4 installed from its release zip with Python 3.9 or later on the computer: `unzip forja-0.6.4.zip && cd forja-0.6.4 && ./install.sh` (Windows: `py install.py`). Forja lived in the archive, in `Forja-Archive/_tools/`, with its settings in `_tools/config/`, and `Forja-Archive/_tools/uninstall.sh` removed it. Setting up a newer Forja on such a computer replaces that `_tools/` folder (question 3 above); products made before 0.7.3 are moved whole, untouched, into `<archive>/legacy/<date>/`.
