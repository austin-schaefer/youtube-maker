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
printf "Add card art images? Enter Y or N: "
read include_card_art
printf "\n"

# Create export directories and temp directories
mkdir images_card
mkdir images_export
if [[ "$include_card_art" == "Y" ]] ; then
    mkdir images_art
fi

# Get list of card images, export to temp file
python3 scry $scryfall_search --print="%{image_uris.png}" > temp_card_images.txt
printf "SUCCESS: Got list of card images\n"

# Instantiate variable for card filenames
card_count=1

# Download images of all cards
for card_image in "${(@f)"$(<temp_card_images.txt)"}"
{
  sleep 0.11
  printf -v card_numbers "%05d" $card_count
  wget -q -O ./images_card/$card_numbers.png $card_image
  printf "    Downloaded $card_image - $card_numbers\n"
  let card_count=card_count+1
}

# Cleanup temp_card_images.txt and update status
rm temp_card_images.txt
printf "SUCCESS: Downloaded all card images\n"

# Get art using same logic, if user selected
if [[ "$include_card_art" == "Y" ]] ; then
    # Get list of art images, export to temp file
    python3 scry $scryfall_search --print="%{image_uris.art_crop}" > temp_art_images.txt
    printf "SUCCESS: Got list of art images\n"
    
    # Instantiate variable for art filenames
    art_count=1
    
    # Download images of all art
    for art_image in "${(@f)"$(<temp_art_images.txt)"}"
    {
      sleep 0.11
      printf -v art_numbers "%05d" $art_count
      wget -q -O ./images_art/$art_numbers.png $art_image
      printf "    Downloaded $art_image - $art_numbers\n"
      let art_count=art_count+1
    }
    # Cleanup temp_art_images.txt and update status
    rm temp_art_images.txt
    printf "SUCCESS: Downloaded all art images\n"
elif [[ "$include_card_art" == "N" ]] ; then
    printf "NOTE: Card art is N, skipping download\n"
fi

# Loop through images and merge
for input_image in ./images_card/*
do
    # printf "    $input_image\n"
    # Create variable to set same filename as source image
    export_filename=$(printf "$input_image" | sed 's@./images_card/@@')
    # printf "    $export_filename\n"
    magick composite -geometry +1632+200 $input_image resources/card_background.png images_export/$export_filename
    printf "    Converted $input_image...\n"
done

# Thumbnails created
printf "SUCCESS: All thumbnails created\n"

# Create grid image
cd images_card
montage -density 200 -tile $grid_arrangement -geometry +10+40 -background none *.png grid.png
convert grid.png -geometry x1400 1400_grid.png
printf "SUCCESS: Card grids created\n"

# Create composite grid image
cp 1400_grid.png ..
cd ..
magick composite -gravity center 1400_grid.png resources/title_background.png images_export/grid.png
rm 1400_grid.png
printf "SUCCESS: Composite grid created\n"