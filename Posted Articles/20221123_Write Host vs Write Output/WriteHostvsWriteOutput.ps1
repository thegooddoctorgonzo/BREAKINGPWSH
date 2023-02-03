Write-Output "test output" | Get-Member
"test output" | Get-Member
Write-Host "test output" | Get-Member

Get-Process powershell | Select-Object -ExpandProperty path | Get-Item
Get-Process powershell | select -ExpandProperty path | Write-Output | Get-Item

function Test-thing {
    Write-Output "return string"
  }

  function Test-thing {
    $r = "return string"
  return $r
}