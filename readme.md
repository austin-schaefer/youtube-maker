**Note**: Does not currently support double-faced cards! Due to limitations of scrycall, DFCs are silently skipped. 

## Dependencies

+ imagemagick
+ ffmpeg
+ rename
+ wget

# Instructions

1. Copy this entire directory to another location on hard drive
2. Add your audio source file with the name XYZ.ABC
3. Download card images and convert
    + Pass in your scryfall search wrapped in double quotes
    + For example `download_images.sh "e=chk c=w"`
4. Generate video