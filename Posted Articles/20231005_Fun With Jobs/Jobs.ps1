[double]$total = 0
foreach($i in 1..100)
{
    if($i -eq 100)
    {
        foreach($pro in get-process -Name pwsh)
        {   
            [double]$total += [double]($pro | select -ExpandProperty npm )
        }
    }
    else
    {
        Start-Job -Name $i -ScriptBlock {Start-Sleep -s 500} | out-null
        $i | Out-File -FilePath c:\temp\jobcount.txt -Append
    }
}

Get-Job | Stop-Job