#!/bin/bash

#script to create a basic typescrypt project skeleton
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

npm_result=`npm --version`

echo "Checking requirements..."
if [[ $npx_result =~ ^[0-9]+(\.[0-9]+){2,3}$ ]]; 
then
  echo 'node and npm exist, prooceeding...'
else 
  echo "Please install node and npm before using this script!"
  exit 1
fi

mkdir $project_name
cd $project_name

mkdir src
echo "console.log('TODO: CODE ME!')" > src/index.ts

npm init -y
npm install --save-dev typescript @types/node nodemon

cat <<EON >> nodemon.json
{
  "watch": ["src"],
  "ext": ".ts,.js",
  "ignore": [],
  "exec": "npx ts-node ./src/index.ts"
}
EON

#edit the options belllow if needed
cat <<EOT >> tsconfig.json
{
  "compilerOptions": {
    "module": "commonjs",
    "esModuleInterop": true,
    "target": "es6",
    "moduleResolution": "node",
    "sourceMap": true,
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,         
    "noImplicitAny": true,
    "resolveJsonModule": true
    },
    "include": ["src/**/*"],
    "exclude": ["node_modules","src/**/*.spec.ts"]
}
EOT

#some scripts for package.json
npm pkg set 'scripts.clean'='rm -rf ./dist'
npm pkg set 'scripts.dev'='npx nodemon'
npm pkg set 'scripts.build'='npm run clean && tsc'
npm pkg set 'scripts.start'='npm run build && node dist/index.js'

#run to see if it worked
npm run start
#OR npx ts-node src/index.ts
