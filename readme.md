## Dependencies

+ imagemagick
+ ffmpeg
+ rename
+ wget
+ scrycall
    + python executable for scryfall queries
    + put the executable in the directory
    + need to run with python3 b/c macOS sucks
    + https://github.com/austin-schaefer/scrycall
    + make sure to add it to your path; e.g. `export PATH=/Users/austin/dev/scrycall/scrycall:$PATH`

# Instructions

1. Copy this entire directory to another location on hard drive
2. Add your audio source file with the name XYZ.ABC
3. Download card images
    + Pass in your scryfall search wrapped in double quotes
    + For example `download_images.sh "e=chk c=w"`
4. Overlay card images on background
    + Background must be
5. Generate video

+ Download card images: 
    + Python tool: https://github.com/NandaScott/Scrython 
    + Download all images firefox extension
        + can rename sequentially from some option
        + remember to include .jpg file extension
+ resize card images
    + magick mogrify -resize 167% *.jpg
+ overlay images
    + X: 1632
    + Y: 200