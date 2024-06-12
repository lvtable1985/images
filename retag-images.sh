#!/bin/bash

image_list=$1
registry=$2

if [[ -z "$image_list" ]]; then
  echo "Usage: retag-images.sh <image_list.txt> <registry>"
  echo >&2 'image_list not specified'
  exit 1
fi

if [[ -z "$registry" ]]; then
  echo "Usage: retag-images.sh <image_list.txt> <registry>"
  echo >&2 'registry not specified'
  exit 1
fi

while read image; do

  if [[ -z "$image" ]]; then
    continue
  fi

  if [[ "$image" == //* ]]; then
    continue
  fi

  docker pull "$image"

  if [[ $? == 0 ]]; then
    echo "Pull Image SUCCESS: $image arch=$arch"
  else
    echo "Pull Image FAILED: $image arch=$arch"
  fi

  new_image="$registry"/library/"$image"
  
  docker tag "$image" "$new_image"
  if [[ $? == 0 ]]; then
    echo "Retag Image SUCCESS: $image => $new_image"
  else
    echo "Retag Image FAILED: $image => $new_image"
    continue
  fi

  docker push "$new_image"
  if [[ $? == 0 ]]; then
    echo "Push Image SUCCESS: $new_image"
  else
    echo "Push Image FAILED: $new_image"
  fi
  
  echo "---------------------------------"
  
done < "$image_list"