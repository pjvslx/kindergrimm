@echo off
setlocal

cd /d "%~dp0"

set "PORT=%~1"
if not defined PORT set "PORT=8137"
set "OPEN_ARG=--open"
if /i "%~2"=="--no-open" set "OPEN_ARG="

where py >nul 2>nul
if not errorlevel 1 py -3 -c "import sys; raise SystemExit(sys.version_info.major != 3)" >nul 2>nul
if not errorlevel 1 goto :run_py

where python >nul 2>nul
if not errorlevel 1 python -c "import sys; raise SystemExit(sys.version_info.major != 3)" >nul 2>nul
if not errorlevel 1 goto :run_python

echo [ERROR] Python 3 was not found.
echo Install Python 3 and enable "Add Python to PATH", then run this script again.
set "EXIT_CODE=1"
goto :done

:run_py
py -3 serve.py "%PORT%" "." --host 0.0.0.0 %OPEN_ARG%
set "EXIT_CODE=%ERRORLEVEL%"
goto :done

:run_python
python serve.py "%PORT%" "." --host 0.0.0.0 %OPEN_ARG%
set "EXIT_CODE=%ERRORLEVEL%"

:done
if not "%EXIT_CODE%"=="0" pause
exit /b %EXIT_CODE%
