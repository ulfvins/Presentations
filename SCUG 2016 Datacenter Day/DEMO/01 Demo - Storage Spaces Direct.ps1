#Bugg: https://blogs.msdn.microsoft.com/clustering/2015/05/27/testing-storage-spaces-direct-using-windows-server-2016-virtual-machines/

$STS = "W16-ST1","W16-ST2","W16-ST3", "W16-ST4"
$S   = New-PSSession -ComputerName $STS

Invoke-Command -ScriptBlock{
    Add-WindowsFeature -Name "FS-FileServer","Failover-Clustering" -IncludeAllSubFeature -IncludeManagementTools
} -Session $S

#Validate cluster
Test-Cluster –Node $STS –Include "Storage Spaces Direct","Inventory","Network","System Configuration" -Verbose

New-Cluster -Name "TST-CLU01" -Node $STS -NoStorage -StaticAddress "192.168.0.90"
Enable-ClusterS2D -CacheMode Disabled -AutoConfig:0 -SkipEligibilityChecks

#Create storage pool and set media type to HDD
$Param = @{
    StorageSubSystemFriendlyName = "*Cluster*"
    FriendlyName                 = "S2D"
    ProvisioningTypeDefault      = "Fixed"
    PhysicalDisk                 = $(Get-PhysicalDisk | Where-Object CanPool -eq $true)
}
New-StoragePool @Param

Get-StorageSubsystem *cluster* | 
Get-PhysicalDisk | 
Where-Object MediaType -eq "UnSpecified" | 
Set-PhysicalDisk -MediaType HDD

#Create storage tiers
$pool = Get-StoragePool S2D
New-StorageTier -StoragePoolUniqueID ($pool).UniqueID -FriendlyName Performance -MediaType HDD -ResiliencySettingName Mirror
New-StorageTier -StoragePoolUniqueID ($pool).UniqueID -FriendlyName Capacity    -MediaType HDD -ResiliencySettingName Parity

#Create a volume
$Param = @{
    StoragePool              = $pool
    FriendlyName             = "Mirror"
    FileSystem               = "CSVFS_REFS"
    StorageTierFriendlyNames = "Performance", "Capacity"
    StorageTierSizes         = 80GB, 20GB
}
New-Volume @Param