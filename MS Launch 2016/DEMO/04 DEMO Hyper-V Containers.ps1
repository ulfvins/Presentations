Break
#
#    04 DEMO Hyper-V Containers
#
#    Built by: Richard Ulfvin
#    Run on Hyper-V host for W16-ME4
#
#    TODO:

# Replace with the virtual machine name
$vm = "W16-ME4"

# Configure virtual processor
Set-VMProcessor -VMName $vm -ExposeVirtualizationExtensions $true -Count 2

# Disable dynamic memory
Set-VMMemory $vm -DynamicMemoryEnabled $false

# Enable mac spoofing
Get-VMNetworkAdapter -VMName $vm | Set-VMNetworkAdapter -MacAddressSpoofing On