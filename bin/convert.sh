#!/usr/bin/env bash
# FILENAME="$1"
# ffmpeg -i "$FILENAME" -vcodec libx265 -crf 26 "$HOME/tmp/$FILENAME"
#

for file in *; do 
    if [ -f "$file" ]; then 
        ffmpeg -i "$file" -map 0:v:0 -map 0:a:1 -map 0:a:0 -c copy -disposition:a:0 default "new_$file"
        mv "new_$file" "$file"
    fi 
done
