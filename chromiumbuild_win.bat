@echo off

:: Download depot_tools and expand it
if not exist depot_tools/ (
	echo Downloading depot_tools
	bitsadmin /transfer depot_tools /priority high https://storage.googleapis.com/chrome-infra/depot_tools.zip %CD%\depot_tools.zip
	powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('depot_tools.zip', 'depot_tools'); }"
	del /f depot_tools.zip
)

:: set environment variables
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set PATH=%PATH%;%cd%\depot_tools

:: run gclient
echo Running gclient
START /WAIT /b cmd /c gclient

echo Downloading Chromium source code
mkdir chromiumbuild
cd chromiumbuild
START /WAIT /b cmd /c "fetch --no-history chromium"
cd src

set args="is_debug=false is_component_build=false symbol_level=0 blink_symbol_level=0 enable_stripping=true thin_lto_enable_optimizations=true"
echo Using args %args%
START /WAIT /b cmd /c "gn gen out\Default --args=%args%"

echo Building Chromium
START /WAIT /b cmd /c "autoninja -C out\Default chrome"

:: Copy out executable and dependent data

:: Cleanup
echo Cleaning up
cd ..\..

