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
    mkdir images_resized_art
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
    printf "    Downloaded card: $card_image - $card_numbers\n"
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
        printf "    Downloaded art: $art_image - $art_numbers\n"
        let art_count=art_count+1
    }
    # Cleanup temp_art_images.txt and update status
    rm temp_art_images.txt
    printf "SUCCESS: Downloaded all art images\n"

    # Resize all art to consistent size
    # It looks messy, but basically it just reads width and height
    # And then applies appropriate imagemagick syntax based on those
    for input_art in ./images_art/*
    {
        # Create variable to set same filename as source image
        export_art_filename=$(printf "$input_art" | sed 's@./images_art/@@')
        # printf "    $export_filename\n"
        grid_width=$(identify -ping -format '%w' $input_art)
        grid_height=$(identify -ping -format '%h' $input_art)
        if (( $grid_width > 1142 && $grid_height > 920)) ; then
            convert $input_art -geometry 1142x920 images_resized_art/$export_art_filename
        elif (( $grid_width > 1142 )) ; then
            convert $input_art -geometry 1142 images_resized_art/$export_art_filename
        elif (( $grid_height > 920 )) ; then
            convert $input_art -geometry x920 images_resized_art/$export_art_filename
        elif (( $grid_width < 1143 && $grid_height < 921 )) ; then\
            convert $input_art -geometry 1142x920 images_resized_art/$export_art_filename
        fi
        printf "    Resized art $input_art...\n"
    }
elif [[ "$include_card_art" == "N" ]] ; then
    printf "NOTE: Card art is N, skipping download\n"
fi

# Create export images
if [[ "$include_card_art" == "Y" ]] ; then
    printf "Whatevs\n"
elif [[ "$include_card_art" == "N" ]] ; then
    # Loop through images and merge
    for input_image in ./images_card/*
    {
        # Create variable to set same filename as source image
        export_filename=$(printf "$input_image" | sed 's@./images_card/@@')
        # printf "    $export_filename\n"
        magick composite -geometry +1632+200 $input_image resources/card_background.png images_export/$export_filename
        printf "    Converted $input_image...\n"
    }
    # Exports created
    printf "SUCCESS: All export images created\n"
fi

# Create grid image
cd images_card
montage -density 200 -tile $grid_arrangement -geometry +10+40 -background none *.png grid.png
printf "SUCCESS: Card grid created\n"

# Resize grid image conditionally based on size
grid_width=$(identify -ping -format '%w' grid.png)
grid_height=$(identify -ping -format '%h' grid.png)
if (( $grid_width > 2500 && $grid_height > 1400)) ; then
    printf "Wider than 2500 and taller than 1400, converting\n"
    convert grid.png -geometry 2500x1400 grid_resized.png
elif (( $grid_width > 2500 )) ; then
    printf "Wider than 2500, converting\n"
    convert grid.png -geometry 2500 grid_resized.png
elif (( $grid_height > 1400 )) ; then
    printf "Taller than 1400, converting\n"
    convert grid.png -geometry x1400 grid_resized.png
elif (( $grid_width < 2501 && $grid_height < 1401 )) ; then
    printf "Narrower than 2500 and shorter than 1400, converting\n"
    convert grid.png -geometry 2500x1400 grid_resized.png
fi 

# Create composite grid image
cp grid_resized.png ..
cd ..
magick composite -gravity center grid_resized.png resources/title_background.png images_export/grid.png
rm grid_resized.png
printf "SUCCESS: Composite grid created\n"