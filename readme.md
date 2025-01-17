A collection of scripts to automatically generate YouTube videos for the [Clock Spinning podcast](https://clockspinning.com/). 

## Dependencies

+ imagemagick
+ ffmpeg
+ rename
+ wget

## Instructions

1. Copy this entire directory to another location on hard drive
2. Add your audio source file with the name `input.mp4a` to the base directory
3. Download card images with `zsh download_images.sh`
    + Enter your Scryfall search when prompted
    + Enter a grid arrangement when prompted
3. Ensure any other images you need are in `export_images`
4. Customize the input file with timestamps:
    1. Get the timestamps from the show notes
    2. Copy out just the times into VS Code and add a `00:` to the front of any card without an hour timestamp on it
    3. Take the hours, minutes, and seconds and put them into the appropriate column in this [magic timestamp converter](https://docs.google.com/spreadsheets/d/13-hEGxLZX-VANC69xGFfkhFntnr6zFTx5jh2AEuSBHI/edit#gid=0)
    4. Add rows for intro art and outro art, if needed
    5. Paste the output of that file into `input.txt`
5. Create the video with `zsh create_video.sh`

## Nifty imagemagick tricks

+ You can generate a grid with a transparent background from a collection of images:
    + `montage -density 200 -tile 9x0 -geometry +10+40 -background none *.png grid.png`
    + `-density 200` sets DPI
    + `-tile 8x0` sets an 8 column grid with as many rows as needed to use all images
    + `-geometry +10+40` sets the horizontal offset between elements (`+10`) and the vertical offsets between rows (`+40`)
    + `-background none` forces a transparent background

## ffmpeg notes

+ `concat -i input.txt -i input.m4a` tells ffmpeg to combine two files into one video. `input.txt` is a file that tells ffmpeg how long to display each image.
+ This generates the video: `ffmpeg -f concat -i input.txt -i input.m4a -c:v libx264 -r 1 -pix_fmt yuv420p output.mp4`
+ However, due to the way ffmpeg handles files with low frame rates, this version of the video will be padded with silence at the end.
+ This command trims it to account for transcoding errors: `ffmpeg -i output.mp4 -t $(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.m4a) output_trimmed.mp4`

## Scryfall syntax tips

+ To show cards in order of printing and exclude silly stuff:
    + `prefer:oldest order:released direction:asc (-is:digital -is:funny)`