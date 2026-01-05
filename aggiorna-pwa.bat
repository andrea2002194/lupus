@echo off
REM ===============================
REM Script automatico per aggiornare la PWA su GitHub
REM ===============================

REM Cartella della PWA
set PWA_DIR=C:\Users\vavas\OneDrive\Desktop\pwa
cd /d "%PWA_DIR%"

REM -------------------------------
REM Incrementa la versione della cache in sw.js
REM Cerca 'CACHE_NAME = lupus-cache-vX' e incrementa X
REM -------------------------------
setlocal enabledelayedexpansion
set FILE=sw.js
for /f "tokens=1,2 delims=v" %%a in ('findstr /c:"CACHE_NAME" %FILE%') do (
    set VERSION=%%b
)
set /a VERSION_NEW=VERSION+1
echo Nuova versione della cache: v!VERSION_NEW!

REM Sostituisce la versione vecchia con quella nuova
powershell -Command "(Get-Content '%FILE%') -replace 'lupus-cache-v[0-9]+','lupus-cache-v!VERSION_NEW!' | Set-Content '%FILE%'"

REM -------------------------------
REM Git add, commit e push
REM -------------------------------
git add .
git commit -m "Aggiornamento PWA v!VERSION_NEW! %date% %time%"
git pull origin main --rebase
git push origin main

echo ===============================
echo Aggiornamento completato!
pause
