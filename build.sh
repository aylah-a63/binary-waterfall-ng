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

VENV="$ORIGDIR/.venv"

UNAME="$(uname -s)"
case "$UNAME" in
    Darwin*) ADDDATA_SEP=":" ; ICON="$RESOURCEDIR/icon.png" ;;
    *)       ADDDATA_SEP=":" ; ICON="$RESOURCEDIR/icon.png" ;;
esac

# Build in an isolated venv: distro-packaged numpy links against libFlexiBLAS,
# whose backends PyInstaller does not collect, and Python 3.13 dropped audioop.
if [ ! -d "$VENV" ]; then
    echo "Creating build environment in $VENV..."
    python3 -m venv "$VENV"
    "$VENV/bin/pip" install --upgrade pip
    "$VENV/bin/pip" install pyinstaller "$ORIGDIR"
fi
export PATH="$VENV/bin:$PATH"

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

pyinstaller "${PYINSTALLER_ARGS[@]}" "$PY"

echo "Cleaning up after making release..."
if [ "$UNAME" = "Darwin" ] && [ -d "$DISTDIR/$MAINFILENAME.app" ]; then
    mv "$DISTDIR/$MAINFILENAME.app" "$ORIGDIR/$MAINFILENAME.app"
else
    mv "$DISTDIR/$MAINFILENAME" "$TARGETBIN"
fi
rm -rf "$DISTDIR" "$BUILDDIR" "$SPEC"

echo "Build done!"
