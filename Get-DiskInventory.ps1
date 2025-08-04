<#
.SYNOPSIS
Get-DiskInventory retrieves logical disk information from one or more computers. 
.DESCRIPTION
Get-DiskInventory users CIM to retrieve the Win32_LogicalDisk instances from one or more computers. It displays each disk's drive letter, free space, total size, and percentage of free spcace. 
.PARAMETER computername
The computuer name, or names, to query. Default: Localhost.
.PARAMETER drivetype
The drive type to query. See Win32_LogicalDisk documentation for values. 3 is a fixed disk, and is the default. 
.EXAMPLE
Get-DiskInventory -computername SRV02 -drivetype 3
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,HelpMessage="Enter a computer name to query")]
    [Alias('host')]
    [string]$computername,

    [ValidateSet(2, 3)]
    [int]$drivetype = 3
)

Write-Verbose "Connecting to $computername"
Write-Verbose "Looking for drive type $drivetype"
Get-CimInstance -class win32_LogicalDisk -computername $computername -filter "drivetype=$drivetype" |
Sort-Object -property DeviceID | 
Select-Object -property DeviceID,
@{label='FreeSpace(GB)';expression={$_.FreeSpace / 1GB -as [int]}},
@{label='Size(GB)';expression={$_.size / 1GB -as [int]}},
@{label='%Free';expression={$_.FreeSpace / $_.Size * 100 -as [int]}}
Write-Verbose "Finished running command"
