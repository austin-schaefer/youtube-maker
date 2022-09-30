#!/bin/bash

# Create export directory
# mkdir card_images

# Get list of png files
python3 scry $1 --print="%{image_uris.png}" > tmp.txt

# Instantiate filename variable
filenames=1

# The loop
for image in "${(@f)"$(<tmp.txt)"}"
{
  printf "Downloading $image - $filenames \n"
  wget -O $filenames.png $image
  sleep 0.1
  let filenames=filenames+1
}

rm tmp.txt