#!/bin/bash

printf "Enter Scryfall search query: "
read scryfall_search
printf "Enter grid arrangement (e.g. 8x0, 9x0, etc.): "
read grid_arrangement

# Create export directories
mkdir card_images
mkdir export_images

# Get list of png files, export to temp file
python3 scry $scryfall_search --print="%{image_uris.png}" > tmp.txt
printf "SUCCESS: Got list of card images\n"

# Instantiate variable for card filenames
count=1

# Download images of all cards
for card_image in "${(@f)"$(<tmp.txt)"}"
{
  sleep 0.11
  printf -v card_numbers "%05d" $count
  wget -q -O ./card_images/$card_numbers.png $card_image
  printf "    Downloaded $card_image - $card_numbers\n"
  let count=count+1
}

# Cleanup tmp.txt and update status
rm tmp.txt
printf "SUCCESS: Downloaded all card images\n"

# Loop through images and merge
for input_image in ./card_images/*
do
    # printf "    $input_image\n"
    # Create variable to set same filename as source image
    export_filename=$(printf "$input_image" | sed 's@./card_images/@@')
    # printf "    $export_filename\n"
    magick composite -geometry +1632+200 $input_image card_background.png export_images/$export_filename
    printf "    Converted $input_image...\n"
done

# Thumbnails created
printf "SUCCESS: All thumbnails created\n"

# Create grid image
cd card_images
montage -density 200 -tile $grid_arrangement -geometry +10+40 -background none *.png grid.png
printf "SUCCESS: Card grid created\n"