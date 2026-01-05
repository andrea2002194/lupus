# aggiorna-cache.ps1
$swFile = "sw.js"

# Leggi tutto il contenuto
$content = Get-Content $swFile

# Incrementa la cache
$content = $content -replace "CACHE_NAME\s*=\s'lupus-cache-v(\d+)'", { param($m) "CACHE_NAME = 'lupus-cache-v$([int]$m.Groups[1].Value+1)'" }

# Scrivi il nuovo contenuto con WriteAllLines (più robusto)
[System.IO.File]::WriteAllLines($swFile, $content)

# Estrai il nuovo numero della cache
$line = Select-String "CACHE_NAME" $swFile
if ($line -ne $null) {
    $version = [regex]::Match($line.Line, "CACHE_NAME\s*=\s'lupus-cache-v(\d+)'").Groups[1].Value
    Write-Output "Nuova versione della cache: v$version"
} else {
    Write-Output "Errore: CACHE_NAME non trovato!"
}
