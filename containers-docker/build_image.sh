#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied! Usage: $0 <image-tag-name>"
    exit
fi
image_tag=$1

docker build . -t $image_tag
