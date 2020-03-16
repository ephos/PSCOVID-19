function Get-COVID19Data {
    [CmdletBinding()]
    param ()
    
    $githubBaseUri = 'https://github.com/'

    try {
        Write-Verbose -Message 'Getting links to daily reports.'
        $baseUri = "$githubBaseUri/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports"
        $dailyReports = (Invoke-WebRequest -Uri $baseUri -ErrorAction Stop | Select-Object -ExpandProperty Links).where({ $_.title -like '*.csv' -and $_.title -notlike 'Update*'})

        Write-Verbose -Message 'Getting the latest/newest csv report.'
        $latestReport = $dailyReports | Sort-Object -Property title | Select-Object -Last 1

        Write-Verbose -Message 'Getting link to the raw CSV data.'
        $latestReportUri = ("$githubBaseUri{0}"-f $latestReport.href)
        $latestReportData  = (Invoke-WebRequest -Uri $latestReportUri -ErrorAction Stop).Links.where({ $_.id -eq 'raw-url' })

        Write-Verbose -Message 'Parsing the latest data and deserializing into PowerShell objects.'
        $latestReportRawUri = ("$githubBaseUri{0}" -f $latestReportData.href)
        $covidData = (Invoke-WebRequest -Uri $latestReportRawUri -ErrorAction Stop).Content | ConvertFrom-Csv

    } catch {
        Write-Error -ErrorAction Stop -Message "Could not retreive COVID-19 CICD data from Github, error was:`n`t$_"
    }

    $outPut = [System.Collections.ArrayList]::new()

    foreach ($cd in $covidData) {
        $outPut.Add(
            [Covid]::new(
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

    Write-Output -InputObject $outPut
}