#!/bin/sh
# Forja installer and updater for macOS and Linux.
#
#   curl -fsSL https://raw.githubusercontent.com/Omara8/Forja/main/install.sh | sh
#
# Run it again to update: it replaces Forja and keeps your settings, archive and products.
#   FORJA_VERSION=0.7.0 ...   a given release instead of the newest
#   FORJA_ROOT=<folder> ...   another install folder
#
# Where Forja goes (never a hidden folder):
#   macOS   ~/forja                   (no administrator password)
#   Linux   /opt/forja                (sudo once), and the forja command in /usr/local/bin
#   Settings, every OS: ~/forja/config
set -eu

REPO="Omara8/Forja"
say() { printf '%s\n' "$*"; }
fail() { printf 'Forja installer: %s\n' "$*" >&2; exit 1; }

# 1 this computer
case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux) OS=linux ;;
  *) fail "this installer is for macOS and Linux. On Windows, in PowerShell: irm https://raw.githubusercontent.com/$REPO/main/install.ps1 | iex" ;;
esac
case "$(uname -m)" in
  arm64|aarch64) ARCH=arm64 ;;
  x86_64|amd64) ARCH=x64 ;;
  *) fail "no Forja build for $(uname -m)" ;;
esac
if [ "$OS" = macos ] && [ "$ARCH" = x64 ] && [ "$(sysctl -n sysctl.proc_translated 2>/dev/null || echo 0)" = 1 ]; then
  ARCH=arm64                                     # an Intel terminal on Apple Silicon (Rosetta): the native build is faster
fi
[ "$OS-$ARCH" = linux-arm64 ] && fail "no Forja build for Linux on ARM yet"
PLAT="$OS-$ARCH"
if [ "$OS" = macos ]; then DEFAULT_ROOT="$HOME/forja"; else DEFAULT_ROOT="/opt/forja"; fi
ROOT="${FORJA_ROOT:-$DEFAULT_ROOT}"
case "$ROOT" in */.*) fail "$ROOT is inside a hidden folder: Forja never installs in one (choose another FORJA_ROOT)" ;; esac

SUDO=""
mkdir -p "$ROOT" 2>/dev/null || true
if [ ! -w "$ROOT" ] && [ ! -w "$(dirname "$ROOT")" ]; then
  command -v sudo >/dev/null 2>&1 || fail "$ROOT is not writable and sudo is not available"
  say "Forja goes in $ROOT: sudo asks for your password once."
  SUDO="sudo"
  $SUDO mkdir -p "$ROOT"
  $SUDO chown "$(id -u):$(id -g)" "$ROOT"
fi

# 2 the release
ASSET="forja-$PLAT.tar.gz"
if [ -n "${FORJA_DOWNLOAD_BASE:-}" ]; then
  BASE="$FORJA_DOWNLOAD_BASE"                    # a mirror, or a local folder served for testing
elif [ "${FORJA_VERSION:-latest}" = latest ]; then
  BASE="https://github.com/$REPO/releases/latest/download"
else
  BASE="https://github.com/$REPO/releases/download/v${FORJA_VERSION#v}"
fi
command -v curl >/dev/null 2>&1 || fail "curl is needed"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/forja-install.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT INT TERM
say "Downloading Forja ($PLAT) ..."
curl -fsSL "$BASE/$ASSET" -o "$TMP/$ASSET" || fail "could not download $BASE/$ASSET"
curl -fsSL "$BASE/$ASSET.sha256" -o "$TMP/$ASSET.sha256" || fail "could not download the checksum $BASE/$ASSET.sha256"

# 3 the checksum: nothing is replaced unless it matches
WANT="$(cut -d' ' -f1 < "$TMP/$ASSET.sha256")"
if command -v sha256sum >/dev/null 2>&1; then GOT="$(sha256sum "$TMP/$ASSET" | cut -d' ' -f1)"
else GOT="$(shasum -a 256 "$TMP/$ASSET" | cut -d' ' -f1)"; fi
[ -n "$WANT" ] && [ "$WANT" = "$GOT" ] || fail "checksum mismatch for $ASSET (expected $WANT, got $GOT): nothing was changed"
say "Checksum OK ($GOT)"

# 4 unpack next to the current install, then swap (settings in ~/forja/config are never touched)
NEW="$ROOT/_new"
rm -rf "$NEW" && mkdir -p "$NEW"
tar -xzf "$TMP/$ASSET" -C "$NEW"
[ -x "$NEW/bin/forja" ] && [ -f "$NEW/app/BUILD.json" ] || fail "the download is not a Forja bundle: nothing was changed"
for d in app python bin; do
  rm -rf "$ROOT/_old_$d"
  [ -e "$ROOT/$d" ] && mv "$ROOT/$d" "$ROOT/_old_$d"
  mv "$NEW/$d" "$ROOT/$d"
done
rm -rf "$NEW" "$ROOT/_old_app" "$ROOT/_old_python" "$ROOT/_old_bin"
VERSION="$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' "$ROOT/app/BUILD.json" | head -1)"

# 5 the forja command
if [ "$OS" = linux ]; then
  if [ -w /usr/local/bin ]; then ln -sf "$ROOT/bin/forja" /usr/local/bin/forja
  else sudo ln -sf "$ROOT/bin/forja" /usr/local/bin/forja; fi
else
  LINE="export PATH=\"$ROOT/bin:\$PATH\""
  for RC in "$HOME/.zshrc" "$HOME/.bash_profile"; do
    [ "$RC" = "$HOME/.bash_profile" ] && [ ! -f "$RC" ] && continue
    touch "$RC"
    if ! grep -q '# >>> forja >>>' "$RC"; then
      printf '\n# >>> forja >>>\n%s\n# <<< forja <<<\n' "$LINE" >> "$RC"
    fi
  done
fi

# 6 set up this computer the first time (an update keeps the setup; Forja updates its hooks on its next start)
say "Forja $VERSION is installed in $ROOT"
if [ -f "$HOME/forja/config/forja.json" ]; then
  say "Updated. Your settings, archive and products are as they were. Type: forja"
elif (exec < /dev/tty) 2>/dev/null; then           # a terminal to ask in (curl | sh reads the script from stdin)
  "$ROOT/bin/forja" setup < /dev/tty || say "Setup did not finish: run  forja setup  when you are ready."
else
  say "Next: open a new terminal and run  forja setup"
fi
[ "$OS" = macos ] && say "(In this terminal, run  export PATH=\"$ROOT/bin:\$PATH\"  or open a new one.)"
exit 0
