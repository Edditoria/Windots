<#
	.SYNOPSIS
	Script to append bin directory to PATH of current user.
#>

$binPath = Join-Path $PSScriptRoot '..\bin'
if (-not (Test-Path $binPath)) {
	Write-Host "Error: path not exist: $binPath" -ForegroundColor Red
	exit 1
}

$binPath = Resolve-Path $binPath
$currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
if ($currentPath -like "*$binPath*") {
	Write-Host 'Warn: PATH already contains the bin directory. Do nothing.' -ForegroundColor Yellow
	Write-Host 'Done.' -ForegroundColor Green
	exit 0
}

$updatedPath = "$binPath;$currentPath"
[Environment]::SetEnvironmentVariable('PATH', $updatedPath, 'User')
Write-Host 'Done.' -ForegroundColor Green
