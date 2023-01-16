$gci = Get-ChildItem -Path .\README.md

$gci_withname = Get-ChildItem -Path . -Name "README.md" 

$gci_withfilter = Get-ChildItem -Path . | Where-Object {$_.Name -eq "README.md"} 



Write-Output "`n---------------------------`nObject returned properties`n___________" 



$gci 

$gci_withname 

$gci_withfilter 



Write-Output "`nObject Fullname/PSPath`n_________" 



$gci.FullName 

$gci_withname.PSPath 

$gci_withfilter.FullName 



Write-Output "`nObject type name`n_________" 



$gci.GetType().Name 

$gci_withname.GetType().Name 

$gci_withfilter.GetType().Name 



Write-Output "`nObject base type`n__________" 



Write-host "$($gci.GetType().BaseType)" 

Write-host "$($gci_withname.GetType().BaseType)" 

Write-host "$($gci_withfilter.GetType().BaseType)" 





Set-Location C:\Code\



$gci = Get-ChildItem

$gci_name = Get-ChildItem -Path .  -Name "Projects"

$gci_filter = Get-ChildItem -Filter *Projects*

$gci_depth = Get-ChildItem -Depth 1

$gci_depth_fil = Get-ChildItem -Depth 1 -Filter Projects

$gci_depth_name = Get-ChildItem -Depth 1 -Name Projects



Write-Host $gci[0].GetType()

Write-Host $gci_name.GetType()

Write-Host $gci_filter.GetType()

Write-Host $gci_depth[0].GetType()

Write-Host $gci_depth_fil[0].GetType()

Write-Host $gci_depth_name[0].GetType()