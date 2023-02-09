$password = Get-Content C:\Scripts\Container\PoshSS.txt | ConvertTo-SecureString -Key (Get-Content C:\Scripts\Container\aes.key)
$VCcreds = New-Object System.Management.Automation.PsCredential("domain\SVCACCT",$password)

if($global:defaultviserver)
{
    Disconnect-VIServer -Confirm:$false -ErrorAction Ignore -Server *
}

try{
Connect-VIServer [VCENTER] -ErrorAction Stop -Credential $VCcreds -AllLinked
}
catch [VMware.VimAutomation.Sdk.Types.V1.ErrorHandling.VimException.ViServerConnectionException]{
#Collect-Errors -LogLines $_ -Label "Failed connect to vServer" -Level FATAL -LineNum (Get-CurrentLine) -PassedList ([ref]$NotificationLog)
#Write-ToMasterLog -Entries $NotificationLog -Header $Header
exit
}
catch{
continue
}

Start-Sleep -Seconds 5

$directory = New-Object System.DirectoryServices.DirectoryEntry("LDAP://[HORIZONCXSERVER]:389/OU=Server Groups,DC=vdi,DC=vmware,DC=int")

$objTemplateObject = New-Object -TypeName psobject

$objTemplateObject | Add-Member -MemberType NoteProperty -Name Name -Value $null
$objTemplateObject | Add-Member -MemberType NoteProperty -Name MI -Value $null
$objTemplateObject | Add-Member -MemberType NoteProperty -Name SS -Value $null
$objTemplateObject | Add-Member -MemberType NoteProperty -Name ou -Value $null
$objTemplateObject | Add-Member -MemberType NoteProperty -Name Total -Value $null
$objTemplateObject | Add-Member -MemberType NoteProperty -Name defaultProtocol -Value $null
$objTemplateObject | Add-Member -MemberType NoteProperty -Name timeout -Value $null
$objTemplateObject | Add-Member -MemberType NoteProperty -Name HTML -Value $null

$objList = New-Object System.Collections.ArrayList

foreach ($pool in $directory.psbase.Children)
{
    $objTemp = $objTemplateObject | select *

    $objTemp.Name = ($pool.'pae-DisplayName').ToString()
    $objTemp.MI = ($pool.'pae-SVIVmParentVM').ToString().split('/') | Select-Object -Last 1
    $objTemp.SS = ($pool.'pae-SVIVmSnapshot').ToString().Split("/") | select -Last 1
    $objTemp.ou = ($pool.'pae-ContainterPath').ToString()
    $objTemp.total = ($pool.'pae-VmMaximumCount').ToString()
    $objTemp.defaultProtocol = ($pool.'pae-ServerProtocolDefault').ToString()
    $objTemp.timeout = ($pool.'pae-OptDisconnectLimitTimeout').ToString()
    $objTemp.HTML = ($pool.'pae-HTMLAccessEnabled').ToString()


    $objList.Add($objTemp) | Out-Null
}
<#
# If you have more than 1 VDI environment int the same domain - Test and Prod for example
$directory2 = New-Object System.DirectoryServices.DirectoryEntry("LDAP://[HORIZONCXSERVER2]:389/OU=Server Groups,DC=vdi,DC=vmware,DC=int")

foreach ($pool in $directory2.psbase.Children)
{
    $objTemp = $objTemplateObject | select *

    $objTemp.Name = ($pool.'pae-DisplayName').ToString()
    $objTemp.MI = ($pool.'pae-SVIVmParentVM').ToString().split('/') | Select-Object -Last 1
    $objTemp.SS = ($pool.'pae-SVIVmSnapshot').ToString().Split("/") | select -Last 1
    $objTemp.ou = ($pool.'pae-ContainterPath').ToString()
    $objTemp.total = ($pool.'pae-VmMaximumCount').ToString()
    $objTemp.defaultProtocol = ($pool.'pae-ServerProtocolDefault').ToString()
    $objTemp.timeout = ($pool.'pae-OptDisconnectLimitTimeout').ToString()
    $objTemp.HTML = ($pool.'pae-HTMLAccessEnabled').ToString()


    $objList.Add($objTemp) | Out-Null
}#>

