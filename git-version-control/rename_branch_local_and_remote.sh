#!/bin/bash

#Small script to rename a git branch (locally and remotely)

#Start by switching to the local branch which you want to rename:

if [ ! $# -eq 2 ] 
then
  echo "Usage: $0 <old_name> <new_name>"
  exit 1
fi

old_name=$1
new_name=$2

echo "Renaming branch named $old_name to $new_name... Please confirm."
read -p "Do you want to proceed? (yes/no) " yn

case $yn in 
	yes ) echo OK, we will proceed;;
	no ) echo Sure thing, exiting...;
		exit;;
	* ) echo Invalid response;
		exit 1;;
esac

git checkout $old_name

#Rename the local branch by typing:

git branch -m $new_name

: '
At this point, you have renamed the local branch.
If you’ve already pushed the <old_name> branch to the remote repository , perform the next steps to rename the remote branch.
'

#Push the <new_name> local branch and reset the upstream branch:

git push origin -u $new_name

#Delete the <old_name> remote branch:

git push origin --delete $old_name
