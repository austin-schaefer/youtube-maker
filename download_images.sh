#!/bin/bash

# Create export directory
mkdir card_images

# Get list of png files
python3 scry $1 --print="%{image_uris.png}" > tmp.txt

# Instantiate filename variable
filenames=1

# The loop
for card_image in "${(@f)"$(<tmp.txt)"}"
{
  printf "Downloading $card_image - $filenames \n"
  sleep 0.1
  wget -q -O ./card_images/$filenames.png $card_image
  let filenames=filenames+1
}

rm tmp.txt

printf "Finished downloading images"