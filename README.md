# chromiumbuild
This script will automatically compile the latest Chromium build from source and generate a release build.

This script can take many hours to run. On a mobile Core i9 and a gigabit internet connection this took over four hours to run. 

## How to use
1. Download the latest release (or if there is none, clone this repo)
2. (Mac) give yourself execute permissions with `chmod +x chromiumbuild_mac.sh`
3. Run `./chromiumbuild_mac.sh` or `chromiumbuild_win.bat` and wait. 
The script will run where you have placed it and will write the generated application in the same folder. It will delete all the files it downloads. 

Because chromium does not auto-update, you will currently need to re-run this script and replace your executable.
