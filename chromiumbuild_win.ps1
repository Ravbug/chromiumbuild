# To run this script without modifying the security setings, invoke like this:
# powershell -ExecutionPolicy Bypass -File file.ps1

# Download and setup depot_tools
Write-Output "Downloading depot_tools..."
(New-Object System.Net.WebClient).DownloadFile("https://storage.googleapis.com/chrome-infra/depot_tools.zip", "$PSScriptRoot\depot_tools.zip")
Expand-Archive -Path depot_tools.zip
Remove-Item -Path depot_tools.zip -force

# add to Path
$Env:Path += ";$PSScriptRoot\depot_tools\"
$Env:DEPOT_TOOLS_WIN_TOOLCHAIN = 0

# run prereq installer
Write-Output "Running gclient..."
& "gclient"
Write-Output "Confirming python"

# Download chromium
Write-Output "Downloading chromium source code..."
$dir = New-Item -ItemType directory -Path chromium
Set-Location -Path chromium
#fetch --no-history chromium
Set-Location -Path src

# configure build
Write-Output "Configuring GN build..."
$args = "is_debug=false is_component_build=false symbol_level=0 blink_symbol_level=0 enable_stripping=true thin_lto_enable_optimizations=true"
Write-Output "Using args $args"
gn gen out\Default --args=$args

# run build
autoninja -C out\Default chrome

# cleanup
cd ../..
# Write-Output "Cleaning up..."
Remove-Item -path depot_tools -recurse -force