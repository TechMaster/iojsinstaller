#!/bin/bash
## Remove node.js installation

## return 0 if a command does not exist
function checkIfCommandExist {
  command -v $1 >/dev/null 2>&1 || {      
        #not found
        echo 0
        return
  }
  #found
  echo 1
}
## check if node is installed
## Make sure user runs this bash script as root
if [ $(id -u) -ne 0 ]; then
   echo "You need to run as root user"
   echo -e "\e[0;36m"'sudo ./remove_iojs.sh'"\e[0;37m"
   exit
fi
if [ $(checkIfCommandExist node) -eq 1 ]; then
  iojsversion=$(node -v)
  # Remove text block that adds path to /opt/iojs-vx.y.z/bin
  ./node_path.sh -r

  rm -f /usr/bin/iojs
  rm -f /usr/bin/node
  rm -f /usr/bin/npm

  if [ -d "/opt/iojs-${iojsversion}" ]; then
    rm -rf /opt/iojs-${iojsversion}
  fi  
fi
echo "Removing iojs done."

