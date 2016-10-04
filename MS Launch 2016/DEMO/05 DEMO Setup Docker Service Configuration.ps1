Break
#
#    05 DEMO Docker Service Configuration
#
#    Built by: Richard Ulfvin
#    Run on Hyper-V host for W16-ME4
#
#    TODO:

# Create the Docker Configuration file:
# c:\ProgramData\docker\config\daemon.json

{
    "hosts": ["tcp://0.0.0.0:2375"]
}

sc config docker binpath= "\"C:\Program Files\docker\dockerd.exe\" --run-service -H tcp://0.0.0.0:2375"

Get-EventLog -LogName Application -Source Docker -After (Get-Date).AddMinutes(-40) | Sort-Object Time

<#
    USEFUL LINKS:
    
    https://msdn.microsoft.com/en-us/virtualization/windowscontainers/docker/configure_docker_daemon

#>

