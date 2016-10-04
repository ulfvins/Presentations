Break
#
#    03 DEMO Composing Containers
#
#    Build by: Richard Ulfvin
#    Run on W16-ME3
#
#    TODO:

#Proxy Helper:
Function Set-ContainerPortProxy { netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=80 connectaddress=(Get-NetNatStaticMapping | select -ExpandProperty InternalIpAddress) connectport=80 }


<# Build a Container Image:
New-Item -ItemType File -Name c:\ContainerBuilds\WebApp\Dockerfile -Force
notepad c:\ContainerBuilds\WebApp\Dockerfile


FROM windowsservercore
RUN ["powershell.exe","Install-WindowsFeature web-server"]
RUN ["powershell.exe","Install-WindowsFeature NET-Framework-45-ASPNET"]  
RUN ["powershell.exe","Install-WindowsFeature Web-Asp-Net45"]

COPY App/ c:\\web-app

RUN powershell New-Website -Name 'my-app' -Port 8081 -PhysicalPath 'c:\web-app' -ApplicationPool '.NET v4.5'

EXPOSE 80

#>

<# NOTE:
Start VS Code, look @ dockerfile for WebApp1
#>

# Build the image V1:
docker build -t app-v1 c:\ContainerBuilds\WebAppV1\

# Run custom image:
docker run -d -p 80:80 app-v1
Set-ContainerPortProxy 

# Starta IE med Ctrl + Shit + P

docker ps
docker stop "<containerid>"


# Build the image V2:
docker build -t app-v2 c:\ContainerBuilds\WebAppV2\

# Run custom image:
docker run -d -p 80:80 app-v2
Set-ContainerPortProxy 

# Starta IE med Ctrl + Shit + P

docker ps
docker stop

# Remove the Container:
docker rm -f "<ContainerName>"

# Remove the image:
docker rmi app-v1 -f


<#
    USEFUL LINKS:

    https://lostechies.com/gabrielschenker/2016/04/30/windows-docker-containers/
    https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/nanoserver/golang
    https://msdn.microsoft.com/en-us/virtualization/windowscontainers/docker/manage_windows_dockerfile

#>