#!/bin/bash

#Small script to update "git pull" all repos inside a main folder

##Option 1
## declare an array variable with the repo folder names
: 'declare -a arr=(
"repo1"
"repo2"
)
'

## then loop through the above array like:
#for i in "${arr[@]}"

#Option 2, just look for any git repo like folders

for repo in $(ls); do
  if [[ -d "$repo" ]]; then
    if [ -d "$repo/.git" ]; then
    	echo "github repo found.."
      	echo "Getting updates for repo '$repo'"
      	cd $repo
      	pwd
      	git pull
      	#go back
     	cd ..
    else
       echo "skipping directory '$repo', '$repo/.git' does not exist, maybe not a valid repository!" 	
    fi 
  fi
done

