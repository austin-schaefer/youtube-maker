#!/usr/bin/env bash

# Fail gracefully
## Exit on error
set -o errexit
## Exit on accessing an unset variable
set -o nounset
## Treat any error in pipe command as failing whole command
set -o pipefail

# Create grid image
convert too_tall.png -geometry x1400 1400_grid.png
convert too_tall.png -geometry x1400 1400_grid.png

# Create composite grid image
magick composite -gravity center 1400_grid.png resources/title_background.png images_export/grid.png