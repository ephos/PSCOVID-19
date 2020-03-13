function Start-Covid19Tracker {
    [CmdletBinding()]
    param(
        # Update interval in minutes
        [Parameter(Mandatory=$false)]
        [ValidateRange(30,60)]
        [int]
        $UpdateInteraval = 60,
        # CountryOrRegion Filter
        [Parameter(Mandatory=$false)]
        [string]
        $CountryOrRegion
    )
    process {

        $ProgressPreference = 'SilentlyContinue'

        # I don't like this but I am going to do it since a lot of ya'll are living in the PS 5.1 stone age...
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $esc = "`e"
        } else {
            $esc = [Char](0x1b)
        }

        while ($true) {
            if ($PSBoundParameters.ContainsKey('CountryOrRegion')) {
                # Country or region specified
                $data = (Get-COVID19Data).where({$_.CountryOrRegion -eq "$CountryOrRegion"})
            } 
            else {
                $data = Get-COVID19Data
            }

            Clear-Host
            $data | Format-Table -AutoSize -Property @(
                @{N='CountryOrRegion';E={$_.CountryOrRegion}}
                @{N='ProvinceOrState';E={$_.ProvinceOrState}}
                @{N='LastUpdate';E={$_.LastUpdate}}
                @{N='Confirmed';E={ "$esc[38;2;255;128;0m" + $_.Confirmed}}
                @{N='Deaths';E={ "$esc[38;2;236;23;23m" + $_.Deaths}}
                @{N='Recovered';E={ "$esc[38;2;72;225;22m" + $_.Recovered}}
                @{N='Latitude';E={$_.Latitude}}
                @{N='Longitude';E={$_.Longitude}}
            )
            Write-Output -InputObject "Refreshing every $esc[38;2;72;225;22m$UpdateInteraval$esc[0m seconds.  Last update was: $esc[38;2;72;225;22m$([DateTime]::now)$esc[0m`nPress $esc[38;2;252;223;0mctrl+c$esc[0m to exit..."
            
            Start-Sleep -Seconds $UpdateInteraval
        }
    }
}