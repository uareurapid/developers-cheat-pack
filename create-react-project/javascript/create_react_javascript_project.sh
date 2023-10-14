#!/bin/bash

#script to create a basic react (using typescrypt) project skeleton
#mandatory args: the folder/project name

if [ $# -eq 0 ]
  then
    echo "No arguments supplied! Usage: $0 project_name"
    exit
fi
project_name=$1

if [ -d "$project_name" ]
  then
    echo "Error! Directory: $project_name already exists!"
    exit
fi

#mkdir $project_name
#cd $project_name

#first make sure we have npx installed
npx_result=`npx --version`
#check if is a version number?

echo "Checking requirements..."
if [[ $npx_result =~ ^[0-9]+(\.[0-9]+){2,3}$ ]]; 
then
  echo 'node, npm and npx cli exist, prooceeding...'
else 
  echo "Please install node and npm before using this script!"
  exit 1
fi

npx create-react-app@latest $project_name

cd $project_name


#run to see if it worked
npm run start

