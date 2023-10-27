#!/bin/bash

#Small script to rename a git branch (locally and remotely)

#Start by switching to the local branch which you want to rename:

if [ ! $# -eq 1 ] 
then
  echo "Usage: $0 <branch_name>"
  exit 1
fi

branch_name=$1
current_branch=`git branch --show-current`

echo "current branch $current_branch"

if [ "$current_branch" == "$branch_name" ] 
then
  echo "Current branch $current_branch is the same as the branch to delete $branch_name, automatically changing to another branch..."
  #will try to switch to main or master first cause usually one of these exist and they are not meant to be deleted anyway
  other_branches=`git branch --list`
  echo "Listing existing branches: $other_branches"
  if [[ "$other_branches" == *"main"* ]] 
    then
      echo "Will switch to branch: 'main' first"
      git checkout main
  elif [[ "$other_branches" == *"master"* ]] 
    then
      echo "Will switch to branch: 'master' first"
      git checkout master
  else 
    echo "Unable to switch automatically, please do it manually"
  fi  


fi
   

#delete branch locally
echo "Deleting branch $branch_name locally & remotely... Please confirm."
read -p "Do you want to proceed? (yes/no) " yn

case $yn in 
	yes ) echo OK, we will proceed;;
	no ) echo Sure thing, exiting...;
		exit;;
	* ) echo Invalid response;
		exit 1;;
esac


git branch -D $branch_name
: '
If using <git branch -D localBranchName> The -d option will delete the branch only if it has already 
been pushed and merged with the remote branch. 
Use -D instead if you want to force the branch to be deleted, even if it has not been pushed or merged yet.
'

#delete branch remotely
git push origin --delete $branch_name


