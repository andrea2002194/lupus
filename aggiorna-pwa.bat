@echo off
REM ===============================
REM Script automatico aggiornamento PWA
REM ===============================

REM Cartella della PWA
set PWA_DIR=C:\Users\vavas\OneDrive\Desktop\pwa
cd /d "%PWA_DIR%"

REM -------------------------------
REM Incrementa la versione della cache in sw.js
REM -------------------------------
powershell -Command ^
$swFile = '%PWA_DIR%\sw.js'; ^
$content = Get-Content $swFile; ^
$content = $content -replace "CACHE_NAME\s*=\s''lupus-cache-v(\d+)''", { param($m) "CACHE_NAME = 'lupus-cache-v$([int]$m.Groups[1].Value+1)'" }; ^
Set-Content $swFile $content

REM -------------------------------
REM Legge la nuova versione della cache
REM -------------------------------
for /f "tokens=2 delims=v'" %%a in ('findstr "CACHE_NAME" sw.js') do set VERSION_NEW=%%a

echo Nuova versione della cache: v%VERSION_NEW%

REM -------------------------------
REM Git add, commit e push
REM -------------------------------
git add .
git commit -m "Aggiornamento PWA v%VERSION_NEW% %date% %time%"
git pull origin main --rebase
git push origin main

echo ===============================
echo Aggiornamento completato!
pause
