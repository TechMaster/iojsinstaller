# iojsinstaller
Automatically install iojs in Linux. Currently this script is tested on Ubuntu 12 or later, Ubuntu distros, CentOS 6 or later, RedHat, Debian, LinudMint LMDE2

There are two otions:

1. `sudo ./iojs.sh iojs-version` iojs-version is a specific version of iojs you want to install
2. Simpler way `sudo ./iojs.sh` to install latest version of iojs

Installation steps:

1. Open your terminal
2. `git clone https://github.com/TechMaster/iojsinstaller.git`
3. `cd iojsinstaller`
4. `sudo ./iojs.sh`
5. After installation complete, type in terminal to check version of iojs:
	
	* `node -v`
	* `iojs -v`
	* `npm -v`

Quick installation: just copy below line to Terminal and enter
`git clone https://github.com/TechMaster/iojsinstaller.git;cd iojsinstaller;sudo ./iojs.sh`

To remove iojs installation
`sudo ./remove_iojs.sh`


If you encounter bug, feel free to email to me cuong[at]techmaster[dot]vn
