<#
	.SYNOPSIS
	Adds the bin directory to PATH in user environment variable.
	.OUTPUTS
	Null for success or user PATH already contains bin.
	Throws an exception if required bin directory does not exist in your machine.
#>
function Add-BinPath {
	$binPath = Join-Path $PSScriptRoot '.\bin'
	if (-not (Test-Path $binPath)) {
		throw New-Object System.IO.DirectoryNotFoundException("Path not exists: $binPath")
	}
	$binPath = Resolve-Path $binPath
	$currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
	if ($currentPath -like "*$binPath*") {
		Write-Warning 'PATH already contains the bin directory. Do nothing.'
		Write-Information 'Done.' -InformationAction Continue
		return
	}
	$updatedPath = "$binPath;$currentPath"
	[Environment]::SetEnvironmentVariable('PATH', $updatedPath, 'User')
	Write-Information 'Done.' -InformationAction Continue
	return
}

Export-ModuleMember -Function Add-BinPath