$MIFolder = Get-Folder -Name [MASTERIMAGEFOLDER] -Server [VCENTER]

$unusedMI = Get-VM -Name [MASTERIMAGE-PREFIX]* -Location $MIFolder | Where-Object {$_.name -notlike "*_BAK*" -and ($objList | Select-Object -ExpandProperty MI) -notcontains $_.name} 

$unusedSS = Get-VM -Name AGM* -Location $MIFolder | Where-Object {$_.name -notlike "*_BAK*" -and ($objList | Select-Object -ExpandProperty MI) -contains $_.name} | Get-Snapshot | Select-Object *| Where-Object {($objList | Select-Object -ExpandProperty SS) -notcontains $_.name} | Select-Object -Property Name,VM

if($objList.Count -gt 0)#report does not send if empty
{
    #Generate html for email body
    $file = "C:\temp\HZreport-body.html"

    New-Item -Path $file -ItemType File -Force

    Add-Content -Path $file -Value "<html><head></head><hr>"
    Add-Content -Path $file -Value "<b>VDI Report for VDI BROS</b><br>"
    Add-Content -Path $file -Value "<hr>"
    Add-Content -Path $file -Value "<table border='1' style='width:100%'>"
    Add-Content -Path $file -Value "<tr style='background-color:#AAAAAA'><b><td>PoolName</td><td>MasterImage</td><td>Snapshot</td><td>OU</td><td>Max</td><td>DefaultProtocol</td><td>DisconnectTime</td><td>HTML Allowed</td></b></tr>"

    #create body of email in file
    foreach($result in $objList)
    {
        $poolName = $result.Name
        $masterImage = $result.MI
        $snapshot = $result.SS
        $ou = $result.ou
        $max = $result.total
        $defProto = $result.defaultProtocol
        $disTime = $result.timeout
        $htmlAllow = $result.HTML

        Add-Content -Path $file -Value "<tr><td>$poolName</td><td>$masterImage</td><td>$snapshot</td><td>$ou</td><td>$max</td><td>$defProto</td><td>$disTime</td><td>$htmlAllow</td></tr>"
    }

    Add-Content -Path $file -Value "</table><br><br><br><br>"

    Add-Content -Path $file -Value "<b>Unused Master Images</b><br>"
    Add-Content -Path $file -Value "<hr>"
    Add-Content -Path $file -Value "<table border='1' style='width:100%'>"
    Add-Content -Path $file -Value "<tr style='background-color:#AAAAAA'><b><td>Master Image</td></b></tr>"

    #create body of email in file
    foreach($result in $unusedMI)
    {
        $name = $result.name

        Add-Content -Path $file -Value "<tr><td>$name</td>></tr>"
    }

    Add-Content -Path $file -Value "</table><br><br><br><br>"

    Add-Content -Path $file -Value "<b>Unused Snapshots on Used Master Images</b><br>"
    Add-Content -Path $file -Value "<hr>"
    Add-Content -Path $file -Value "<table border='1' style='width:100%'>"
    Add-Content -Path $file -Value "<tr style='background-color:#AAAAAA'><b><td>Master Image</td><td>Snapshot</td></b></tr>"

    #create body of email in file
    foreach($result in $unusedSS)
    {
        $image = $result.VM
        $snaps = $result.Name

        Add-Content -Path $file -Value "<tr><td>$image</td><td>$snaps</td></tr>"
    }

    #close file
    Add-Content -Path $file -Value "</table></html>"



    #Now let's send the email    
    $body = [System.IO.File]::ReadAllText($file)
    $subject = "VDI Report"
    $to = "VDIteam@eamil.com"
    Send-MailMessage -Body $body -Subject $subject -From "VDIreport@email.com" -To $to -SmtpServer [SMTPSERVER] -Port 25 -BodyAsHtml


    #let's cleanup the temp file
    Remove-Item -Path $file -Force -ErrorAction SilentlyContinue
}

Stop-Transcript