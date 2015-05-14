# iojsinstaller
Automatically install iojs in Linux. Currently this script is tested on Ubuntu 12 or later, CentOS 6 or later.

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

To remove iojs installation
`sudo ./remove_iojs.sh`