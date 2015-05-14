#!/bin/bash
function addupdate_node_path {
	if [[ "$profile" == *"nodeversion=$iojsversion"* ]]; then
		echo $targetFile "has correct nodeversion" $iojsversion
	else
		if [[ "$profile" == *"nodeversion="* ]]; then
			echo 'Going to update value nodeversion'
			sed -i "s/^\(nodeversion\s*=\s*\).*\$/\1$iojsversion/" $targetFile
		else
			echo "Add path of Node global modules to" $targetFile
			printf "\n# BeginNodePath:Add path to nodejs global modules\n" >> $targetFile
			printf "nodeversion=%s\n" "$iojsversion" >> $targetFile
			printf 'PATH=$PATH:/opt/iojs-v$nodeversion/bin' >> $targetFile
			printf "\nexport PATH" >> $targetFile
			printf "\n# EndNodePath\n" >> $targetFile
		fi
		source $targetFile
	fi
}

function remove_node_path {
	if [[ "$profile" == *"nodeversion=$iojsversion"* ]]; then
		# remove everything from # BeginNodePath to # EndNodePath
		# http://serverfault.com/questions/137829/how-to-remove-a-tagged-block-of-text-in-a-file
		sed -i '\:# BeginNodePath:,\:# EndNodePath\n:d' $targetFile
	fi
}

function show_help {
	echo "To add and update path to current Node.js"
	# See color output https://wiki.archlinux.org/index.php/Color_Bash_Prompt
	echo -e "\e[0;36mnode_path.sh -a\e[0;37m"
	echo "To remove path of current Node.js"
	echo -e "\e[0;36mnode_path.sh -r\e[0;37m"
}
# ############### MAIN LOGIC
# get current node.js version
iojsversion=$(node -v)
iojsversion=${iojsversion//v/}

# detech which suitable file to add/update/remove path
if [ -f ~/.bash_profile ]; then
	targetFile=~/.bash_profile  #in Centos
else
	targetFile=~/.profile  #in Ubuntu
fi
profile=`cat $targetFile`
if [ ! -z "$1" ]; then
	case "$1" in
  	-a)
		addupdate_node_path
		echo -e "You need to run \e[0;36msource $targetFile\e[0;37m to update "'$PATH'	
    	;;
  	-r)
		remove_node_path
		echo -e "You need to run \e[0;36msource $targetFile\e[0;37m to update "'$PATH'  	
    	;;
    -h)
		show_help
		;;  
  esac
fi