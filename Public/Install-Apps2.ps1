# Load the JSON config
$config = Get-Content -Raw -Path "$PSScriptRoot\default.windots.json" | ConvertFrom-Json
$appList = $config.packages
$failedInstallList = @()

foreach ($app in $appList) {
	if ($app.manager -eq "choco") {
		$isInstalled = choco list --local-only --exact $app.name | Select-String "^$($app.name)\s"
		if ($isInstalled) {
			Write-Information "Skipped: Package is already installed: $app.name" -InformationAction Continue
		}
		# Check if package exists in Chocolatey registry
		$info = choco info $app.name --exact 2>&1
		if ($info -match "0 packages found" -or $info -match "not found") {
			throw [System.Management.Automation.ItemNotFoundException]::new("Package not exist in Chocolatey registry: $app.name")
		}

		if (-not $isInstalled) {
			choco install $app.name --yes
		}

		if ($app.pin) {
			choco pin add --name="'$app.name'" --yes
		}
	}
}
