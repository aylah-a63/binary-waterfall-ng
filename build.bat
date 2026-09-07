@echo off
setlocal

set MAINFILENAME=binary-waterfall
set MODULENAME=binary_waterfall

set ORIGDIR=%CD%
set SOURCEDIR=%ORIGDIR%\src\%MODULENAME%
set DISTDIR=%ORIGDIR%\dist
set BUILDDIR=%ORIGDIR%\build

set PY=%ORIGDIR%\%MAINFILENAME%.py
set SPEC=%ORIGDIR%\%MAINFILENAME%.spec
set EXE=%DISTDIR%\%MAINFILENAME%.exe
set TARGETEXE=%ORIGDIR%\%MAINFILENAME%.exe

set VERSION_YAML=%SOURCEDIR%\version.yml
set VERSION_INFO=%ORIGDIR%\file_version_info.txt

set RESOURCEDIR=%SOURCEDIR%\resources
set ICON_ICO=%RESOURCEDIR%\icon.ico

set VENV=%ORIGDIR%\.venv

REM Build in an isolated venv, same as build.sh: keeps the build reproducible
REM without requiring a pre-existing conda environment.
if not exist "%VENV%" (
    echo Creating build environment in %VENV%...
    python -m venv "%VENV%"
    call "%VENV%\Scripts\pip.exe" install --upgrade pip
    if errorlevel 1 goto ERROR
    call "%VENV%\Scripts\pip.exe" install pyinstaller pyinstaller-versionfile "%ORIGDIR%"
    if errorlevel 1 goto ERROR
)
set PATH=%VENV%\Scripts;%PATH%

echo Cleaning up before making release...
del /f /q "%TARGETEXE%" 1>nul 2>&1
if exist "%DISTDIR%" rmdir /s /q "%DISTDIR%"
if exist "%BUILDDIR%" rmdir /s /q "%BUILDDIR%"
del /f /q "%SPEC%" 1>nul 2>&1
del /f /q "%VERSION_INFO%" 1>nul 2>&1

echo Building portable EXE...
call create-version-file "%VERSION_YAML%" --outfile "%VERSION_INFO%"
if errorlevel 1 goto ERROR

call pyinstaller ^
    --clean ^
    --noconfirm ^
    --windowed ^
    --add-data "%SOURCEDIR%\*.py;.\src\%MODULENAME%" ^
    --add-data "%SOURCEDIR%\version.yml;.\src\%MODULENAME%" ^
    --add-data "%SOURCEDIR%\constants\*.py;.\src\%MODULENAME%\constants" ^
    --add-data "%SOURCEDIR%\helpers\*.py;.\src\%MODULENAME%\helpers" ^
    --add-data "%RESOURCEDIR%\*;.\src\%MODULENAME%\resources" ^
    --onefile ^
    --icon="%ICON_ICO%" ^
    --version-file="%VERSION_INFO%" ^
    --copy-metadata imageio ^
    "%PY%"
if errorlevel 1 goto ERROR

echo Cleaning up after making .exe release...
move /y "%EXE%" "%TARGETEXE%"
if exist "%DISTDIR%" rmdir /s /q "%DISTDIR%"
if exist "%BUILDDIR%" rmdir /s /q "%BUILDDIR%"
del /f /q "%SPEC%" 1>nul 2>&1
del /f /q "%VERSION_INFO%" 1>nul 2>&1

echo Build done!
exit /B 0

:ERROR
cd /d "%ORIGDIR%"
echo Build failed!
exit /B 1
