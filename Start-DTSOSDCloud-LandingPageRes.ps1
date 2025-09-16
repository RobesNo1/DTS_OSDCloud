# Set Windows OS variables
$OSName       = 'Windows 11 24H2 x64'
$OSEdition    = 'Pro'
$OSActivation = 'Retail'
$OSLanguage   = 'en-gb'

# Set OSDCloud global configuration
$Global:MyOSDCloud = [ordered]@{
    Restart               = $false
    RecoveryPartition     = $true
    OEMActivation         = $true
    WindowsUpdate         = $true
    WindowsUpdateDrivers  = $true
    WindowsDefenderUpdate = $true
    SetTimeZone           = $true
    ClearDiskConfirm      = $false
    ShutdownSetupComplete = $false
    SyncMSUpCatDriverUSB  = $true
    CheckSHA1             = $true
}

Write-Host ""
Write-Host "Starting OSDCloud for Windows 11 Professional - Resilience Build" -ForegroundColor Yellow
Write-Host ""

# 1) Run the deployment from WinPE
Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage

# 2) Stage unattend.xml for OOBEDeploy (ProgramData path on the TARGET OS)
try {
    # Find unattend.xml on any attached drive under \OSDCloud\Config\OOBEDeploy
    $SourceUnattend = Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        $p = Join-Path $_.Root 'OSDCloud\Config\OOBEDeploy\unattend.xml'
        if (Test-Path $p) { $p }
    } | Select-Object -First 1

    if (-not $SourceUnattend) {
        Write-Warning "unattend.xml not found under <Drive>:\OSDCloud\Config\OOBEDeploy\ on any attached drive."
    }
    else {
        $DestDir = 'C:\ProgramData\OSDCloud\Config\OOBEDeploy'
        New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
        Copy-Item -Path $SourceUnattend -Destination (Join-Path $DestDir 'unattend.xml') -Force
        Write-Host "Staged unattend.xml to $DestDir"
    }
}
catch {
    Write-Warning "Failed to stage unattend.xml: $($_.Exception.Message)"
}

# 3) Reboot to continue deployment
wpeutil reboot
