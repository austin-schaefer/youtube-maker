#!/bin/bash

# Requirements:
# All *.jpg files are cards, and all cards are default Scryfall
# Background image is called background.png and is 2560x1440

# Create export directory
mkdir exports

# Loop through images and merge
for i in *.jpg
do
    printf "Converting $i...\n"
    magick composite -geometry +1596+152 $i background.png exports/$i.png
done

# Rename images
printf "Renaming files"
cd exports
rename -v 's/.jpg././' *.png

# Done
printf "All thumbnails created"