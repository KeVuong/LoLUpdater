import-module bitstransfer
pop-location
push-location "RADS\solutions\lol_game_client_sln\releases"
$sln = gci | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
pop-location
push-location "RADS\projects\lol_launcher\releases"
$launch = gci | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
pop-location
push-location "RADS\projects\lol_air_client\releases"
$air = gci | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1
Pop-Location

Set-Location $PSCommandPath
Function restore {
Write-Host "Restoring..."
Copy-Item .\backup\dbghelp.dll .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\backup\cg.dll .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\backup\cgD3D9.dll .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\backup\cggl.dll .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\backup\tbb.dll .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\backup\BsSndRpt.exe .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\backup\BugSplat.dll .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item "backup\Adobe Air.dll" "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0"
Copy-Item .\backup\NPSWF32.dll "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources"
Copy-Item .\backup\cg.dll .\RADS\projects\lol_launcher\releases\$launch\deploy
Copy-Item .\backup\cgD3D9.dll .\RADS\projects\lol_launcher\releases\$launch\deploy
Copy-Item .\backup\cggl.dll .\RADS\projects\lol_launcher\releases\$launch\deploy
Regedit.exe /S dxp.reg
Regedit.exe /S dvista.reg
Regedit.exe /S d7.reg
Set-Service AppMgmt -startupType Manual
Set-Service bthserv -startupType Manual
Set-Service CertPropSvc -startupType Manual
Set-Service CscService -startupType Manual
Set-Service iphlpsvc -startupType Manual
Set-Service napagent -startupType Manual
Set-Service Netlogon -startupType Manual
Set-Service NfsClnt -startupType Manual
Set-Service PeerDistSvc -startupType Manual
Set-Service RpcLocator -startupType Manual
Set-Service SCPolicySvc -startupType Manual
Set-Service SensrSvc -startupType Manual
Set-Service StorSvc -startupType Manual
Set-Service TrkWks -startupType Manual
Set-Service wcncsvc -startupType Manual
Set-Service vmicheartbeat -startupType Manual
Set-Service vmickvpexchange -startupType Manual
Set-Service vmicrdv -startupType Manual
Set-Service vmicshutdown -startupType Manual
Set-Service vmictimesync -startupType Manual
Set-Service vmicvss -startupType Manual
Set-Service WPCSvc -startupType Manual
Set-Service fsvc -startupType Manual
Set-Service IEEtwCollectorService -startupType Manual
Set-Service MSiSCSI -startupType Manual
Set-Service ScDeviceEnum -startupType Manual
Set-Service SNMPTRAP -startupType Manual
Set-Service WbioSrvc -startupType Manual
Set-Service vmicguestinterface -startupType Manual
Set-Service WMPNetworkSvc -startupType Manual
Read-host -prompt "LoLTweaks finished!"
exit
}

function defrag {
Write-Host "Configuring Windows, this might take a while..."
start-process ccleaner.exe /auto
Get-ChildItem -recurse c:\ | Unblock-File
Get-ChildItem -recurse $dir | Unblock-File
Stop-Service wuauserv
Remove-Item "$env:windir\SoftwareDistribution" -recurse
Start-Service wuauserv
$ie = New-Object -ComObject InternetExplorer.Application
$ie.Visible = $true
$ie.Navigate("http://update.microsoft.com/microsoftupdate/v6/vistadefault.aspx?ln=en-us")
start-process "df.exe" c:\
patch
	}

