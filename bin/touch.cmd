:: src: https://stackoverflow.com/a/30019017

@echo off
setlocal enableextensions disabledelayedexpansion

(
	for %%a in (%*) do if exist "%%~a" (
		pushd "%%~dpa" && ( copy /b "%%~nxa"+,, & popd )
	) else (
		type nul > "%%~fa"
	)
) >nul 2>&1
