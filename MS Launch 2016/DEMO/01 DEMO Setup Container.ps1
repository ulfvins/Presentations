Break
#
#    01 DEMO Setup Containers
#
#    Build by: Richard Ulfvin
#    Run on W16-ME2
#

# Run Windows Update fist!!!

# FUN: Change the error color...
$host.PrivateData.ErrorForegroundColor = "green"

# Install Docker on Windows 2016
Install-WindowsFeature containers -Verbose
Restart-Computer -Force

# Install Docker on Server (Snippet):
New-Item -Path C:\Setup -ItemType Directory -Force -Verbose
$Params = @{
    Uri             = "https://download.docker.com/components/engine/windows-server/cs-1.12/docker.zip"
    OutFile         = "C:\Setup\docker.zip"
    UseBasicParsing = $true
}
Invoke-WebRequest @Params -Verbose

Expand-Archive -Path "C:\Setup\docker.zip" -DestinationPath $env:ProgramFiles -Verbose

# For quick use, does not require shell to be restarted.
$env:path += ";c:\program files\docker"

# For persistent use, will apply even after a reboot. 
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Docker", [EnvironmentVariableTarget]::Machine)

dockerd.exe --register-service
Start-Service docker

# Kontrollera versioner:
docker version
docker help

#TODO: Kontrollera nätverk/Images etc...
Get-ContainerNetwork
Get-NetNat
Get-VMSwitch


<# Install Docker on Windows 10:

    Enable-WindowsOptionalFeature -Online -FeatureName containers -All
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

    Invoke-WebRequest "https://master.dockerproject.org/windows/amd64/docker-1.13.0-dev.zip" -OutFile "$env:TEMP\docker-1.13.0-dev.zip" -UseBasicParsing -Verbose
    Expand-Archive -Path "$env:TEMP\docker-1.13.0-dev.zip" -DestinationPath $env:ProgramFiles -Verbose -Force

#>

<#Install Docker on Nano Server:

    #First run Windows Update
    $sess = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
    Invoke-CimMethod -InputObject $sess -MethodName ApplyApplicableUpdates
    Restart-Computer

    Install-PackageProvider NanoServerPackage
    Install-NanoServerPackage -Name Microsoft-NanoServer-Containers-Package -Culture "en-US" -Verbose
    Restart-Computer

    # Install Docker on Server (Snippet):
    New-Item -Path C:\Setup -ItemType Directory -Force -Verbose
    $Params = @{
        Uri             = "https://download.docker.com/components/engine/windows-server/cs-1.12/docker.zip"
        OutFile         = "C:\Setup\docker.zip"
        UseBasicParsing = $true
    }
    Invoke-WebRequest @Params -Verbose

    Expand-Archive -Path "C:\Setup\docker.zip" -DestinationPath $env:ProgramFiles -Verbose

    # For quick use, does not require shell to be restarted.
    $env:path += ";c:\program files\docker"

    dockerd --register-service

    Start-Service Docker -Verbose

    # Setup remote management:
    netsh advfirewall firewall add rule name="Docker daemon " dir=in action=allow protocol=TCP localport=2375
    new-item -Type File c:\ProgramData\docker\config\daemon.json
    Add-Content 'c:\programdata\docker\config\daemon.json' '{ "hosts": ["tcp://0.0.0.0:2375", "npipe://"] }'
    Restart-Service docker

#>

<#
    USEFUL LINKS:

    https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_server
    https://blog.sixeyed.com/1-2-3-iis-running-in-nano-server-in-docker-on-windows-server-2016
    https://msdn.microsoft.com/en-us/virtualization/windowscontainers/deployment/deployment_nano

#>