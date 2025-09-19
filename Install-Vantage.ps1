# ======================================
# Install-LenovoVantage + Disable Lock
# ======================================

$SupportPath = "C:\Support"
if (-not (Test-Path $SupportPath)) {
    New-Item -ItemType Directory -Path $SupportPath -Force | Out-Null
}

# --------------------------
# Download and extract Vantage
# --------------------------
$VantageZipUrl  = "https://download.lenovo.com/pccbbs/thinkvantage_en/metroapps/Vantage/LenovoCommercialVantage_20.2506.39.0_v17.zip"
$VantageZipPath = Join-Path $SupportPath "LenovoCommercialVantage.zip"

Invoke-WebRequest -Uri $VantageZipUrl -OutFile $VantageZipPath -UseBasicParsing

$ExtractPath = Join-Path $SupportPath "CommercialVantage"
if (Test-Path $ExtractPath) { Remove-Item -Recurse -Force $ExtractPath }
Expand-Archive -Path $VantageZipPath -DestinationPath $ExtractPath -Force

$Installer = Join-Path $ExtractPath "VantageInstaller.exe"

if (Test-Path $Installer) {
    Start-Process $Installer -ArgumentList "Install -Vantage" -Wait
} else {
    Write-Error "Lenovo Vantage installer not found after extraction."
    exit 1
}

# --------------------------
# Disable lock & screensaver
# --------------------------
Write-Output "Applying registry tweaks to disable Lock Workstation and screensaver..."

# Disable Lock Workstation (Win+L, Ctrl+Alt+Del → Lock)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableLockWorkstation /t REG_DWORD /d 1 /f

# Disable screensaver
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 0 /f

Write-Output "Registry tweaks applied successfully."
