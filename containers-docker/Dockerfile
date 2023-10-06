FROM node:18-alpine

#ENV NODE_ENV production

RUN mkdir -p /usr/src/app && chown node:node /usr/src/app

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY --chown=node:node package*.json ./
COPY --chown=node:node tsconfig.json ./

RUN npm ci

USER node

#RUN npm install
# If you are building your code for production
# RUN npm ci --omit=dev

# Bundle app source
COPY --chown=node:node . .
#run on 3001 -> /frontend
EXPOSE 3000

CMD [ "npm", "start" ]