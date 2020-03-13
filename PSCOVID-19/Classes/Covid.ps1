class Covid {
    # Props
    [string] $CountryOrRegion
    [string] $ProvinceOrState
    [DateTime] $LastUpdate
    [int64] $Confirmed
    [int64] $Deaths
    [int64] $Recovered
    [double] $Latitude
    [double] $Longitude

    # Empty constructor
    Covid () {

    }

    # Full constructor
    Covid (
        [string] $CountryOrRegion,
        [string] $ProvinceOrState,
        [DateTime] $LastUpdate,
        [int64] $Confirmed,
        [int64] $Deaths,
        [int64] $Recovered,
        [double] $Latitude,
        [double] $Longitude
    ){
        $this.CountryOrRegion = $CountryOrRegion
        $this.ProvinceOrState = $ProvinceOrState
        $this.LastUpdate = $LastUpdate
        $this.Confirmed = $Confirmed
        $this.Deaths = $Deaths
        $this.Recovered = $Recovered
        $this.Latitude = $Latitude
        $this.Longitude = $Longitude
    }
}