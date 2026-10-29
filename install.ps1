# Forja installer and updater for Windows (PowerShell 5.1 or later).
#
#   irm https://raw.githubusercontent.com/Omara8/Forja/main/install.ps1 | iex
#
# Run it again to update: it replaces Forja and keeps your settings, archive and products.
#   $env:FORJA_VERSION = "0.7.0"   a given release instead of the newest
#   $env:FORJA_ROOT = "D:\forja"   another install folder
#
# Where Forja goes (never a hidden folder, no administrator rights): %USERPROFILE%\forja
# Settings: %USERPROFILE%\forja\config. Downloads go to %USERPROFILE%\forja\_download (not the hidden AppData\Local\Temp).

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Repo = "Omara8/Forja"
function Fail($msg) { Write-Host "Forja installer: $msg" -ForegroundColor Red; throw $msg }

if ($env:PROCESSOR_ARCHITECTURE -ne "AMD64" -and $env:PROCESSOR_ARCHITEW6432 -ne "AMD64") {
    Fail "no Forja build for $env:PROCESSOR_ARCHITECTURE yet (Windows x64 only)"
}
$Plat = "windows-x64"
$Root = if ($env:FORJA_ROOT) { $env:FORJA_ROOT } else { Join-Path $env:USERPROFILE "forja" }
foreach ($part in ($Root -split '[\\/]')) { if ($part.StartsWith(".")) { Fail "$Root is inside a hidden folder: choose another FORJA_ROOT" } }
New-Item -ItemType Directory -Force -Path $Root | Out-Null

# 1 the release
$Asset = "forja-$Plat.zip"
$Ver = if ($env:FORJA_VERSION) { $env:FORJA_VERSION.TrimStart("v") } else { "latest" }
$Base = if ($env:FORJA_DOWNLOAD_BASE) { $env:FORJA_DOWNLOAD_BASE } elseif ($Ver -eq "latest") { "https://github.com/$Repo/releases/latest/download" } else { "https://github.com/$Repo/releases/download/v$Ver" }
$Dl = Join-Path $Root "_download"
Remove-Item -Recurse -Force $Dl -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $Dl | Out-Null
Write-Host "Downloading Forja ($Plat) ..."
try {
    Invoke-WebRequest -UseBasicParsing -Uri "$Base/$Asset" -OutFile (Join-Path $Dl $Asset)
    Invoke-WebRequest -UseBasicParsing -Uri "$Base/$Asset.sha256" -OutFile (Join-Path $Dl "$Asset.sha256")
} catch { Fail "could not download $Base/$Asset ($($_.Exception.Message))" }

# 2 the checksum: nothing is replaced unless it matches
$Want = ((Get-Content (Join-Path $Dl "$Asset.sha256") -Raw).Trim() -split "\s+")[0].ToLower()
$Got = (Get-FileHash -Algorithm SHA256 (Join-Path $Dl $Asset)).Hash.ToLower()
if (-not $Want -or $Want -ne $Got) { Remove-Item -Recurse -Force $Dl; Fail "checksum mismatch for $Asset (expected $Want, got $Got): nothing was changed" }
Write-Host "Checksum OK ($Got)"

# 3 unpack next to the current install, then swap (settings in config\ are never touched)
$New = Join-Path $Root "_new"
Remove-Item -Recurse -Force $New -ErrorAction SilentlyContinue
Expand-Archive -Path (Join-Path $Dl $Asset) -DestinationPath $New -Force
if (-not (Test-Path (Join-Path $New "bin\forja.cmd")) -or -not (Test-Path (Join-Path $New "app\BUILD.json"))) {
    Fail "the download is not a Forja bundle: nothing was changed"
}
foreach ($d in "app", "python", "bin") {
    $cur = Join-Path $Root $d
    $old = Join-Path $Root "_old_$d"
    Remove-Item -Recurse -Force $old -ErrorAction SilentlyContinue
    if (Test-Path $cur) {
        try { Move-Item $cur $old } catch { Fail "Forja is running ($cur is in use): close every Forja window and run the installer again" }
    }
    Move-Item (Join-Path $New $d) $cur
    Remove-Item -Recurse -Force $old -ErrorAction SilentlyContinue
}
Remove-Item -Recurse -Force $New, $Dl -ErrorAction SilentlyContinue
$Version = (Get-Content (Join-Path $Root "app\BUILD.json") -Raw | ConvertFrom-Json).version

# 4 the forja command: %USERPROFILE%\forja\bin on the user PATH
$Bin = Join-Path $Root "bin"
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not (($UserPath -split ";") -contains $Bin)) {
    [Environment]::SetEnvironmentVariable("Path", $(if ($UserPath) { "$UserPath;$Bin" } else { $Bin }), "User")
}
if (-not (($env:Path -split ";") -contains $Bin)) { $env:Path = "$env:Path;$Bin" }

# 5 set up this computer the first time (an update keeps the setup; Forja updates its hooks on its next start)
Write-Host "Forja $Version is installed in $Root"
if (Test-Path (Join-Path $env:USERPROFILE "forja\config\forja.json")) {
    Write-Host "Updated. Your settings, archive and products are as they were. Type: forja"
} else {
    & (Join-Path $Bin "forja.cmd") setup
    if ($LASTEXITCODE -ne 0) { Write-Host "Setup did not finish: run  forja setup  when you are ready." }
}
