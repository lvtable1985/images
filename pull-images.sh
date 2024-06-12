#!/bin/bash

image_list=docker_images.txt

while read image; do

  if [[ -z "$image" ]]; then
    continue
  fi

  if [[ "$image" == //* ]]; then
    continue
  fi

  arch="linux/arm64"
  
  docker pull --platform $arch "$image"

  if [[ $? == 0 ]]; then
    echo "Pull Image SUCCESS: $image arch=$arch"
  else
    echo "Pull Image FAILED: $image arch=$arch"
  fi

done < "$image_list"