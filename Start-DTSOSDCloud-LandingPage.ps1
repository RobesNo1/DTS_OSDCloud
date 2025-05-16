# Override Global Variables

#Variables to define the Windows OS / Edition to be applied during OSDCloud
#$OSName = 'Windows 11 23H2 x64' < commented out 23/08/2024 as we may need W10 in niche cases
$OSEdition = 'Enterprise'
$OSActivation = 'Retail'
$OSLanguage = 'en-gb'

#Set OSDCloud Vars
$Global:MyOSDCloud = [ordered]@{
    Restart = [bool]$False
    RecoveryPartition = [bool]$true
    OEMActivation = [bool]$True
    WindowsUpdate = [bool]$true
    WindowsUpdateDrivers = [bool]$true
    WindowsDefenderUpdate = [bool]$true
    SetTimeZone = [bool]$true
    ClearDiskConfirm = [bool]$False
    ShutdownSetupComplete = [bool]$false
    SyncMSUpCatDriverUSB = [bool]$true
    CheckSHA1 = [bool]$true
}

$banner = @"
//////////////////////////////////////////////////
//  ___  ____  ____   ____ _                 _  //
// / _ \/ ___||  _ \ / ___| | ___  _   _  __| | //
//| | | \___ \| | | | |   | |/ _ \| | | |/ _  | //
//| |_| |___) | |_| | |___| | (_) | |_| | (_| | //
// \___/|____/|____/ \____|_|\___/ \__,_|\__,_| //
//                                              //
//////////////////////////////////////////////////
"@
$loadingColor = "Yellow"
Write-Host $banner -ForegroundColor $loadingColor

$loadingMessage1 = "Created by Dave Segura (@SeguraOSD)"
$loadingMessage2 = "You may now remove your USB key"
$loadingMessage3 = "NOTE: OSDCloud has not been tested with Getac or Panasonic Tablets"
$loadingColor = "White"
$delay = 30  # Delay between each character in milliseconds

# Function to simulate typing effect
function Type-Write ($message, $color, $delay) {
    foreach ($char in $message.ToCharArray()) {
        Write-Host -NoNewline $char -ForegroundColor $color
        Start-Sleep -Milliseconds $delay
    }
    Write-Host  # Move to the next line after the message is fully typed
}

# Type out the messages with a delay
Write-Host ""
Type-Write $loadingMessage1 $loadingColor $delay
Start-Sleep -Seconds 1  # Optional pause between the lines
Type-Write $loadingMessage2 $loadingColor $delay
Start-Sleep -Seconds 1  # Optional pause between the lines
$delay = 0 # Speeds up the final message about Field devices
Type-Write $loadingMessage3 $loadingColor $delay
write-host ""
Write-Host "Version:: 1.1 (Auto Enterprise)" -ForegroundColor Yellow

Write-Host ""
#Write-Host "===================== Main Menu =======================" -ForegroundColor Yellow
#Write-Host "=======================================================" -ForegroundColor Yellow
#Write-Host "1: Windows 11 | Enterprise   | En-gb" -ForegroundColor White
#Write-Host "2: Windows 11 | Professional | Device Recycling Only" -ForegroundColor White
#Write-Host "3: Exit`n" -ForegroundColor Red

#$EngineerInput = Read-Host "Please make a selection"

Write-Host  "Loading OSDCloud..." -ForegroundColor Green
Write-Host ".................................................." -ForegroundColor Green

# Auto-launch Enterprise build
Start-OSDCloud -OSName "Windows 11 24H2 x64" -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage

wpeutil reboot
