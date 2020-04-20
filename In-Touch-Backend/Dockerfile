FROM node:13

RUN mkdir -p /usr/src/intouchbackend
WORKDIR /usr/src/intouchbackend

# copying all the files from your file system to container file system
COPY package.json yarn.lock ./

# install all dependencies
RUN yarn install

# copy oter files as well
COPY . ./

# expose the port
EXPOSE 3000

# command to run when intantiate an image
CMD ["yarn","start"]
