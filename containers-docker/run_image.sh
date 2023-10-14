#!/bin/bash

if [ ! $# -eq 2 ]
  then
    echo "No arguments supplied! Usage: $0 <port:port> <image-tag-name>"
    exit
fi

#for simplicity local and container ports are the same
ports=$1
image_tag=$2

#port and image name
docker run -p $ports -d $image_tag
