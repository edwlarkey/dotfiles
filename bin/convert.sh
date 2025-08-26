#!/usr/bin/env bash

# Video conversion utility with various ffmpeg operations
# Usage: convert.sh <command> [options] [files...]

set -e

# Default settings
DEFAULT_H265_CRF=26
DEFAULT_AV1_QUALITY=100
VAAPI_DEVICE="/dev/dri/renderD128"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_usage() {
    cat << EOF
Usage: convert.sh <command> [options] [files...]

Commands:
    h265 <file>                    Convert single file to H.265
    av1 <file>                     Convert single file to AV1
    av1-batch                      Convert all files in current directory to AV1
    av1-inplace <file>             Convert file to AV1 in place
    reorder-audio                  Reorder audio tracks for all files in current directory

Options:
    -q, --quality <value>          Set quality (default: h265=26, av1=100)
    -o, --output <dir>             Output directory (for single file operations)
    -h, --help                     Show this help message

Examples:
    convert.sh h265 video.mp4
    convert.sh av1 video.mp4 -q 100
    convert.sh av1-batch -q 80
    convert.sh av1-inplace video.mp4 -q 120
    convert.sh reorder-audio
EOF
}

print_error() {
    echo -e "${RED}Error:${NC} $1" >&2
}

print_success() {
    echo -e "${GREEN}Success:${NC} $1"
}

print_info() {
    echo -e "${YELLOW}Info:${NC} $1"
}

# Check if ffmpeg is available
check_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        print_error "ffmpeg is not installed or not in PATH"
        exit 1
    fi
}

# Check if ffprobe is available
check_ffprobe() {
    if ! command -v ffprobe &> /dev/null; then
        print_error "ffprobe is not installed or not in PATH"
        exit 1
    fi
}

