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

mkdir -p "$project_name"

cd "$project_name"

#use default settings
npm init --yes

#dotenv and express
npm install express dotenv

#use this file to setup and config any environment variables needed
touch .env
echo "PORT=8000" > .env

touch index.js

#some code for starting the server
#you can further configure src/ folders if you want, etc...
cat <<EOF > index.js

const express = require('express');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const port = process.env.PORT || 8000;

app.get('/', (req, res) => {
  res.send('Express + Javascript Server');
});

app.listen(port, () => {
  console.log('[server]: Express Javascript Server is running at http://localhost:' + port);
});
EOF

#some scripts for package.json
npm pkg set 'scripts.clean'='rm -rf ./build'
#npm pkg set 'scripts.dev'='npx nodemon'
#if you want to use nodemon add it it above on 'npm install' section and uncomment the line above
npm pkg set 'scripts.build'='npm run clean'
npm pkg set 'scripts.start'='npm run build && node index.js'

#run to see if it worked
npm run start
#OR npx ts-node src/index.ts