<#
	.SYNOPSIS
	Add bin directory by appending to PATH in user environment variable.
	.OUTPUTS
	Null if success, or user PATH already contains bin.
	Throw exception if bin directory does not exist.
#>
function Add-BinPath {
	$binPath = Join-Path $PSScriptRoot '.\bin'
	if (-not (Test-Path $binPath)) {
		throw New-Object System.IO.DirectoryNotFoundException("Path does not exist: $binPath")
	}
	$binPath = Resolve-Path $binPath
	$currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
	if ($currentPath -like "*$binPath*") {
		Write-Warning 'Skipped: PATH already contains the bin directory.'
		Write-Information 'Done.' -InformationAction Continue
		return
	}
	$updatedPath = "$binPath;$currentPath"
	[Environment]::SetEnvironmentVariable('PATH', $updatedPath, 'User')
	Write-Information 'Done.' -InformationAction Continue
	return
}

<#
	.SYNOPSIS
	Install Chocolatey package manager.
	.OUTPUTS
	Null if success, or Chocolatey is already installed.
	Throw exception if fail to install Chocolatey.
#>
function Install-Chocolatey {
	if (Get-Command choco -ErrorAction SilentlyContinue) {
		Write-Warning 'Skipped: Chocolatey is already installed.'
		Write-Information 'Done.' -InformationAction Continue
		return
	}
	try {
		$url = 'https://community.chocolatey.org/install.ps1'
		Set-ExecutionPolicy Bypass -Scope Process -Force
		[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
		Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($url))
	}
	catch {
		throw New-Object System.Exception("Failed to install Chocolatey: $_")
	}
	Write-Information 'Done.' -InformationAction Continue
	return
}

Export-ModuleMember -Function Add-BinPath
Export-ModuleMember -Function Install-Chocolatey
