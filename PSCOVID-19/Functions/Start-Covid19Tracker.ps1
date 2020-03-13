function Start-Covid19Tracker {
    [CmdletBinding()]
    param(
        # US Filter
        [Parameter(Mandatory=$false)]
        [ValidateSet('All', 'New England')]
        [string]
        $States = 'All'
    )
    process {
        do {

            $ProgressPreference = 'SilentlyContinue'
            $cd = Get-COVID19Data

            Clear-Host

            switch ($States) {
                'All' {
                    $cd.where({$_.CountryOrRegion -eq 'US'}) | Format-Table -AutoSize -Property @(
                        @{N='CountryOrRegion';E={$_.CountryOrRegion}}
                        @{N='ProvinceOrState';E={$_.ProvinceOrState}}
                        @{N='LastUpdate';E={$_.LastUpdate}}
                        @{N='Confirmed';E={ "`e[38;2;255;128;0m" + $_.Confirmed}}
                        @{N='Deaths';E={ "`e[38;2;236;23;23m" + $_.Deaths}}
                        @{N='Recovered';E={ "`e[38;2;72;225;22m" + $_.Recovered}}
                        @{N='Latitude';E={$_.Latitude}}
                        @{N='Longitude';E={$_.Longitude}}
                    )
                }
                'New England' {
                    $table = $cd.where({$_.CountryOrRegion -eq 'US'}).where(
                        {
                            ($_.ProvinceOrState -eq 'Rhode Island') -or 
                            ($_.ProvinceOrState -eq 'Massachusetts') -or 
                            ($_.ProvinceOrState -eq 'Connecticut') -or
                            ($_.ProvinceOrState -eq 'Maine') -or
                            ($_.ProvinceOrState -eq 'Vermont') -or
                            ($_.ProvinceOrState -eq 'New Hampshire')
                    })
                }
                Default {Write-Error -ErrorAction Stop -Message 'Internal exception:  Invalid case for "States" switch.'}
            }

            $table | Format-Table -AutoSize -Property @(
                @{N='CountryOrRegion';E={$_.CountryOrRegion}}
                @{N='ProvinceOrState';E={$_.ProvinceOrState}}
                @{N='LastUpdate';E={$_.LastUpdate}}
                @{N='Confirmed';E={ "`e[38;2;255;128;0m" + $_.Confirmed}}
                @{N='Deaths';E={ "`e[38;2;236;23;23m" + $_.Deaths}}
                @{N='Recovered';E={ "`e[38;2;72;225;22m" + $_.Recovered}}
                @{N='Latitude';E={$_.Latitude}}
                @{N='Longitude';E={$_.Longitude}}
            )

            Start-Sleep -Seconds 10

        } until ($false)
    }
}