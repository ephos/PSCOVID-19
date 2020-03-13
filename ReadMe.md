# ReadMe

[![Build Status](https://ephos.visualstudio.com/PSCOVID-19/_apis/build/status/ephos.PSCOVID-19?branchName=master)](https://ephos.visualstudio.com/PSCOVID-19/_build/latest?definitionId=3&branchName=master)

## PSCOVID-19

This was a project born out of wanting to just write some code as more cases of COVID-19 started popping up throughout the United States.

This uses the same CSV data files in the Johns Hopkins CSSE [GitHub Repository](https://github.com/CSSEGISandData/COVID-19).  This is a side project I just wanted to write to tinker with data, <span style="color:blue">__**I am in NO WAY affiliated with any health organization or Johns Hopkins**__</span>!

## Install and Usage

Installing the module.

```powershell
# Install module.
Install-Module -Name PSCOVID-19 -Scope CurrentUser
```

As of now the module only has limited functionality.

If you want to get all of the data to manipulate it yourself.  Use `Get-COVID19Data`, it will return a list of `[Covid]` objects that you can manipulate with built-in PowerShell Cmdlets.

```powershell
# Get the data
$data = GetGet-COVID19Data

# Get all confirmed cases by US
$data | Where-Object -FilterScript {$_.CountryOrRegion -eq 'US'} | Measure-Object -Property Confirmed -Sum
```

You can start the "tracker" which updates periodically against the data.  _The data refresh is always dependent on the data that Johns Hopkins is aggregating._

```powershell
# Get all United States cases ('ctrl+c' to exit back to console)
Start-Covid19Tracker -CountryOrRegion US
```

Below is an image of the output using China as an example.
![example1](images/example1.png)

## Links

- [Johns Hopkins GitHub Repository](https://github.com/CSSEGISandData/COVID-19)
- [Coronavirus disease 2019 (COVID-19) Wikipedia](https://en.wikipedia.org/wiki/Coronavirus_disease_2019)
