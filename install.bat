@echo off
setlocal
REM curl -fsSL https://raw.githubusercontent.com/aylah-a63/binary-waterfall-ng/main/install.bat -o install.bat && install.bat

set "REPO=https://github.com/aylah-a63/binary-waterfall-ng.git"

where git >nul 2>&1
if errorlevel 1 (
    echo install.bat needs git, which is not on PATH>&2
    exit /B 1
)
where python >nul 2>&1
if errorlevel 1 (
    echo install.bat needs python, which is not on PATH>&2
    exit /B 1
)

set "SRCDIR=%TEMP%\binary-waterfall-ng-install-%RANDOM%%RANDOM%"

echo Fetching source...
git clone --depth 1 "%REPO%" "%SRCDIR%"
if errorlevel 1 goto ERROR

pushd "%SRCDIR%"
call build.bat
if errorlevel 1 goto ERROR_POPD

set "INSTALLDIR=%LOCALAPPDATA%\Programs\binary-waterfall"
if not exist "%INSTALLDIR%" mkdir "%INSTALLDIR%"
move /y "binary-waterfall.exe" "%INSTALLDIR%\binary-waterfall.exe" >nul
popd

echo Creating Start Menu shortcut...
set "SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Binary Waterfall.lnk"
powershell -NoProfile -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%SHORTCUT%'); $s.TargetPath='%INSTALLDIR%\binary-waterfall.exe'; $s.Save()"

echo Installed %INSTALLDIR%\binary-waterfall.exe
echo Added Start Menu shortcut "Binary Waterfall"
echo.
echo Note: %INSTALLDIR% is not on PATH. Launch from the Start Menu, or add it to PATH to run "binary-waterfall" from a terminal.

goto CLEANUP

:ERROR_POPD
popd
:ERROR
echo Install failed!>&2
if exist "%SRCDIR%" rmdir /s /q "%SRCDIR%"
exit /B 1

:CLEANUP
if exist "%SRCDIR%" rmdir /s /q "%SRCDIR%"
exit /B 0
