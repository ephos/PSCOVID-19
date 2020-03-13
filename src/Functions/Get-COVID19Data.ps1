function Get-COVID19Data {
    [CmdletBinding()]
    param ()

    # Don't ask me what this RegEx means, came from here: https://stackoverflow.com/questions/15491894/regex-to-validate-date-format-dd-mm-yyyy
    $mdyRegEx = '^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$'
    $githubBaseUri = 'https://github.com/'

    try {
        Write-Verbose -Message 'Getting links to daily reports.'
        $baseUri = "$githubBaseUri/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports"
        $dailyReports = (Invoke-WebRequest -Uri $baseUri -ErrorAction Stop | Select-Object -ExpandProperty Links).where({ $_.title -match "$mdyRegEx*.csv" })

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

    $outPut = [System.Collections.Generic.List[Covid]]::new()

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