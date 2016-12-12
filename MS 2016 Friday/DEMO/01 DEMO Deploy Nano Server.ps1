# https://technet.microsoft.com/en-us/windows-server-docs/get-started/deploy-nano-server

Import-Module E:\NanoServer\NanoServerImageGenerator

$NanoName      = "W16-NA3"
$Ipv4Address   = "192.168.1.110"
$adminPassword = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force

New-Item -ItemType Directory -Path C:\VMS\$NanoName -Force | Out-Null

$Params = @{
   ComputerName          = $NanoName
   AdministratorPassword = $adminPassword
   Containers            = $true
   Compute               = $true
   Edition               = "Standard"
   DeploymentType        = "Guest"
   MediaPath             = "E:\"
   BasePath              = "C:\Nano\Base"
   TargetPath            = "C:\VMS\$NanoName\Nano.vhdx"
   Package               = @('Microsoft-NanoServer-DSC-Package')
   InterfaceNameOrIndex  = "Ethernet"
   Ipv4Address           = $Ipv4Address
   Ipv4Gateway           = "192.168.1.1"
   Ipv4Dns               = "192.168.1.21"
   Ipv4SubnetMask        = "255.255.255.0"
}
New-NanoServerImage @Params

$Params = @{
   Name               = $NanoName
   MemoryStartupBytes = 1GB
   Generation         = 2
   VHDPath            = "C:\VMS\$NanoName\Nano.vhdx"
   SwitchName         = "Internal"
}
$NanoVM = New-VM @Params
$NanoVM | Start-VM
Start-Sleep -Seconds 5
# Enter-PSSession -VMName $NanoName -Credential $Ipv4Address\administrator

#Join Domain:
$NanoCreds     = New-Object System.Management.Automation.PSCredential ("administrator", $adminPassword)
$DomainCreds   = New-Object System.Management.Automation.PSCredential ("demo\administrator", $adminPassword)

#Use if network:
#Set-Item WSMan:\localhost\Client\TrustedHosts $Ipv4Address
#Set-Item WSMan:\localhost\Client\TrustedHosts "192.168.1.21"

#Use if Hyper-V Host
$DcSession   = New-PSSession -VMName "W16-DC1"  -Credential $DomainCreds
$NanoSession = New-PSSession -VMName $NanoName  -Credential $NanoCreds

Invoke-Command -ScriptBlock{
    djoin.exe /provision /domain DEMO /machine $using:NanoName /savefile C:\odjblob
} -Session $DcSession

Copy-Item -Path C:\odjblob          -Destination C:\LabFiles -FromSession $DcSession   -Verbose
Copy-Item -Path C:\LabFiles\odjblob -Destination C:\         -ToSession   $NanoSession -Verbose

Invoke-Command -ScriptBlock{
    djoin /requestodj /loadfile c:\odjblob /windowspath c:\windows /localos
    shutdown /r /t 5
} -Session  $NanoSession

Get-PSSession | Remove-PSSession