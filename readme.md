**Note**: Does not currently support double-faced cards! Due to limitations of scrycall, DFCs are silently skipped. 

## Dependencies

+ imagemagick
+ ffmpeg
+ rename
+ wget

## Instructions

1. Copy this entire directory to another location on hard drive
2. Add your audio source file with the name `input.mp4a` to the base directory
3. Download card images and convert
    + Pass in your Scryfall search wrapped in double quotes
    + For example `zsh download_images.sh "e=chk c=w"`
4. Move the exported images into the base directory
5. Copy any other images (intro art, tiers, outro art, etc) into the base directory
6. Customize the input file with timestamps:
    1. Get the timestamps from [the show notes](https://docs.google.com/document/d/1orAWZR47FIf75NXiHd4Wd-EaKVp_-poQx1sZIxpmByI/edit#heading=h.s99njdxgxizg)
    2. Copy out just the times into VS Code and add a `00:` to the front of any card without an hour timestamp on it
    3. Take the hours, minutes, and seconds and put them into the appropriate column in this [magic timestamp converter](https://docs.google.com/spreadsheets/d/13-hEGxLZX-VANC69xGFfkhFntnr6zFTx5jh2AEuSBHI/edit#gid=0)
    4. Add rows for intro art and outro art, if needed
7. Feed the various files into `ffmpeg` and let it do its thing:
    + `ffmpeg -f concat -i input.txt -i input.m4a -c:v libx264 -r 1 -pix_fmt yuv420p output.mp4`
    + `concat -i input.txt -i input.m4a` tells ffmpeg to combine two files into one video. `input.txt` is a file that tells ffmpeg how long to display each image.

## Nifty imagemagick tricks

+ You can generate a grid with a transparent background from a collection of images:
    + `montage -density 200 -tile 9x0 -geometry +10+40 -background none *.png grid.png`
    + `-density 200` sets DPI
    + `-tile 8x0` sets an 8 column grid with as many rows as needed to use all images
    + `-geometry +10+40` sets the horizontal offset between elements (`+10`) and the vertical offsets between rows (`+40`)
    + `-background none` forces a transparent background