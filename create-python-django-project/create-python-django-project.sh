#/bin/bash

# Notes if you don't have python installed, please visit the following link
# https://www.python.org/downloads/

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


echo "Checking installation of python..."
PYTHON=`python --version`
#use 'python' instead of 'python3'
USE_PYTHON="yes"
STR='Python'
if [[ "$PYTHON" == *"$STR"* ]]; then
  echo "It's there."
else
  echo "It's not there. Checking 'python3' instead..."
  PYTHON3=`python3 --version`
  if [[ "$PYTHON3" == *"$STR"* ]]; then
    echo "It's there."
    USE_PYTHON="no"
  else

  echo "Please make sure you have python v3 (or above) and pip installed before proceeding with the setup"
  echo "If you don't have them installed, please visit the following link bellow:"
  echo "https://www.python.org/downloads/"

  read -p "Do you want to continue? (yes/no) " yn

   case $yn in 
     yes ) echo OK, we will proceed;;
     no ) echo Sure thing, exiting...;
      exit;;
     * ) echo Invalid response;
      exit 1;;
   esac
  fi
fi

# after installing the pip installer proceed bellow

echo "Checking installation of pip (python package manager)..."
PIP=`pip --version`
STR='python'
if [[ "$PIP" == *"$STR"* ]]; then
  echo "It's there."
else
  echo "It's not there."
  echo "Please make sure you have python v3 (or above) and pip installed before proceeding with the setup"
  echo "If you don't have them installed, please visit the following link bellow:"
  echo "https://www.python.org/downloads/"

  read -p "Do you want to continue? (yes/no) " yn

  case $yn in 
    yes ) echo OK, we will proceed;;
    no ) echo Sure thing, exiting...;
      exit;;
    * ) echo Invalid response;
      exit 1;;
  esac
fi

echo "Checking installation of django admin globally..."
DJANGO_ADMIN=`django-admin --version`
STR1='django'
#ouput is 3.2.12
if [[ "$DJANGO_ADMIN" == *"$STR1"* ]]; then
  echo "It's there."
else
  echo "It's not there. Installing it..."
  # Install serverless package globally
  sudo apt install python3-django
fi

echo "Checking django-admin version..."
django-admin --version

django-admin startproject $project_name

cd $project_name

echo "Checking the project configuration and starting the server..."

if [[ "$USE_PYTHON" == "yes" ]]; then
   python manage.py runserver
else
   python3 manage.py runserver
fi