# Forja installer and updater for Windows (PowerShell 5.1 or later).
#
#   irm https://github.com/Omara8/Forja/releases/latest/download/install.ps1 | iex
#
# Run it again to update: it replaces Forja and keeps your settings, archive and products.
# Every download is checked before anything is replaced: with cosign installed, its Sigstore signature (made by Forja's
# release workflow on GitHub); without cosign, its SHA-256 only, and the installer says the signature was not checked.
#   $env:FORJA_VERSION = "0.10.0"   a given release instead of the newest
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
# The signer: Forja's release workflow on main, signed through GitHub's own sign-in for workflows (Sigstore, keyless)
$Signer = '^https://github\.com/Omara8/Forja-Private/\.github/workflows/release\.yml@refs/heads/main$'
$Issuer = 'https://token.actions.githubusercontent.com'
$Cosign = Get-Command cosign -ErrorAction SilentlyContinue
if ($Cosign) {
    try { Invoke-WebRequest -UseBasicParsing -Uri "$Base/$Asset.sigstore.json" -OutFile (Join-Path $Dl "$Asset.sigstore.json") }
    catch { Remove-Item -Recurse -Force $Dl; Fail "could not download the signature $Base/$Asset.sigstore.json: nothing was changed" }
    $Prev = $ErrorActionPreference; $ErrorActionPreference = "Continue"     # cosign writes to stderr; PowerShell 5.1 would stop on it
    $Major = ((& $Cosign.Source version 2>&1) | Out-String) -replace '(?s).*GitVersion:\s*v?(\d+).*', '$1'
    $Old = if ($Major -eq "2") { @("--new-bundle-format") } else { @() }   # cosign 2 reads this signature format only when told to
    $null = & $Cosign.Source verify-blob @Old --bundle (Join-Path $Dl "$Asset.sigstore.json") --certificate-identity-regexp $Signer `
        --certificate-oidc-issuer $Issuer (Join-Path $Dl $Asset) 2>&1
    $Rc = $LASTEXITCODE
    $ErrorActionPreference = $Prev
    if ($Rc -ne 0) {
        Remove-Item -Recurse -Force $Dl
        Fail "the signature of $Asset does not check out (it was not signed by Forja's release workflow): nothing was changed"
    }
    Write-Host "Signature OK (signed by Forja's release workflow)"
} else {
    Write-Host "WARNING: the signature was not checked (cosign is not installed); only the checksum was. To check it next time, install cosign (docs.sigstore.dev) and run this installer again." -ForegroundColor Yellow
}

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
