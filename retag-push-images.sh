#!/bin/bash

registry=$1

if [[ -z "$registry" ]]; then
  echo "Usage: retag-push-images.sh <registry>"
  echo >&2 'registry not specified'
  exit 1
fi


image_list=docker_images.txt

while read image; do

  if [[ -z "$image" ]]; then
    continue
  fi

  if [[ "$image" == //* ]]; then
    continue
  fi

  new_image="$registry"/library/"$image"
  
  docker tag "$image" "$new_image"
  if [[ $? == 0 ]]; then
    echo "Retag Image SUCCESS: $image"
  else
    echo "Retag Image FAILED: $image"
    continue
  fi

  docker push "$new_image"
  if [[ $? == 0 ]]; then
    echo "Push Image SUCCESS: $new_image"
  else
    echo "Push Image FAILED: $new_image"
  fi
  
done < "$image_list"