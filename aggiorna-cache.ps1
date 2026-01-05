# aggiorna-cache.ps1
$swFile = "sw.js"

# Leggi tutto il contenuto in un array di righe
$content = Get-Content $swFile

# Trova la riga con CACHE_NAME
$lineIndex = -1
for ($i = 0; $i -lt $content.Count; $i++) {
    if ($content[$i] -match "CACHE_NAME\s*=\s*'lupus-cache-v(\d+)'") {
        $lineIndex = $i
        break
    }
}

if ($lineIndex -ge 0) {
    # Estrai il numero attuale della cache
    $oldLine = $content[$lineIndex]
    $oldVersion = [regex]::Match($oldLine, "CACHE_NAME\s*=\s*'lupus-cache-v(\d+)'").Groups[1].Value
    $newVersion = [int]$oldVersion + 1

    # Sostituisci solo la riga della cache con la nuova versione
    $content[$lineIndex] = "const CACHE_NAME = 'lupus-cache-v$newVersion';"

    # Riscrivi il file sw.js senza toccare il resto
    Set-Content $swFile $content

    Write-Output "Nuova versione della cache: v$newVersion"
} else {
    Write-Output "Errore: CACHE_NAME non trovato!"
}
