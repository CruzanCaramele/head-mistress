#!/bin/bash
# this script verifies if a program is valid as is or
# can be found in the PATH directory list.

in_path()
{
	# Given a command and the PATH, tries to find the command.
	# Returns 0 if found and executable; 1 if not. IFS is 
	# temporarily modified (internal fiels seperator)
	cmd=$1	ourpath=$2	result=1
	oldIFS=$IFS  IFS=":"

	for directory in "$ourpath"
	do
		if [ -x $directory/$cmd ] ; then # check if it exists
			result = 0 # if we arrive here, command is found.
		fi
	done

	IFS=$oldIFS
	return $result
}

chkForCmdInPath()
{
	# This function diffrentiates between variables that contain
	# a single command like echo or a full given path such as
	# /bin/echo.

	var=$1

	if [ "$var" != "" ] ; then
		if [ "${var:0:1}" = "/" ] ; then # examine 1st character of variable.
			if [ ! -x "$var" ] ; then  # check if path exists.
				return 1
			fi
		elif ! in_path $var "$PATH" ; then # pass the value to in_path checking default PATH.
			return 2
		fi
	fi
}

if [ $# -ne 1 ] ; then
	echo "Usage: $0 command" >&2
	exit 1
fi

chkForCmdInPath "$1"
case $? in
	0 ) echo "$1 found in PATH"					;;
	1 ) echo "$1 not found or not executable" 	;;
	2 ) echo "$1 not found in PATH"				;;
esac

exit 0