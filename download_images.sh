#!/bin/bash

# Create export directories
mkdir card_images
mkdir export_images

# Get list of png files, export to temp file
python3 scry $1 --print="%{image_uris.png}" > tmp.txt
printf "SUCCESS: Got list of card images\n"

# Instantiate variable for card filenames
card_filenames=1

# Download images of all cards
for card_image in "${(@f)"$(<tmp.txt)"}"
{
  sleep 0.1
  wget -q -O ./card_images/$card_filenames.png $card_image
  let card_filenames=card_filenames+1
  printf "    Downloaded $card_image - $card_filenames\n"
}

# Cleanup tmp.txt and update status
rm tmp.txt
printf "SUCCESS: Downloaded all card images\n"

# Loop through images and merge
for input_image in ./card_images/*
do
    printf "$input_image\n"
    export_filename=$(printf "$input_image" | sed 's@./card_images/@@')
    printf "$export_filename\n"
    # magick composite -geometry +1632+200 $input_image background.png export_images/$export_filename.png
    # printf "    Converted $input_image...\n"
done

# Done
printf "SUCCESS: All thumbnails created"