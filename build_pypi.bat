@echo off
setlocal

set ORIGDIR=%CD%
set DISTDIR=%ORIGDIR%\dist

set VENV=%ORIGDIR%\.venv

REM Same venv as build.bat, but that one does not install the packaging tools.
if not exist "%VENV%" (
    echo Creating build environment in %VENV%...
    python -m venv "%VENV%"
    if errorlevel 1 goto ERROR
    call "%VENV%\Scripts\pip.exe" install --upgrade pip
    if errorlevel 1 goto ERROR
)
call "%VENV%\Scripts\pip.exe" install --upgrade build twine
if errorlevel 1 goto ERROR
set PATH=%VENV%\Scripts;%PATH%

if "%~1" == "upload" goto UPLOAD

echo Cleaning up before making release...
if exist "%DISTDIR%" rmdir /s /q "%DISTDIR%"

echo Making PyPI release...
call python -m build
if errorlevel 1 goto ERROR

echo Build done!
exit /B 0


:UPLOAD
echo Uploading to PyPI
call twine upload "%DISTDIR%"\*
if errorlevel 1 goto ERROR
echo Upload done!
exit /B 0

:ERROR
cd /d "%ORIGDIR%"
echo Build failed!
exit /B 1
