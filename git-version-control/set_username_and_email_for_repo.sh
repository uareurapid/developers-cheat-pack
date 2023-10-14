#!/bin/bash

#set the given username and email for the current repository
#usefull if we want to use multiple git accounts on the same machine, 
#with different users for different repositories (instead of a single/generic configuration for all repositories)

function checkCurrentValues() {

  current_name=`git config user.name`
  current_email=`git config user.email`

  echo "Current config values:"
  echo "Current user.name: $current_name"
  echo "Current user.email: $current_email"
}

if [ ! $# -eq 2 ]
  then
    echo "No arguments supplied! Usage: $0 <user_name> <user_email>"
    exit 1
fi

repo=`pwd`

if [ -d "$repo/.git" ]; then
    echo "github repo found.."
    else
    echo "skipping directory '$repo', '$repo/.git' does not exist, maybe not a valid repository!" 
    exit 1	
fi 

user_name=$1
user_email=$2

#print current configuration
checkCurrentValues


echo "About to set username to '$user_name' and email to '$user_email' on current repository"

#confirm user choice
read -p "Do you want to proceed? (yes/no) " yn

case $yn in 
	yes ) echo OK, we will proceed;;
	no ) echo Sure thing, exiting...;
		exit;;
	* ) echo Invalid response;
		exit 1;;
esac

git config user.name "$user_name"
git config user.email "$user_email"

#re-check config afterwards
checkCurrentValues

cat << EOF

-------------------------------- NOTES -----------------------------------------------
Notes: If you want to use ssh keys edit ssh config file 
This is usually located at your home directoy under => ~/.ssh/config

Add the new configuration for github (assuming the new 'user.name' was 'uareurapid' here)

#~/.ssh/config
################################
#Configure other github account for username -> uareurapid
Host github.com-[uareurapid]
  HostName github.com
  User git
  IdentityFile ~/.ssh/[uareurapid_ssh_public_key].pub
################################

Obs: Replace '[uareurapid]' by your user.name and '[uareurapid_ssh_public_key]' 
by your public ssh key file) on the cofig file above.

Then, when cloning a repo repo like:

git clone git@github.com:someuser/myrepo.git

do instead:

git clone git@github.com-[uareurapid]:someuser/myrepo.git

Again, replacing the '[uareurapid]' with your user.name

----------------------------------------------------------------------------------
EOF