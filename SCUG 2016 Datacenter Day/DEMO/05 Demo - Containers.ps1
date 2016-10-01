# https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_configure_host
# https://msdn.microsoft.com/en-us/virtualization/windowscontainers/deployment/deployment

Install-WindowsFeature -Name Containers -IncludeAllSubFeature -IncludeManagementTools
Restart-Computer

Install-PackageProvider ContainerProvider -Force

Find-ContainerImage

Install-ContainerImage -Name WindowsServerCore
Get-ContainerImage

New-Container -Name Test -ContainerImageName WindowsServerCore
Get-Container | Start-Container


#If Issue (run):
Register-PSRepository -Name "PSGallery" –SourceLocation "https://www.powershellgallery.com/api/v2/" -InstallationPolicy Trusted 