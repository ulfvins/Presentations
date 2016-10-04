Break
#
#    02 DEMO Running Containers
#
#    Build by: Richard Ulfvin
#    Run on W16-ME1
#

#Proxy Helper:
Function Set-ContainerPortProxy { netsh interface portproxy add v4tov4 listenaddress=127.0.0.1 listenport=80 connectaddress=(Get-NetNatStaticMapping | select -ExpandProperty InternalIpAddress) connectport=80 }

# Controllera att det fungerar...
docker run microsoft/sample-dotnet

# Lista vad som finns
docker images

#Starta Procmon, sedan starta container:
docker run -it microsoft/windowsservercore cmd

    #Starta PowerShell... visa processen
    #Kör $env:ComputerName, samt Get-Process

docker run -it -p 80:80 microsoft/iis cmd

# Browse to... http://127.0.0.1
Set-ContainerPortProxy

# Change Files:
del C:\inetpub\wwwroot\iisstart.htm
echo "Container Rocks" > C:\inetpub\wwwroot\index.html

# Get IP on Container, browse to...

# Se tidigare körda containers:
docker ps -a

docker commit "NAME OF CONTAINER" modified-iis #Saves a Image...

docker run -it -v C:\ContainerData:c:\Data -p 80:80 microsoft/iis cmd

# Browse to... http://127.0.0.1
Set-ContainerPortProxy

# Add site inside the container... OR just create a file in the container and save it to C:\Data

# powershell New-Website -Name 'my-app' -Port 8081 -PhysicalPath 'c:\Data' -ApplicationPool '.NET v4.5'