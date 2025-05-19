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

Export-ModuleMember -Function Add-BinPath
