$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Path $here -Parent

$modulePath = Join-Path -Path $root -ChildPath \src
$moduleName = (Get-Item -Path "$modulePath\*.psd1").BaseName
$moduleManifest = Join-Path -Path $modulePath -ChildPath "$moduleName.psd1"
$functionsPath = Join-Path -Path $modulePath -ChildPath 'Functions\'
$functionsAll = Get-ChildItem -Path $functionsPath

Describe "$module Module Structure and Validation Tests" -Tag Unit -WarningAction SilentlyContinue {
    Context 'Manifest Validation' {
        $script:manifest = $null

        It 'has a valid manifest' {
            {$script:manifest = Test-ModuleManifest -Path $moduleManifest -ErrorAction Stop -WarningAction SilentlyContinue} | Should Not throw
        }

        It 'has a valid name in the manifest' {
            $script:manifest.Name | Should Be $moduleName
        }

        It 'has a valid root module' {
            $script:manifest.RootModule | Should Be ($moduleName + ".psm1")
        }

        It 'has a valid version in the manifest' {
            $script:manifest.Version -as [System.Version] | Should Not BeNullOrEmpty
        }

        It 'has a valid description' {
            $script:manifest.Description | Should Not BeNullOrEmpty
        }

        It 'has a valid author' {
            $script:manifest.Author | Should Not BeNullOrEmpty
        }

        It 'has a valid guid' {
            {[guid]::Parse($script:manifest.Guid)} | Should Not throw
        }

		It 'has the same number of exported public functions for function ps1 files' {
			($script:manifest.ExportedFunctions.GetEnumerator() | Measure-Object).Count | Should be ($functionsAll | Measure-Object).Count
		}
    }

    Context 'Structure Validation' {
        It "has the root module $module.psm1" {
            "$modulePath\$moduleName.psm1" | Should Exist
        }

        It "has the a manifest file of $module.psd1" {
            "$modulePath\$moduleName.psd1" | Should Exist
        }

		It "has a Functions directory" {
			"$modulePath\Functions\*.ps1" | Should Exist
		}

        It "$moduleName is valid PowerShell code" {
            $psFile = Get-Content -Path "$modulePath\$moduleName.psm1" -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
            $errors.Count | Should Be 0
        }
    }

    foreach ($script:function in $functionsAll)
    {
        Context $script:function.BaseName {

            $script:functionContents = $null
            $script:psParserErrorOutput = $null
            $script:functionContents = Get-Content -Path $script:function.FullName

            It 'has no syntax errors'  {
                [System.Management.Automation.PSParser]::Tokenize($script:functionContents, [ref]$script:psParserErrorOutput)

                ($script:psParserErrorOutput | Measure-Object).Count | Should Be 0

                Clear-Variable -Name psParserErrorOutput -Scope Script -Force
            }

			if (($Script:function.PSParentPath -split "\\" | Select-Object -Last 1) -eq 'Functions' )
			{
				It 'is a public function and exported in the module manifest' {
					$manifest.ExportedCommands.Keys.GetEnumerator() -contains $script:function.BaseName | Should be True
				}
			}
        }
    }
}
