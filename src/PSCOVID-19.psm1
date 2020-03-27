# Unblock files if Windows.
if ($PSVersionTable.Platform -eq 'Windows') {
    Get-ChildItem -Path $PSScriptRoot -Recurse | Unblock-File
}

# Dot source classes.
Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 | Foreach-Object { . $_.FullName }

# Dot source functions.
Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 | Foreach-Object { . $_.FullName }

# Argument completion.

# Running this once on import, I don't like it but we need that sweet sweet tab complete.
$argData = Get-COVID19Data

$scriptBlock = {
    param($commandName, $parameterName, $stringMatch)

    $output = $argData | Select-Object -ExpandProperty CountryOrRegion -Unique | Sort-Object
    $output | ForEach-Object {$_}
}
Register-ArgumentCompleter -CommandName Format-Covid19Table -ParameterName CountryOrRegion -ScriptBlock $scriptBlock

$scriptBlock = {
    param($commandName, $parameterName, $stringMatch)

    $output = $argData | Select-Object -ExpandProperty ProvinceOrState -Unique | Sort-Object
    $output | ForEach-Object {$_}
}
Register-ArgumentCompleter -CommandName Format-Covid19Table -ParameterName ProvinceOrState -ScriptBlock $scriptBlock

# Aliases
New-Alias -Name Start-Covid19Tracker -Value Format-Covid19Table -Force
