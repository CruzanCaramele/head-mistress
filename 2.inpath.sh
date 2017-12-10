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
		if [ -x $directory/$cmd] then
			result = 0 # if we arrive here, command is found.
		fi
	done

	IFS=$oldIFS
	return $result
}