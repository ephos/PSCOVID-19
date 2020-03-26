class Covid {
    # Props
    [string] $CountryOrRegion
    [string] $ProvinceOrState
    [string] $CountyOrDistrict
    [DateTime] $LastUpdate
    [int64] $Confirmed
    [int64] $Deaths
    [int64] $Recovered
    [int64] $Active
    [double] $Latitude
    [double] $Longitude

    # Empty constructor
    Covid () {}

    # Full constructor
    Covid (
        [string] $CountryOrRegion,
        [string] $ProvinceOrState,
        [string] $CountyOrDistrict,
        [DateTime] $LastUpdate,
        [int64] $Confirmed,
        [int64] $Deaths,
        [int64] $Recovered,
        [int64] $Active,
        [double] $Latitude,
        [double] $Longitude
    ){
        $this.CountryOrRegion = $CountryOrRegion
        $this.ProvinceOrState = $ProvinceOrState
        $this.CountyOrDistrict = $CountyOrDistrict
        $this.LastUpdate = $LastUpdate
        $this.Confirmed = $Confirmed
        $this.Deaths = $Deaths
        $this.Recovered = $Recovered
        $this.Recovered = $Active
        $this.Latitude = $Latitude
        $this.Longitude = $Longitude
    }
}