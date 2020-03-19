function Get-COVID19Data {
    [CmdletBinding()]
    param ()

    $invokeWebRequestParams = @{
        ErrorAction = 'Stop'
    }
    if ($PSVersionTable.PSEdition -eq 'Desktop') {
        # I don't like having to do this but since some of ya'll are PowerShell 5.1 holdouts it had to be done...
        $invokeWebRequestParams.Add('UseBasicParsing',$true)
    }

    $githubBaseUri = 'https://github.com/'

    try {
        Write-Verbose -Message 'Getting links to daily reports.'
        $baseUri = "$githubBaseUri/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports"
        $dailyReports = (Invoke-WebRequest -Uri $baseUri @invokeWebRequestParams | Select-Object -ExpandProperty Links).where({ $_.title -like '*.csv' -and $_.title -notlike 'Update*'})

        Write-Verbose -Message 'Getting the latest/newest csv report.'
        $latestReport = $dailyReports | Sort-Object -Property title | Select-Object -Last 1

        Write-Verbose -Message 'Getting link to the raw CSV data.'
        $latestReportUri = ("$githubBaseUri{0}"-f $latestReport.href)
        $latestReportData  = (Invoke-WebRequest -Uri $latestReportUri @invokeWebRequestParams).Links.where({ $_.id -eq 'raw-url' })

        Write-Verbose -Message 'Parsing the latest data and deserializing into PowerShell objects.'
        $latestReportRawUri = ("$githubBaseUri{0}" -f $latestReportData.href)
        $covidData = (Invoke-WebRequest -Uri $latestReportRawUri @invokeWebRequestParams).Content | ConvertFrom-Csv

    } catch {
        Write-Error -ErrorAction Stop -Message "Could not retreive COVID-19 CICD data from Github, error was:`n`t$_"
    }

    # $outPut = [System.Collections.ArrayList]::new()
    $output = [System.Collections.Generic.List[Covid]]::new()

    foreach ($cd in $covidData) {
        $output.Add([Covid]::new(
                $cd.'Country/Region',
                $cd.'Province/State',
                $cd.'Last Update',
                $cd.Confirmed,
                $cd.Deaths,
                $cd.Recovered,
                $cd.Latitude,
                $cd.Longitude
            )
        )
    }

    Write-Output -InputObject $output
}