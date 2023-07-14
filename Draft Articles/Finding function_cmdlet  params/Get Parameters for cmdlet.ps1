(get-item Function:\Update-AllBranches).Parameters | Select-Object -ExpandProperty keys
(Get-Command -Name Get-ChildItem).Parameters

$cmdlets = Get-Command -Verb get -Module Microsoft.PowerShell.Management | select -Property *

foreach($c in $cmdlets | where {$_.parameters.keys -contains "ComputerName"})
{
    $c.name
}