#Unblock files if Windows.
if ($PSVersionTable.Platform -eq 'Windows') {
    Get-ChildItem -Path $PSScriptRoot -Recurse | Unblock-File
}

#Dot source classes.
Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 | Foreach-Object { . $_.FullName }

#Dot source functions.
Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 | Foreach-Object { . $_.FullName }