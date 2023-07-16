#!/usr/bin/env bash

# Fail gracefully
## Exit on error
set -o errexit
## Exit on accessing an unset variable
set -o nounset
## Treat any error in pipe command as failing whole command
set -o pipefail

# Create grid image
# Works but can be very slow / ineffecient on tall grids in particular
# convert too_tall.png -geometry 2500x1400^ too_tall_inter.png
# convert too_tall_inter.png -geometry 2500x1400 too_tall_final.png
# convert too_long.png -geometry 2500x1400^ too_long_inter.png
# convert too_long_inter.png -geometry 2500x1400 too_long_final.png

# Create composite grid image
# magick composite -gravity center 1400_grid.png resources/title_background.png images_export/grid.png