#!/usr/bin/env bash

# Fail gracefully
## Exit on error
set -o errexit
## Exit on accessing an unset variable
set -o nounset
## Treat any error in pipe command as failing whole command
set -o pipefail

rm -rf card_images
rm -rf export_images
rm -f tmp.txt

printf "SUCCESS: Removed all export files"