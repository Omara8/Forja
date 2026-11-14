# Installing, updating and removing Forja

[← Forja](../README.md)

Forja comes in two parts, from the same release on github.com/Omara8/Forja: the **desktop app** (the main way to use it, with Forja's
engine inside) and the **`forja` command** (setup, upgrade, doctor, the log). Each installs all six kits at once, plus `shared/`, the
files they all use, ready to run: compiled, with its own Python 3.13. Install either or both; they work on the same products.

## Requirements

- macOS on Apple Silicon (M1 or newer), Linux (x64) or Windows (x64). An Intel Mac stays on Forja 0.9.0: the installers, brew and
  `forja upgrade` stop with "Forja needs an Apple Silicon Mac (M1 or newer)." and change nothing, so the 0.9.0 already installed
  keeps working. There is no desktop app for Intel Macs.
- At least one AI tool, signed in with a subscription or an API key: Claude Code (`claude`), OpenAI Codex (`codex`) or the GitHub Copilot command line (`copilot`).
- Nothing else: no Python to install.

## The desktop app

Download the file for your computer from the [latest release](https://github.com/Omara8/Forja/releases/latest):

| Computer | File | How |
|---|---|---|
| macOS, Apple Silicon | `.dmg` | Open it and move Forja into Applications |
| Windows (x64) | `.msi`, or the setup `.exe` | Run it; the setup `.exe` installs for your user only, with no administrator rights |
| Linux (x64) | `.AppImage`, or `.deb` | The `.AppImage` runs as it is once made runnable (`chmod +x` followed by its full path); the `.deb` installs with your package manager, for example `sudo apt install` followed by the file's full path |

The first start sets Forja up on this computer by itself: your products go in `Documents/Forja-Products` (Settings → Storage moves them), the first AI tool it finds is the active one, and earlier archives stay where they are. Then Settings → AI tools opens, to sign in and pick the active tool. A terminal install (`forja setup`) asks the same questions in the terminal instead.

Forja is built on free tiers only, so the macOS and Windows apps are not signed by Apple or Microsoft. Every release file is signed
with Sigstore instead (its `.sigstore.json` and `.sha256` sit next to it on the release). The first launch asks once:

| Computer | What you see | What to do |
|---|---|---|
| macOS | "Forja" cannot be opened because Apple cannot check it | 1. Open System Settings → Privacy & Security. 2. Scroll to the message about Forja and choose Open Anyway. 3. Confirm with your password. macOS remembers it |
| macOS | "Forja" is damaged and cannot be opened | The download kept a quarantine mark. Type `xattr -dr com.apple.quarantine /Applications/Forja.app` in Terminal once, then open it again |
| Windows | Windows protected your PC (SmartScreen), publisher unknown | 1. Choose More info. 2. Choose Run anyway. Windows remembers it for this file |

The app checks its engine before it starts it: the engine's SHA-256 must match the value built into the app, else it refuses to
start it. Settings → About shows the engine's version and checks for an update; an update is a new release of the app.

## The `forja` command

| Computer | Command | Forja goes in |
|---|---|---|
| macOS or Linux, brew | `brew tap Omara8/forja https://github.com/Omara8/Forja && brew install omara8/forja/forja` | brew's own folder (`/opt/homebrew` on macOS, `/home/linuxbrew/.linuxbrew` on Linux) |
| macOS, curl | `curl -fsSL https://github.com/Omara8/Forja/releases/latest/download/install.sh \| sh` | `~/forja` (no administrator password) |
| Linux, curl | the same command | `/opt/forja` (sudo once), and the `forja` command in `/usr/local/bin` |
| Windows, PowerShell | `irm https://github.com/Omara8/Forja/releases/latest/download/install.ps1 \| iex` | `%USERPROFILE%\forja` (no administrator rights) |

The installers are files of each release (the commands above take the newest one). They download the release for your computer and check it before anything is put in place: with [cosign](https://docs.sigstore.dev) installed, its Sigstore signature (it must come from Forja's release workflow); without cosign, its SHA-256 only, and they say the signature was not checked. The release workflow signs every file of a release; each has its `.sha256` and its `.sigstore.json`. `FORJA_VERSION=0.11.2` installs a given release; `FORJA_ROOT=<folder>` another folder (never a hidden one).

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
| This computer's own state | `Forja-Archive/_local/`: `paths.json` (each product's and repository's folder here), `locks/` (one file per running job), `tmp/` (jobs' working files, deleted when each job ends), `logs/` (Forja's one log: `forja.jsonl`, five files of 5 MB at most, secrets removed), `cache/`, `kits/<kit>/` |
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

The desktop app updates as an app (Settings → About → Check for an update). One Forja version is installed per computer. Installing a newer version migrates every product this computer knows to it before
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
| Signing | Every download has a SHA-256 the installers check, and a Sigstore (cosign) signature from Forja's release workflow. macOS: every native file is signed ad hoc (no Apple Developer ID); the desktop app is not notarised. Windows: `python.exe` is signed by the Python Software Foundation; Forja's own `.pyd` files and the desktop app's installers are not signed (SmartScreen shows an unknown publisher) |
| What runs | `bin/forja` → `python/` → `app/core/forja_main.py` (a one-line loader) → Forja's compiled modules. No `.py` source and no prompt in plain text ships |
| Fingerprints | `app/BUILD.json` lists the SHA-256 of every shipped file and is checked at every start: a changed install stops with a plain message (only `forja doctor`, `forja upgrade` and `forja uninstall` still run). `app/IT-NOTE.md` lists them for people |
| Desktop app | Tauri 2 with plain HTML, CSS and JavaScript. Its content security policy allows only its own files and no inline script; it may call only its engine and the open and save dialogs. The engine runs as its sidecar over standard input and output, never a network port, after its SHA-256 is checked |
| Hooks Forja did not write | `forja doctor` and the app's Settings → Safety list the hooks, MCP servers and allow rules in Claude Code's, Codex's and Copilot's user settings that Forja did not write; Forja warns at start when that list changed, and a Claude Code user hook Forja did not write stops a start |
| Releases | Built by the private repository's workflow with every action pinned to a commit, read-only permissions except the publishing job, build tools pinned by version and SHA-256; published as a draft Release and a pull request on the public repository that the owner approves before anything is published |
| Network | Forja's own code makes no network calls. `forja upgrade` runs brew or the installer, which download from github.com; the desktop app's update check reads the release's `latest.json` on github.com |

## Forja 0.6.4 and earlier (from a zip)

0.6.4 installed from its release zip with Python 3.9 or later on the computer: `unzip forja-0.6.4.zip && cd forja-0.6.4 && ./install.sh` (Windows: `py install.py`). Forja lived in the archive, in `Forja-Archive/_tools/`, with its settings in `_tools/config/`, and `Forja-Archive/_tools/uninstall.sh` removed it. Setting up a newer Forja on such a computer replaces that `_tools/` folder (question 3 above); products made before 0.7.3 are moved whole, untouched, into `<archive>/legacy/<date>/`.
