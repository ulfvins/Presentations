# Get Prereq files from source media:
$nanoRootLocation = 'C:\LabFiles\NanoCreation'
$nanoCmdLocation  = "$nanoRootLocation\cmdlet"
$diskImage        = Mount-DiskImage -ImagePath 'C:\LabFiles\ISO\14300.1000.160324-1723.RS1_RELEASE_SVC_SERVER_OEMRET_X64FRE_EN-US.ISO' -PassThru | Get-Volume
$driveLetter      = $diskImage.DriveLetter
$nanoImgGenPath   = "$driveLetter" + ":" + "\NanoServer\NanoServerImageGenerator"

# Copy and import module:
if (!(Test-Path -Path "$nanoCmdLocation"))
{
    Copy-Item -Path $nanoImgGenPath -Destination "$nanoCmdLocation" -Recurse 
}
Import-Module "$nanoCmdLocation\NanoServerImageGenerator" -Verbose

# Set properties and build Nano server disk:
$nanoServerParams = @{
    Edition                    = 'Datacenter' 
    DeploymentType             = 'Guest'
    MediaPath                  = $($driveLetter + ":\")
    BasePath                   = "$nanoRootLocation\Base"
    TargetPath                 = "$nanoRootLocation\Output\W16-NA2.vhdx"
    ComputerName               = "W16-NA2"
    InterfaceNameOrIndex       = 'Ethernet'
    Ipv4Address                = '192.168.0.32'
    Ipv4SubnetMask             = '255.255.255.0'
    Ipv4Gateway                = '192.168.0.1'
    Ipv4Dns                    = '192.168.0.21'
    EnableRemoteManagementPort = $true
}

New-NanoServerImage @nanoServerParams