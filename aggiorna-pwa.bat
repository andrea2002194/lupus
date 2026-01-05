@echo off
cd /d "C:\Users\vavas\OneDrive\Desktop\pwa"

REM Esegui PowerShell per aggiornare la cache
powershell -ExecutionPolicy Bypass -File aggiorna-cache.ps1

REM Leggi la nuova versione della cache
for /f "tokens=2 delims=v'" %%a in ('findstr "CACHE_NAME" sw.js') do set VERSION_NEW=%%a

REM Git add, commit e push
git add .
git commit -m "Aggiornamento PWA v%VERSION_NEW% %date% %time%"
git pull origin main --rebase
git push origin main

pause
