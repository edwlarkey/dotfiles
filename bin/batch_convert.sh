#!/bin/bash

# This script loops over all files provided as command-line arguments
# and runs the specified convert.sh command on each one.

# Check if at least one file is provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <file1> [file2] ..."
    exit 1
fi

for file in "$@"; do
    echo "Processing $file..."
    /home/edwlarkey/bin/convert.sh av1-inplace -q 120 "$file"
done

echo "All files processed."
