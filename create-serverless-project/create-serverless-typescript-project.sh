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
serverless create --template aws-nodejs-typescript --path $project_name

cd $project_name

npm install

#plugins to be able to run the serverless offline
serverless plugin install -n serverless-typescript
serverless plugin install -n serverless-offline

cat <<EOF > serverless.ts
import type { AWS } from '@serverless/typescript';

import hello from '@functions/hello';

const serverlessConfiguration: AWS = {
  service: 'test1',
  frameworkVersion: '3',
  plugins: ['serverless-esbuild', 'serverless-offline', 'serverless-typescript'],
  provider: {
    name: 'aws',
    runtime: 'nodejs16.x',
    apiGateway: {
      minimumCompressionSize: 1024,
      shouldStartNameWithService: true,
    },
    environment: {
      AWS_NODEJS_CONNECTION_REUSE_ENABLED: '1',
      NODE_OPTIONS: '--enable-source-maps --stack-trace-limit=1000',
    },
  },
  // import the function via paths
  functions: { hello },
  package: { individually: true },
  custom: {
    esbuild: {
      bundle: true,
      minify: false,
      sourcemap: true,
      exclude: ['aws-sdk'],
      target: 'node16',
      define: { 'require.resolve': undefined },
      platform: 'node',
      concurrency: 10,
    },
  },
};

module.exports = serverlessConfiguration;
EOF
#start the serverless offline for testing purposes
serverless offline