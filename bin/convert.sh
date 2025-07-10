#!/usr/bin/env bash
# FILENAME="$1"
# ffmpeg -i "$FILENAME" -vcodec libx265 -crf 26 "$HOME/tmp/$FILENAME"
#

# for file in *; do 
#     if [ -f "$file" ]; then 
#         ffmpeg -i "$file" -map 0:v:0 -map 0:a:1 -map 0:a:0 -c copy -disposition:a:0 default "new_$file"
#         mv "new_$file" "$file"
#     fi 
# done


# just convert to av1
#FILENAME="$1"
# ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device /dev/dri/renderD128 -i "$FILENAME" -vf 'format=vaapi,hwupload' -c:v av1_vaapi -q 100 "$FILENAME.av1.mkv"


# convert in place to av1
FILENAME="$1"
ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device /dev/dri/renderD128 -i "$FILENAME" -vf 'format=vaapi,hwupload' -c:v av1_vaapi -q 130 "new_$FILENAME" && mv "new_$FILENAME" "$FILENAME"

# for file in *; do 
#     if [ -f "$file" ]; then 
#         ffmpeg -i "$file" -map 0:v:0 -map 0:a:1 -map 0:a:0 -c copy -disposition:a:0 default "new_$file"
#         mv "new_$file" "$file"
#     fi 
# done

# for file in *; do 
#     if [ -f "$file" ]; then 
#         ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device /dev/dri/renderD128 -i "$file" -vf 'format=vaapi,hwupload' -c:v av1_vaapi -q 100 "new_$file"
#         # mv "new_$file" "$file"
#     fi 
# done
