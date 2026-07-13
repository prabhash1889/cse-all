# Converts every .md under this folder to a PDF next to it (same name, .pdf).
# Uses md-to-pdf (headless Chromium) - same engine as the VS Code "Markdown PDF" extension.
# Run:  powershell -ExecutionPolicy Bypass -File .\md2pdf.ps1

$root = $PSScriptRoot
$files = Get-ChildItem -Path $root -Recurse -Filter *.md
Write-Host "Found $($files.Count) markdown files."

$i = 0
foreach ($f in $files) {
    $i++
    Write-Host "[$i/$($files.Count)] $($f.FullName)"
    npx --yes md-to-pdf "$($f.FullName)"
}
Write-Host "Done. PDFs are next to each .md file."
