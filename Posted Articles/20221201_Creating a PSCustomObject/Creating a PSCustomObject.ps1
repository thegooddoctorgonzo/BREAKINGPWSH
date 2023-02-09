#create the new object

$objTemplateObject = New-Object -TypeName psobject



#make some properties for it

$objTemplateObject | Add-Member -MemberType NoteProperty -Name Name -Value $null

$objTemplateObject | Add-Member -MemberType NoteProperty -Name CreatedDate -Value $null

$objTemplateObject | Add-Member -MemberType NoteProperty -Name ModifiedDate -Value $null



#create a new dynamic array

$objList = New-Object System.Collections.ArrayList



#create a list of files

foreach($file in $(Get-ChildItem -Path C:\. -Depth 1))

{

    #instantiate 1 of those objects

    $objTemp = $objTemplateObject | Select-Object *

    #add values to the properties

    $objTemp.Name = $file.Name

    $objTemp.CreatedDate = $file.CreationTime

    $objTemp.ModifiedDate = $file.LastWriteTime

    #add the object to an array

    $objList.Add($objTemp) | Out-Null

}