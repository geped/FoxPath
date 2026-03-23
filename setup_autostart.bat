@echo off
chcp 65001 >nul
echo ================================================
echo    Configurazione Avvio Automatico - FoxPath
echo ================================================
echo.
echo Creazione del collegamento nella cartella di Esecuzione Automatica...

set SCRIPT_DIR=%~dp0
set TARGET=%SCRIPT_DIR%FoxPath.exe
if not exist "%TARGET%" set TARGET=%SCRIPT_DIR%FoxPath.ahk

set SHORTCUT=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\FoxPath.lnk
set PWS=powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile

%PWS% -Command "$wshell = New-Object -ComObject WScript.Shell; $shortcut = $wshell.CreateShortcut('%SHORTCUT%'); $shortcut.TargetPath = '%TARGET%'; $shortcut.WorkingDirectory = '%SCRIPT_DIR%'; $shortcut.Description = 'Avvia FoxPath'; $shortcut.Save()"

echo.
echo [OK] Collegamento creato con successo!
echo FoxPath si avviera' automaticamente all'accensione di Windows.
echo.
pause