[CmdletBinding()]
param(
  [Parameter(Position=0,mandatory=$true)]
  [String]$target_exe,

  [Parameter(Position=1,mandatory=$true)]
  [String]$res_type,

  [Parameter(Position=2,mandatory=$true)]
  [String]$res_item,

  [Parameter(Position=3,mandatory=$true)]
  [String]$res_file,

  [Parameter(Mandatory=$false)]  
  [UInt16]$lang = 0
)

. $PSScriptRoot\exe_resource_editor_util.ps1

Write-Host $pwd

if ($false -eq [System.IO.File]::Exists($target_exe)) {
  $target_exe_tentative_path = Join-Path -Path $pwd -ChildPath $target_exe
  if ($false -eq [System.IO.File]::Exists($target_exe_tentative_path)) {
    Write-Error("Cannot find exe file: {0}" -f $target_exe)
    return $false
  }
  $target_exe = $target_exe_tentative_path
}

if ($false -eq [System.IO.File]::Exists($res_file)) {
  $res_file_tenative_path = Join-Path -Path $pwd -ChildPath $res_file
  if ($false -eq [System.IO.File]::Exists($res_file_tenative_path)) {
    Write-Error("Cannot find resource file: {0}" -f $res_file)
    return $false
  }
  $res_file = $res_file_tenative_path
}

$res_content_bytes = [System.IO.File]::ReadAllBytes($res_file)

UpdateExeResource $target_exe $res_type $res_item $res_content_bytes $lang
