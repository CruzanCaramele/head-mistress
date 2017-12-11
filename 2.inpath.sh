#!/bin/bash
# this script verifies if a program is valid as is or
# can be found in the PATH directory list.

in_path()
{
	# Given a command and the PATH, tries to find the command.
	# Returns 0 if found and executable; 1 if not. IFS is 
	# temporarily modified (internal field seperator)
	command=$1	
	suppliedpath=$2
	result=1
	oldIFS=$IFS
	IFS=":"

	for path in $suppliedpath
	do
		if [ -x $path/$command ] ; then  # check if command exits and executable
			result=0
			
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

	variable=$1

	if [ "$variable" != " " ] ; then
		if [ "${variable:0:1}" = "/" ] ; then
			if [ ! -x $variable ] ; then
				return 1
			fi
		elif ! in_path $variable "$PATH" ; then
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