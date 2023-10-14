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

mkdir src

#use default settings
npm init --yes

#dotenv and express
npm install express dotenv

#use this file to setup and config any environment variables needed
touch .env
echo "PORT=8000" > .env

#some code for starting the server
#you can further configure src/ folders if you want, etc...
#dev dependencies
npm install --save-dev typescript @types/node @types/express nodemon


touch ./src/index.ts

cat << EOF > ./src/index.ts

import express, { Express, Request, Response } from 'express';
import dotenv from 'dotenv';

dotenv.config();

const app: Express = express();
const port = process.env.PORT;

app.get('/', (req: Request, res: Response) => {
  res.send('Express + TypeScript Server');
});

app.listen(port, () => {
  console.log('[server]: Express Typescript Server is running at http://localhost:' + port);
});

EOF

#configure nodemon
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

