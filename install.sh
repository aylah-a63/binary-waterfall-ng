#!/usr/bin/env bash
# curl -fsSL https://raw.githubusercontent.com/aylah-a63/binary-waterfall-ng/main/install.sh | bash
set -e

REPO="https://github.com/aylah-a63/binary-waterfall-ng.git"

for tool in git python3; do
    command -v "$tool" >/dev/null || { echo "install.sh needs $tool, which is not on PATH" >&2; exit 1; }
done

UNAME="$(uname -s)"
case "$UNAME" in
    Darwin | Linux) ;;
    *) echo "install.sh supports Linux and macOS; on Windows run build.bat instead (got $UNAME)" >&2; exit 1 ;;
esac

SRCDIR="$(mktemp -d)"
trap 'rm -rf "$SRCDIR"' EXIT

echo "Fetching source..."
git clone --depth 1 "$REPO" "$SRCDIR/binary-waterfall-ng"
cd "$SRCDIR/binary-waterfall-ng"

./build.sh

if [ "$UNAME" = "Darwin" ]; then
    rm -rf "/Applications/binary-waterfall.app"
    mv binary-waterfall.app /Applications/
    echo "Installed /Applications/binary-waterfall.app"
else
    BINDIR="$HOME/.local/bin"
    mkdir -p "$BINDIR"
    mv binary-waterfall "$BINDIR/"
    echo "Installed $BINDIR/binary-waterfall"

    ICONDIR="$HOME/.local/share/icons"
    APPDIR="$HOME/.local/share/applications"
    mkdir -p "$ICONDIR" "$APPDIR"
    cp src/binary_waterfall/resources/icon.png "$ICONDIR/binary-waterfall.png"
    # Icon is an absolute path so it resolves without a themed icon directory.
    cat > "$APPDIR/binary-waterfall.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Name=Binary Waterfall
Comment=A Cross-Platform Raw Data Media Player
Exec=$BINDIR/binary-waterfall
Icon=$ICONDIR/binary-waterfall.png
Terminal=false
Categories=AudioVideo;Player;
StartupWMClass=binary-waterfall
DESKTOP
    command -v update-desktop-database >/dev/null && update-desktop-database "$APPDIR"
    echo "Installed $APPDIR/binary-waterfall.desktop"

    case ":$PATH:" in
        *":$BINDIR:"*) ;;
        *) echo "Note: $BINDIR is not on your PATH" ;;
    esac
fi
