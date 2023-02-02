#!/usr/bin/env bash

# Fail gracefully
## Exit on error
set -o errexit
## Exit on accessing an unset variable
set -o nounset
## Treat any error in pipe command as failing whole command
set -o pipefail

# Prompt for user input
printf "Enter Scryfall search query: "
read scryfall_search
printf "Enter grid arrangement (e.g. 8x0, 9x0, etc.): "
read grid_arrangement

# Create export directories and temp directories
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
    magick composite -geometry +1632+200 $input_image resources/card_background.png export_images/$export_filename
    printf "    Converted $input_image...\n"
done

# Thumbnails created
printf "SUCCESS: All thumbnails created\n"

# Create grid image
cd card_images
montage -density 200 -tile $grid_arrangement -geometry +10+40 -background none *.png grid.png
convert grid.png -geometry x1400 1400_grid.png
printf "SUCCESS: Card grids created\n"

# Create composite grid image
cp 1400_grid.png ..
cd ..
magick composite -gravity center 1400_grid.png resources/title_background.png export_images/grid.png
rm 1400_grid.png
printf "SUCCESS: Composite grid created\n"

# Generate video
ffmpeg -f concat -i input.txt -i input.m4a -c:v libx264 -r 1 -pix_fmt yuv420p output.mp4
printf "SUCCESS: Created initial video"
ffmpeg -i output.mp4 -t $(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.m4a) output_trimmed.mp4
printf "SUCCESS: Created trimmed video"