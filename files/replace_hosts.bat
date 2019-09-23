@echo off
TITLE Modifying your HOSTS file
COLOR F0
ECHO.

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:LOOP
SET Choice=
SET /P Choice="Do you want to modify HOSTS file ? (Y/N)"

IF NOT '%Choice%'=='' SET Choice=%Choice:~0,1%

ECHO.
IF /I '%Choice%'=='Y' GOTO ACCEPTED
IF /I '%Choice%'=='N' GOTO REJECTED
ECHO Please type Y (for Yes) or N (for No) to proceed!
ECHO.
GOTO Loop

:REJECTED
ECHO Your HOSTS file was left unchanged>>%systemroot%\Temp\hostFileUpdate.log
ECHO Finished.
GOTO END

:ACCEPTED
if exist "hosts_target" (
move "C:\Windows\System32\drivers\etc\hosts" "C:\Windows\System32\drivers\etc\hosts-Original"
move "hosts_target" "C:\Windows\System32\drivers\etc\hosts"
ECHO Renaming current hosts file to hosts-Original
ECHO Activating Hosts file to target hosts
ECHO NEW HOSTS FILE IS ACTIVE

) else (
    ECHO new Hosts file already in place
)

GOTO END

:END
Pause