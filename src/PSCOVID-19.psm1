#Unblock files if Windows.
if ($PSVersionTable.Platform -eq 'Windows') {
    Get-ChildItem -Path $PSScriptRoot -Recurse | Unblock-File
}

#Dot source classes.
Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 | Foreach-Object { . $_.FullName }

#Dot source functions.
Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 | Foreach-Object { . $_.FullName }

# Argument completion.

# Try to run this one time so we don't have to run it over and over and over...
$argData = Get-COVID19Data

$scriptBlock = {
    param($commandName, $parameterName, $stringMatch)

    $output = $argData | Select-Object -ExpandProperty CountryOrRegion -Unique | Sort-Object
    $output | ForEach-Object {$_}
}
Register-ArgumentCompleter -CommandName Start-Covid19Tracker -ParameterName CountryOrRegion -ScriptBlock $scriptBlock