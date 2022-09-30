#!/bin/bash

# Create export directory
mkdir export_images

# Instantiate export_filenames variable
export_filenames=1

# Loop through images and merge
for input_image in ./card_images/*.png
do
    printf "Converting $input_image...\n"
    magick composite -geometry +1632+200 $input_image background.png export_images/$export_filenames.png
    let export_filenames=export_filenames+1
done

# Done
printf "All thumbnails created"