Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
 
public static class ResourceEditor
{
    [DllImport("Kernel32.dll", CharSet=CharSet.Auto)]
        public static extern IntPtr BeginUpdateResourceW(
          String  pFileName,
          bool    bDeleteExistingResources
        );

    [DllImport("Kernel32.dll", CharSet=CharSet.Auto)]
        public static extern bool UpdateResourceW(
          IntPtr          hUpdate,
          String          lpType,
          String          lpName,
          ushort          wLanguage,
          System.Byte[]   lpData,
          uint            cb
        );

    [DllImport("Kernel32.dll", CharSet=CharSet.Auto)]
        public static extern bool EndUpdateResourceW(
          IntPtr hUpdate,
          bool   fDiscard
        );

    [DllImport("Kernel32.dll", CharSet=CharSet.Auto)]
        public static extern uint GetLastError();
}
"@

function UpdateExeResource($target_exe, $res_type, $res_item, $res_content_bytes, $lang) {
  $handle = [ResourceEditor]::BeginUpdateResourceW($target_exe, $false)
  Write-Output("Update resource handle: {0}" -f $handle)
  if ($handle -eq 0) {
    Write-Error("BeginUpdateResourceW failed. Error: {0}" -f [ResourceEditor]::GetLastError())
    return $false 
  }
  
  Write-Host("Updating resource for: {0}. Res type: {1}. Res item: {2}. Languauge: {3}." -f $target_exe, $res_type, $res_item, $lang)
  $update_result = [ResourceEditor]::UpdateResourceW($handle, $res_type, $res_item, $lang, $res_content_bytes, $res_content_bytes.length)
  Write-Output("UpdateResourceW res: {0}" -f $update_result)
  if ($update_result -eq $false) {
    Write-Error("UpdateResourceW failed. Error: {0}" -f [ResourceEditor]::GetLastError())
    return $false
  }
  
  $end_result = [ResourceEditor]::EndUpdateResourceW($handle, $false)
  Write-Output("EndUpdateResourceW res: {0}" -f $end_result)
  if ($end_result -eq $false) {
    Write-Error("EndUpdateResourceW failed. Error: {0}" -f [ResourceEditor]::GetLastError())
    return $false
  }

  return $true
}

