# Add Trusted Host from non domain node:
Set-Item WSMan:\localhost\Client\TrustedHosts "192.168.0.66" #Nano Server
Set-Item WSMan:\localhost\Client\TrustedHosts "192.168.0.21" #Domain Controller

# Create Sessions to nodes:
$DcSession   = New-PSSession -ComputerName 192.168.0.21 -Credential DEMO\administrator
$NanoSession = New-PSSession -ComputerName 192.168.0.66 -Credential 192.168.0.66\administrator

# Create Domain Join obj:
Invoke-Command -ScriptBlock{
    djoin.exe /provision /domain DEMO /machine W16-NA2 /savefile C:\odjblob
} -Session $DcSession

# Get the obj from DC to Nano:
Copy-Item -Path C:\odjblob          -Destination C:\LabFiles -FromSession $DcSession   -Verbose
Copy-Item -Path C:\LabFiles\odjblob -Destination C:\         -ToSession   $NanoSession -Verbose

# Run Join on Nano:
Invoke-Command -ScriptBlock{
    djoin /requestodj /loadfile c:\odjblob /windowspath c:\windows /localos
    shutdown /r /t 5
} -Session  $NanoSession
Get-PSSession | Remove-PSSession