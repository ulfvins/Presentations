#Hot add NIC
Add-VMNetworkAdapter –VMName W16-ME1 –Name "BackUpNIC" -SwitchName DEMO -DeviceNaming On

#PowerShell Direct:
Invoke-Command -VMName W16-ME1 -ScriptBlock {
    Get-NetAdapterAdvancedProperty -Name * | Where-Object -FilterScript {$_.DisplayValue -LIKE "BackUpNIC"}
} -Credential DEMO\Administrator