$ErrorActionPreference = "SilentlyContinue"
$sScriptVersion = "1.2.2"
$Host.UI.RawUI.WindowTitle = "LoLTweaker + $sScriptVersion"
$sLogPath = "C:\Windows\Temp"
$sLogName = "test.log"
$sLogFile = $sLogPath + "\" + $sLogName
$dir = [System.AppDomain]::CurrentDomain.BaseDirectory

Function Log-Start{
  
    
  [CmdletBinding()]
  
  Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$LogName, [Parameter(Mandatory=$true)][string]$ScriptVersion)
  
  Process{
    $sFullPath = $LogPath + "\" + $LogName
    
    If((Test-Path -Path $sFullPath)){
      Remove-Item -Path $sFullPath -Force
    }
    
    New-Item -Path $LogPath -Name $LogName –ItemType File
    
    Add-Content -Path $sFullPath -Value "***************************************************************************************************"
    Add-Content -Path $sFullPath -Value "Started processing at [$([DateTime]::Now)]."
    Add-Content -Path $sFullPath -Value "***************************************************************************************************"
    Add-Content -Path $sFullPath -Value ""
    Add-Content -Path $sFullPath -Value "Running script version [$ScriptVersion]."
    Add-Content -Path $sFullPath -Value ""
    Add-Content -Path $sFullPath -Value "***************************************************************************************************"
    Add-Content -Path $sFullPath -Value ""
  
    Write-Debug "***************************************************************************************************"
    Write-Debug "Started processing at [$([DateTime]::Now)]."
    Write-Debug "***************************************************************************************************"
    Write-Debug ""
    Write-Debug "Running script version [$ScriptVersion]."
    Write-Debug ""
    Write-Debug "***************************************************************************************************"
    Write-Debug ""
  }
}
 
Function Log-Write{
  
  
  [CmdletBinding()]
  
  Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$LineValue)
  
  Process{
    Add-Content -Path $LogPath -Value $LineValue
  
    Write-Debug $LineValue
  }
}
 
Function Log-Error{
  
  
  [CmdletBinding()]
  
  Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$ErrorDesc, [Parameter(Mandatory=$true)][boolean]$ExitGracefully)
  
  Process{
    Add-Content -Path $LogPath -Value "Error: An error has occurred [$ErrorDesc]."
  
    Write-Debug "Error: An error has occurred [$ErrorDesc]."
    
    If ($ExitGracefully -eq $True){
      Log-Finish -LogPath $LogPath
      Break
    }
  }
}
 
Function Log-Finish{

  
  [CmdletBinding()]
  
  Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$false)][string]$NoExit)
  
  Process{
    Add-Content -Path $LogPath -Value ""
    Add-Content -Path $LogPath -Value "***************************************************************************************************"
    Add-Content -Path $LogPath -Value "Finished processing at [$([DateTime]::Now)]."
    Add-Content -Path $LogPath -Value "***************************************************************************************************"
  
    Write-Debug ""
    Write-Debug "***************************************************************************************************"
    Write-Debug "Finished processing at [$([DateTime]::Now)]."
    Write-Debug "***************************************************************************************************"
  
    If(!($NoExit) -or ($NoExit -eq $False)){
      Exit
    }    
  }
}
 
Function Log-Email{
  
  
  [CmdletBinding()]
  
  Param ([Parameter(Mandatory=$true)][string]$LogPath, [Parameter(Mandatory=$true)][string]$EmailFrom, [Parameter(Mandatory=$true)][string]$EmailTo, [Parameter(Mandatory=$true)][string]$EmailSubject)
  
  Process{
    Try{
      $sBody = (Get-Content $LogPath | out-string)
      
     
      $sSmtpServer = "smtp.yourserver"
      $oSmtp = new-object Net.Mail.SmtpClient($sSmtpServer)
      $oSmtp.Send($EmailFrom, $EmailTo, $EmailSubject, $sBody)
      Exit 0
    }
    
    Catch{
      Exit 1
    } 
  }
}




Function update {
  Param()
  
  Begin{
    Log-Write -LogPath $sLogFile -LineValue "<description of what is going on>..."
  }
  
  Process{
    Try{

Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
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

cd $dir

function defrag {
Write-Host "Configuring Windows, this might take a while..."
Get-ChildItem -recurse c: | Unblock-File
Get-ChildItem -recurse $dir | Unblock-File
Stop-Service wuauserv
Remove-Item "$env:windir\SoftwareDistribution" -recurse
Start-Service wuauserv
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
Log-Finish -LogPath $sLogFile
Write-Host Some effects will take affect after restart.
Read-host -prompt "LoLTweaks finished, You will need to rerun as soon as the client gets updated again."
exit
}


defrag
    }
    
    Catch{
$sError = $Error[0] | Out-String
 Log-Error -LogPath $sLogFile -ErrorDesc $sError -ExitGracefully $True
      Break
    }
  }
  
  End{
    If($?){
      Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
      Log-Write -LogPath $sLogFile -LineValue " "
    }
  }
}

update