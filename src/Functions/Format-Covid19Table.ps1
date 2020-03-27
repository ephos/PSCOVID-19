function Format-Covid19Table {
    [CmdletBinding()]
    param(
        # CountryOrRegion Filter
        [Parameter(Mandatory=$true)]
        [string]
        $CountryOrRegion,
        # CountyOrDistrict Filter
        [Parameter(Mandatory=$false)]
        [string]
        $ProvinceOrState
    )
    process {

        $ProgressPreference = 'SilentlyContinue'

        # I don't like this but I am going to do it since a lot of ya'll are living in the PS 5.1 stone age...
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $esc = "`e"
        } else {
            $esc = [Char](0x1b)
        }

        if ($PSBoundParameters.ContainsKey('CountryOrRegion')) {

            # Country or region specified
            $data = (Get-COVID19Data).where({$_.CountryOrRegion -eq "$CountryOrRegion"})

            # Country or region and province or state specified
            if ($PSBoundParameters.ContainsKey('ProvinceOrState')) {
                $data = $data.where({
                    $_.ProvinceOrState -eq "$ProvinceOrState"
                })
            }
        }
        else {
            $data = Get-COVID19Data
        }

        $data | Sort-Object -Property ProvinceOrState | Format-Table -AutoSize -Property @(
            @{N='CountryOrRegion';E={$_.CountryOrRegion}}
            @{N='ProvinceOrState';E={$_.ProvinceOrState}}
            @{N='CountyOrDistrict';E={$_.CountyOrDistrict}}
            @{N='LastUpdate';E={$_.LastUpdate}}
            @{N='Confirmed';E={ "$esc[38;2;255;128;0m" + $_.Confirmed + "$esc[0m"}}
            @{N='Active';E={ "$esc[38;2;255;128;0m" + $_.Confirmed + "$esc[0m"}}
            @{N='Deaths';E={ "$esc[38;2;236;23;23m" + $_.Deaths + "$esc[0m"}}
            @{N='Recovered';E={ "$esc[38;2;72;225;22m" + $_.Recovered + "$esc[0m"}}
            @{N='Latitude';E={$_.Latitude}}
            @{N='Longitude';E={$_.Longitude}}
        )

        $ProgressPreference = 'Continue'
    }
}