#!/bin/bash
## Check version of iojs

# return 0 if a command does not exist
function checkIfCommandExist {
  command -v $1 >/dev/null 2>&1 || {
  #not found 
  echo 0
    return
  }
  #found
  echo 1
}

# Detect Linux name and version.
function getOSVersion {
  if [ -f "/etc/os-release" ]; then
    ##It is likely Ubuntu
    osname=`cat /etc/os-release | grep ID= | head -1 | sed 's/\"//g'`
    osname=${osname:3}                                 
    osversion=`cat /etc/os-release | grep VERSION_ID= | head -1 |  sed 's/\"//g'`
    osversion=${osversion:11}
    osname=$osname$osversion
    return
  fi

  if [ -f "/etc/system-release" ]; then
    sysrelease=`cat /etc/system-release`
    ## CentOS
    if [[ $sysrelease == CentOS* ]]; then        
      ##https://www.centos.org/forums/viewtopic.php?t=488
      osversion=`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`
      osname="centos$osversion"      
      return
    fi
    ## Fedora
    if [[ $sysrelease == Fedora* ]]; then
      osversion=`rpm -q --qf "%{VERSION}" fedora-release`
      osname="fedora$osversion"
      return
    fi
  else
    echo "Sorry my script only supports CentOS, Ubuntu and Fedora"
    exit
  fi

  #  Ubuntu
  ubuntu_Cmd=`lsb_release -a`
  if [ "${ubuntu_Cmd}" != "" ] ;then
    ID=`"${ubuntu_Cmd}"|grep ID| awk '{print $3}'`
    Release=`lsb_release -a|grep Release| awk '{print $2}'`
    osname="$ID"
    echo -n "$osname"
  else
    echo -n ""
  fi
}

function install {
  if [ -z "$1" ]; then
      echo "You must provide packname to be installed"
      exit
  fi
  case "$osname" in
  Ubuntu)
    apt-get install  $1
    ;;
  centos6)
    yum -y install $1
    ;;
  centos7)
    yum -y install $1
    ;;
  fedora)
    yum -y install $1
    ;;
  esac
}
###################### MAIN LOGIC#################

## Make sure user runs this bash script as root
if [ $(id -u) -ne 0 ]; then
   echo "You need to run as root user"
   echo -e "\e[0;36m"'sudo ./iojs.sh'"\e[0;37m"
   exit
fi

echo "Download and install iojs"
getOSVersion

# install curl if it does not exist
if [ $(checkIfCommandExist curl) -eq 0 ]; then
   install curl
fi

# Get version of iojs from argument
if [ -z "$1" ]
then
  echo 'Get iojs version from https://iojs.org'
  #Extract latest version iojs from iojs.org
  temp=`curl -sL https://iojs.org/en/index.html |
  grep -Eoi '<a [^>]+>' | 
  grep https://iojs.org/dist/ | 
  awk '{print $2}' | 
  awk -F"/"  '{print $5}' | 
  head -1 |
  sed 's/^.//'`
   iojsversion=${temp}
  echo $iojsversion

  echo "$temp"
else
  iojsversion=$1
fi

# check if node is installed
if [ $(checkIfCommandExist node) -eq 1 ]; then
  nodeversion=$(node -v)
  # Remove v and . from  node version string
  nodeversionnumber=${nodeversion//[v.]/}
  iojsversionnumber=${iojsversion//./}
  if [ $nodeversionnumber -lt $iojsversionnumber ]; then
    echo "Installed node version is older. Upgrade now"
  else
    echo "Installed node version: $nodeversion is up to date"
    exit
  fi
fi


iojsfile="iojs-v${iojsversion}-linux-x64.tar.gz"
# Check if iojs-vx.y.z-linux-x64.tar.gz exists in current path
if [ -f "$iojsfile" ]; then
  echo "$iojsfile found."
else
  echo "$iojsfile not found."
  remote_file=https://iojs.org/dist/v${iojsversion}/${iojsfile}  
  # Use curl to check if remote file is downloadable
  file_exist=$(curl  -s -o /dev/null -IL -w %{http_code} $remote_file)
  if [ $file_exist -eq 200 ]; then
    echo "start download: $remote_file"
    curl -O $remote_file #download and save file to current folder
  else
    echo -e  "\e[41m$remote_file does not exist\e[49m"
    exit
  fi
fi

echo "Extract ${iojsfile}"
tar -xzf ${iojsfile}

if [ -d "iojs-v${iojsversion}-linux-x64" ]
then
  echo "Extract to folder iojs-v${iojsversion}-linux-x64 successfully"
else
  echo "Extract failed"
  exit
fi

echo "Move iojs-v${iojsversion} to /opt folder"
# if in /opt folder there is already iojs folder, then remove it
if [ -d "/opt/iojs-v${iojsversion}" ]
then
  rm -rf /opt/iojs-v${iojsversion}
fi

mv iojs-v${iojsversion}-linux-x64 /opt/iojs-v${iojsversion}

echo "Create symbolic links to iojs, node, npm"
rm -f /usr/bin/iojs
rm -f /usr/bin/node
rm -f /usr/bin/npm

ln -s /opt/iojs-v${iojsversion}/bin/iojs /usr/bin/iojs
ln -s /opt/iojs-v${iojsversion}/bin/node /usr/bin/node
ln -s /opt/iojs-v${iojsversion}/bin/npm /usr/bin/npm

#--------------------------------
echo "node version: `node -v`"
echo "iojs version: `iojs -v`"
echo "npm version: `npm -v`"
#--------------------------------

source node_path.sh -a