# Check if video is already in AV1 format
is_av1() {
    local file="$1"
    local codec
    
    codec=$(ffprobe -v quiet -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$file" 2>/dev/null)
    
    if [ "$codec" = "av1" ]; then
        return 0  # True - is AV1
    else
        return 1  # False - not AV1
    fi
}

# Check if VAAPI is available
check_vaapi() {
    if [ ! -e "$VAAPI_DEVICE" ]; then
        print_error "VAAPI device not found at $VAAPI_DEVICE"
        print_info "Hardware acceleration may not work"
    fi
}

# Convert single file to H.265
convert_h265() {
    local file="$1"
    local quality="${2:-$DEFAULT_H265_CRF}"
    local output_dir="$3"
    
    if [ ! -f "$file" ]; then
        print_error "File not found: $file"
        exit 1
    fi
    
    local output_file
    if [ -n "$output_dir" ]; then
        mkdir -p "$output_dir"
        output_file="$output_dir/$file"
    else
        output_file="$HOME/tmp/$file"
        mkdir -p "$HOME/tmp"
    fi
    
    print_info "Converting $file to H.265 with CRF $quality..."
    ffmpeg -i "$file" -vcodec libx265 -crf "$quality" "$output_file"
    print_success "Converted to $output_file"
}

# Convert single file to AV1
convert_av1() {
    local file="$1"
    local quality="${2:-$DEFAULT_AV1_QUALITY}"
    local output_dir="$3"
    
    if [ ! -f "$file" ]; then
        print_error "File not found: $file"
        exit 1
    fi
    
    # Check if already AV1
    if is_av1 "$file"; then
        print_info "Skipping $file - already in AV1 format"
        return 0
    fi
    
    local output_file
    if [ -n "$output_dir" ]; then
        mkdir -p "$output_dir"
        output_file="$output_dir/$file.av1.mkv"
    else
        output_file="$file.av1.mkv"
    fi
    
    print_info "Converting $file to AV1 with quality $quality..."
    ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device "$VAAPI_DEVICE" \
           -i "$file" -vf 'format=vaapi,hwupload' -c:v av1_vaapi -q "$quality" "$output_file"
    print_success "Converted to $output_file"
}

# Convert file to AV1 in place
convert_av1_inplace() {
    local file="$1"
    local quality="${2:-$DEFAULT_AV1_QUALITY}"
    
    if [ ! -f "$file" ]; then
        print_error "File not found: $file"
        exit 1
    fi
    
    # Check if already AV1
    if is_av1 "$file"; then
        print_info "Skipping $file - already in AV1 format"
        return 0
    fi
    
    print_info "Converting $file to AV1 in place with quality $quality..."
    ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device "$VAAPI_DEVICE" \
           -i "$file" -vf 'format=vaapi,hwupload' -c:v av1_vaapi -q "$quality" "new_$file" \
           && mv "new_$file" "$file"
    print_success "Converted $file in place"
}

# Convert all files in current directory to AV1
convert_av1_batch() {
    local quality="${1:-$DEFAULT_AV1_QUALITY}"
    
    print_info "Converting all files in current directory to AV1 with quality $quality..."
    
    for file in *; do 
        if [ -f "$file" ]; then 
            # Check if already AV1
            if is_av1 "$file"; then
                print_info "Skipping $file - already in AV1 format"
                continue
            fi
            
            print_info "Converting $file..."
            ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device "$VAAPI_DEVICE" \
                   -i "$file" -vf 'format=vaapi,hwupload' -c:v av1_vaapi -q "$quality" "new_$file"
            # Note: Not moving files in place for safety
            print_success "Converted $file to new_$file"
        fi 
    done
}

# Reorder audio tracks for all files
reorder_audio() {
    print_info "Reordering audio tracks for all files in current directory..."
    
    for file in *; do 
        if [ -f "$file" ]; then 
            print_info "Processing $file..."
            ffmpeg -i "$file" -map 0:v:0 -map 0:a:1 -map 0:a:0 -c copy \
                   -disposition:a:0 default "new_$file"
            mv "new_$file" "$file"
            print_success "Reordered audio tracks for $file"
        fi 
    done
}

# Parse command line arguments
parse_args() {
    local command=""
    local quality=""
    local output_dir=""
    local files=()
    
    # Parse options
    local temp
    temp=$(getopt -o q:o:h --long quality:,output:,help -n 'convert.sh' -- "$@")
    if [ $? != 0 ]; then
        print_error "Failed to parse arguments"
        print_usage
        exit 1
    fi
    
    eval set -- "$temp"
    
    while true; do
        case "$1" in
            -q|--quality)
                quality="$2"
                shift 2
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -h|--help)
                print_usage
                exit 0
                ;;
            --)
                shift
                break
                ;;
            *)
                print_error "Internal error in argument parsing"
                exit 1
                ;;
        esac
    done
    
    # Get command and files from remaining arguments
    if [ $# -eq 0 ]; then
        print_error "No command specified"
        print_usage
        exit 1
    fi
    
    command="$1"
    shift
    
    # Collect remaining arguments as files
    while [ $# -gt 0 ]; do
        files+=("$1")
        shift
    done
    
    # Execute command
    case "$command" in
        h265)
            if [ ${#files[@]} -eq 0 ]; then
                print_error "No file specified for h265 conversion"
                exit 1
            fi
            convert_h265 "${files[0]}" "$quality" "$output_dir"
            ;;
        av1)
            if [ ${#files[@]} -eq 0 ]; then
                print_error "No file specified for av1 conversion"
                exit 1
            fi
            convert_av1 "${files[0]}" "$quality" "$output_dir"
            ;;
        av1-batch)
            # Use quality if set, otherwise default
            if [ -z "$quality" ]; then
                quality="$DEFAULT_AV1_QUALITY"
            fi
            convert_av1_batch "$quality"
            ;;
        av1-inplace)
            if [ ${#files[@]} -eq 0 ]; then
                print_error "No file specified for av1 in-place conversion"
                exit 1
            fi
            # Use quality if set, otherwise default
            if [ -z "$quality" ]; then
                quality="$DEFAULT_AV1_QUALITY"
            fi
            convert_av1_inplace "${files[0]}" "$quality"
            ;;
        reorder-audio)
            reorder_audio
            ;;
        *)
            print_error "Unknown command: $command"
            print_usage
            exit 1
            ;;
    esac
}

# Main execution
main() {
    check_ffmpeg
    check_ffprobe
    check_vaapi
    parse_args "$@"
}

# Run main function with all arguments
main "$@"
