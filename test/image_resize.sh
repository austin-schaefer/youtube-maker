#!/usr/bin/env bash

# Fail gracefully
## Exit on error
set -o errexit
## Exit on accessing an unset variable
set -o nounset
## Treat any error in pipe command as failing whole command
set -o pipefail

printf "Enter filename (don't include extension): "
read filename_to_convert

# Read images size and then decide
grid_width=$(identify -ping -format '%w' $filename_to_convert.png)
grid_height=$(identify -ping -format '%h' $filename_to_convert.png)
printf "Width: $grid_width\n"
printf "Height: $grid_height\n"

if (( $grid_width > 2500 && $grid_height > 1400)) ; then
    printf "Wider than 2500 and taller than 1400\n"
    convert $filename_to_convert.png -geometry 2500x1400 $filename_to_convert-output.png
elif (( $grid_width > 2500 )) ; then
    printf "Wider than 2500\n"
    convert $filename_to_convert.png -geometry 2500 $filename_to_convert-output.png
elif (( $grid_height > 1400 )) ; then
    printf "Taller than 1400\n"
    convert $filename_to_convert.png -geometry x1400 $filename_to_convert-output.png
elif (( $grid_width < 2501 && $grid_height < 1401 )) ; then
    printf "Narrower than 2500 and shorter than 1400\n"
    convert $filename_to_convert.png -geometry 2500x1400 $filename_to_convert-output.png
fi 

# convert $filename_to_convert -geometry 2500 output.png

# Create grid image
# Works but can be very slow / ineffecient on tall grids in particular
# convert too_tall.png -geometry 2500x1400^ too_tall_inter.png
# convert too_tall_inter.png -geometry 2500x1400 too_tall_final.png
# convert too_long.png -geometry 2500x1400^ too_long_inter.png
# convert too_long_inter.png -geometry 2500x1400 too_long_final.png

# Create composite grid image
# magick composite -gravity center 1400_grid.png resources/title_background.png images_export/grid.png