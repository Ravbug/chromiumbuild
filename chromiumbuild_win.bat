@echo off

:: Download depot_tools and expand it
echo Downloading depot_tools
bitsadmin /transfer TransferJobName /priority high https://storage.googleapis.com/chrome-infra/depot_tools.zip %CD%\depot_tools.zip
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('depot_tools.zip', 'depot_tools'); }"
del /f depot_tools.zip

:: set environment variables
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set PATH=%PATH%;%cd%\depot_tools

:: run gclient
echo Running gclient
gclient

:: Download chromium source
echo Downloading Chromium source code
mkdir chromiumbuild
cd chromiumbuild
:: fetch --no-history --nohooks chromium
cd src

:: Configure GN build
set args="is_debug=false is_component_build=false symbol_level=0 blink_symbol_level=0 enable_stripping=true thin_lto_enable_optimizations=true"
echo Using args %args%
gn gen out\Default --args=$args

:: Run build
echo Building Chromium
::autoninja -C out\Default chrome

:: Copy out executable and dependent data

:: Cleanup
echo Cleaning up
cd ..\..

