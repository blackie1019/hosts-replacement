@echo off
TITLE HOSTS DOSYAN DEGISIYOR
COLOR F0
ECHO.

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Y├Ânetici hakları isteniyor...
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
SET /P Choice="Hosts dosyanı değiştirmek istiyor musun ? (E/H)"

IF NOT '%Choice%'=='' SET Choice=%Choice:~0,1%

ECHO.
IF /I '%Choice%'=='E' GOTO ACCEPTED
IF /I '%Choice%'=='H' GOTO REJECTED
ECHO Evet için E  tuşuna Hayır için H tuşuna basınız!
ECHO.
GOTO Loop

:REJECTED
ECHO HOSTS dosyanızda değişiklik yapılmamıştır.>>%systemroot%\Temp\hostFileUpdate.log
ECHO İşlem sonu.
GOTO END

:ACCEPTED
if exist "hosts_target" (
move "C:\Windows\System32\drivers\etc\hosts" "C:\Windows\System32\drivers\etc\hosts-Original"
copy "hosts_target" "C:\Windows\System32\drivers\etc\hosts"
ECHO Host dosyasının ismi değişiştiriliyor
ECHO Eski hosts dosyası kaldırıldı
ECHO Yeni hosts dosyan aktif.

) else (
    ECHO yeni Hosts dosyanı zaten değişişmiz.
)

GOTO END

:END
Pause
