#!/usr/bin/env bash

# Fail gracefully
## Exit on error
set -o errexit
## Exit on accessing an unset variable
set -o nounset
## Treat any error in pipe command as failing whole command
set -o pipefail

rm -rf images_card
rm -rf images_art
rm -rf images_export
rm -f tmp.txt

printf "SUCCESS: Removed all export files"