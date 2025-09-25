$SupportPath = "C:\Support"
if (-not (Test-Path $SupportPath)) {
    New-Item -ItemType Directory -Path $SupportPath -Force | Out-Null
}

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
    exit 1
}
