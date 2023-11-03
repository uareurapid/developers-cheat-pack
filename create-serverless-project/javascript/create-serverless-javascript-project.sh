#/bin/bash

# Notes if you don't have AWS client installed, please visit the following link
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

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

# after installing the aws client proceed bellow

echo "Checking installation of aws client..."
AWS_CLI=`aws --version`
STR='aws-cli'
if [[ "$AWS_CLI" == *"$STR"* ]]; then
  echo "It's there."
else
  echo "It's not there."
  echo "Please make sure you have the aws client client installed before proceeding with the setup"
  echo "If you don't have AWS client installed, please visit the following link bellow:"
  echo "https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"

  read -p "Do you want to continue? (yes/no) " yn

  case $yn in 
    yes ) echo OK, we will proceed;;
    no ) echo Sure thing, exiting...;
      exit;;
    * ) echo Invalid response;
      exit 1;;
  esac
fi

mkdir -p "$project_name"

cd "$project_name"

aws configure

#https://blog.logrocket.com/building-serverless-app-typescript/

echo "Checking installation of serverless globally..."
SERVERLESS=`sls --version`
STR1='Framework Core'
if [[ "$SERVERLESS" == *"$STR1"* ]]; then
  echo "It's there."
else
  echo "It's not there. Installing it..."
  # Install serverless package globally
  npm install -g serverless
fi

echo "Checking serverless version..."
sls --version

#Initialize a new serverless project, with the same name of the folder
serverless create --template aws-nodejs --path $project_name

cd $project_name

#npm install

npm install @serverless/sdk

#plugins to be able to run the serverless offline
npm install serverless-offline --save-dev

#Notes: see typescript example for another way to configure the serverless
cat <<EOF > serverless.yml
#set your service name here
service: my-service  
provider:   
  name: aws   
  runtime: nodejs18.x  
functions:
  hello:
    handler: handler.hello
    events:
      - http:
          path: hello/get
          method: get
#plugin definition to run it offline
plugins:
  - serverless-offline
EOF

cat <<EOH > handler.js
// handler.js
module.exports.hello = (event, context, callback) => {
  const response = { statusCode: 200, body: 'Hello Serverless!' };
  callback(null, response);
};
EOH
#start the serverless offline for testing purposes
serverless offline start