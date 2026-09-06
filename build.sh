#!/usr/bin/env bash
set -e

MAINFILENAME=binary-waterfall
MODULENAME=binary_waterfall

ORIGDIR="$(pwd)"
SOURCEDIR="$ORIGDIR/src/$MODULENAME"
DISTDIR="$ORIGDIR/dist"
BUILDDIR="$ORIGDIR/build"

PY="$ORIGDIR/$MAINFILENAME.py"
SPEC="$ORIGDIR/$MAINFILENAME.spec"
TARGETBIN="$ORIGDIR/$MAINFILENAME"

RESOURCEDIR="$SOURCEDIR/resources"
SPLASH_IMG="$RESOURCEDIR/splash.jpg"

UNAME="$(uname -s)"
case "$UNAME" in
    Darwin*) ADDDATA_SEP=":" ; ICON="$RESOURCEDIR/icon.png" ;;
    *)       ADDDATA_SEP=":" ; ICON="$RESOURCEDIR/icon.png" ;;
esac

echo "Cleaning up before making release..."
rm -rf "$TARGETBIN" "$DISTDIR" "$BUILDDIR" "$SPEC"

echo "Building portable binary..."
PYINSTALLER_ARGS=(
    --clean
    --noconfirm
    --windowed
    --add-data "$SOURCEDIR/*.py${ADDDATA_SEP}./src/$MODULENAME"
    --add-data "$SOURCEDIR/version.yml${ADDDATA_SEP}./src/$MODULENAME"
    --add-data "$SOURCEDIR/constants/*.py${ADDDATA_SEP}./src/$MODULENAME/constants"
    --add-data "$SOURCEDIR/helpers/*.py${ADDDATA_SEP}./src/$MODULENAME/helpers"
    --add-data "$RESOURCEDIR/*${ADDDATA_SEP}./src/$MODULENAME/resources"
    --onefile
    --icon="$ICON"
    --copy-metadata imageio
)

# PyInstaller's splash-screen feature does not support macOS
if [ "$UNAME" != "Darwin" ]; then
    PYINSTALLER_ARGS+=(--splash="$SPLASH_IMG")
fi

pyinstaller "${PYINSTALLER_ARGS[@]}" "$PY"

echo "Cleaning up after making release..."
if [ "$UNAME" = "Darwin" ] && [ -d "$DISTDIR/$MAINFILENAME.app" ]; then
    mv "$DISTDIR/$MAINFILENAME.app" "$ORIGDIR/$MAINFILENAME.app"
else
    mv "$DISTDIR/$MAINFILENAME" "$TARGETBIN"
fi
rm -rf "$DISTDIR" "$BUILDDIR" "$SPEC"

echo "Build done!"
