Break
<#


    DEMO Docker
    Build by: Richard Ulfvin


Install-Module AzureRM           -Verbose
Install-Module AzureRM.profile   -Verbose
Install-Module AzureRM.Resources -Verbose
Install-Module AzureRM.Storage   -Verbose
Install-Module AzureRM.Compute   -Verbose
Install-Module AzureRM.Network   -Verbose
Install-Module AzureRM.Dns       -Verbose
#>

$AzureSubCred = Get-Credential
Login-AzureRmAccount -Credential $AzureSubCred

Select-AzureRmSubscription -SubscriptionId 692529f0-a0ae-4fb6-aa9e-a16df69f87cb

$RG         = "RG-DockerDemo"
$VMName     = "DockerHost"
$VMPass     = ""
$VMdns      = "adldockerdemo"

New-AzureRmResourceGroup -Name $RG  -Location "North Europe" -Verbose
$Parameters = @{
    ResourceGroupName = $RG
    TemplateUri       = "https://raw.githubusercontent.com/ulfvins/Presentations/master/DockerWS/ARMTemplate/dockerhost.json"
    TemplateParameterObject = @{
        vmName                                    = $VMName  
        adminPassword                             = $VMPass
        networkSecurityGroups_DockerHost_nsg_name = "$($VMName + '_nsg')"
        dnsLabelPrefix                            = $VMdns
    }
}
    
Test-AzureRmResourceGroupDeployment @Parameters -Verbose
New-AzureRmResourceGroupDeployment  @Parameters -Verbose

Get-AzureRmResourceGroupDeploymentOperation -DeploymentName dockerhost -ResourceGroupName $RG | Select-Object -ExpandProperty Properties | Format-List 

#Start remote desktop
Get-AzureRmRemoteDesktopFile -ResourceGroupName $RG -Name $VMName -Launch

    #On the Windows Server Host:

    # Docker Cmds:
    docker version
    docker info
    docker run microsoft/dotnet-samples:dotnetapp-nanoserver

    # Docker and SQL: https://github.com/docker/labs/tree/master/windows/sql-server

    # https://github.com/alexellis/aspnet-voteservice
    # 1) Start SQL:
    docker run -d --net=nat -p 1433:1433 --name sql --env sa_password=7?107=uoVzejpVeIN39 microsoft/mssql-server-2016-express-windows    
    
    # 2) Incpect SQL IP:
    docker inspect nat

    # 3) Build the image for voting:
    docker build -t voteing:1.0 .

    # 4) Start the image and navigate to URL:
    docker run -d --net=nat --name voting -p 80:80 voting:1.0
    $IP = "<INSERT ip>"
    #VERIFY: http://172.21.24.237/v1/voting/debug
    #OR: Invoke-RestMethod -Method Get  -Uri http://172.21.24.237/v1/voting/debug

    # 5) Submit Votes:
    Invoke-RestMethod -Method Post -Uri http://172.21.24.237/v1/voting/submit/v1/a
    Invoke-RestMethod -Method Post -Uri http://172.21.24.237/v1/voting/submit/v2/b
    Invoke-RestMethod -Method Post -Uri http://172.21.24.237/v1/voting/submit/v3/b

    docker run -d --net=nat --name result -p 4000:4000 -e VOTE_SERVICE_URL=http://172.21.24.237/v1/voting/ result
    

#Remove resource
Remove-AzureRmResourceGroup -Name $RG -Force -Verbose


# Manual Build VM:
# https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-ps-create