Function patch	{
cls
Write-Host "Closing League of Legends..."
stop-process -processname LoLLauncher
stop-process -processname LoLClient
cls
Write-Host "Downloading files..."
Start-BitsTransfer http://developer.download.nvidia.com/cg/Cg_3.1/Cg-3.1_April2012_Setup.exe
cls
Write-Host "Copying files..."
start-process .\Cg-3.1_April2012_Setup.exe /silent -Windowstyle Hidden -wait
Copy-Item .\BsSndRpt.exe .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\BugSplat.dll .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\dbghelp.dll .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\tbb.dll .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item .\NPSWF32.dll "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Resources"
Copy-Item "Adobe AIR.dll" "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0"
if($env:PROCESSOR_ARCHITECTURE -eq "AMD64")
    {
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cg.dll" .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cgD3D9.dll" .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cggl.dll" .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cg.dll" .\RADS\projects\lol_launcher\releases\$launch\deploy
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cgD3D9.dll" .\RADS\projects\lol_launcher\releases\$launch\deploy
Copy-Item "${env:programfiles(x86)}\NVIDIA Corporation\Cg\bin\cggl.dll" .\RADS\projects\lol_launcher\releases\$launch\deploy
    }
    else
    {
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cg.dll" .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cgD3D9.dll" .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cggl.dll" .\RADS\solutions\lol_game_client_sln\releases\$sln\deploy
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cg.dll" .\RADS\projects\lol_launcher\releases\$launch\deploy
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cgD3D9.dll" .\RADS\projects\lol_launcher\releases\$launch\deploy
Copy-Item "$env:programfiles\NVIDIA Corporation\Cg\bin\cggl.dll" .\RADS\projects\lol_launcher\releases\$launch\deploy
    }

cls
Write-Host "Cleaning up..."

$key = (Get-ItemProperty "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Pando Networks\PMB")."program directory"

if (Test-Path -path $key\uninst.exe)
{ start-process $key\uninst.exe
}
Set-Service AppMgmt -startupType Disabled
Regedit.exe /S xp.reg
Regedit.exe /S vista.reg
Regedit.exe /S 7.reg
Set-Service AppMgmt -startupType Disabled
Set-Service bthserv -startupType Disabled
Set-Service CertPropSvc -startupType Disabled
Set-Service CscService -startupType Disabled
Set-Service iphlpsvc -startupType Disabled
Set-Service napagent -startupType Disabled
Set-Service Netlogon -startupType Disabled
Set-Service NfsClnt -startupType Disabled
Set-Service PeerDistSvc -startupType Disabled
Set-Service RpcLocator -startupType Disabled
Set-Service SCPolicySvc -startupType Disabled
Set-Service SensrSvc -startupType Disabled
Set-Service StorSvc -startupType Disabled
Set-Service TrkWks -startupType Disabled
Set-Service wcncsvc -startupType Disabled
Set-Service vmicheartbeat -startupType Disabled
Set-Service vmickvpexchange -startupType Disabled
Set-Service vmicrdv -startupType Disabled
Set-Service vmicshutdown -startupType Disabled
Set-Service vmictimesync -startupType Disabled
Set-Service vmicvss -startupType Disabled
Set-Service WPCSvc -startupType Disabled
Stop-Service AppMgmt
Stop-Service bthserv
Stop-Service CertPropSvc
Stop-Service CscService
Stop-Service iphlpsvc
Stop-Service napagent
Stop-Service Netlogon
Stop-Service NfsClnt
Stop-Service PeerDistSvc
Stop-Service RpcLocator
Stop-Service SCPolicySvc
Stop-Service SensrSvc
Stop-Service StorSvc
Stop-Service TrkWks
Stop-Service wcncsvc
Stop-Service vmicheartbeat
Stop-Service vmickvpexchange
Stop-Service vmicrdv
Stop-Service vmicshutdown
Stop-Service vmictimesync
Stop-Service vmicvss
Stop-Service WPCSvc
Set-Service fsvc -startupType Disabled
Set-Service IEEtwCollectorService -startupType Disabled
Set-Service MSiSCSI -startupType Disabled
Set-Service ScDeviceEnum -startupType Disabled
Set-Service SNMPTRAP -startupType Disabled
Set-Service WbioSrvc -startupType Disabled
Set-Service vmicguestinterface -startupType Disabled
Set-Service WMPNetworkSvc -startupType Disabled
Stop-Service fsvc
Stop-Service IEEtwCollectorService
Stop-Service MSiSCSI
Stop-Service ScDeviceEnum
Stop-Service SNMPTRAP
Stop-Service WbioSrvc
Stop-Service vmicguestinterface
Stop-Service WMPNetworkSvc
Write-Host "Starting LoL-Launcher..."
start-process .\lol.launcher.exe
cls
Read-host -prompt "LoLTweaks finished, You will need to rerun as soon as the client gets updated again."
exit
}

function update {
cls
$message = "Would you like to Patch or Restore Backups?"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Patch"


$no = New-Object System.Management.Automation.Host.ChoiceDescription "&Restore"


$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)


$result = $host.ui.PromptForChoice($title, $message, $options, 0)


switch ($result)
    {
        0 {
		patch
      }
        1 {restore}
    }
}




if(Test-Path -path Backup)
{defrag}
ELSE
{
New-Item -ItemType directory -Path "Backup"
Write-Host "Backing up..."
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\dbghelp.dll Backup
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\tbb.dll" Backup
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BsSndRpt.exe Backup
Copy-Item "RADS\solutions\lol_game_client_sln\releases\$sln\deploy\BugSplat.dll" Backup
Copy-Item "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\Adobe Air.dll" .\Backup
Copy-Item "RADS\projects\lol_air_client\releases\$air\deploy\Adobe AIR\Versions\1.0\resources\NPSWF32.dll" .\Backup
Copy-Item "RADS\projects\lol_launcher\releases\$launch\deploy\cg.dll" Backup
Copy-Item "RADS\projects\lol_launcher\releases\$launch\deploy\cgD3D9.dll" Backup
Copy-Item "RADS\projects\lol_launcher\releases\$launch\deploy\cggl.dll" Backup
defrag
}