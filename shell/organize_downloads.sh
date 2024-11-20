#!/bin/bash

# Organize Downloads Script
# This script organizes files in your Downloads directory into subfolders by type.

DOWNLOADS_DIR="$HOME/Downloads"
TARGET_DIRS=("Images" "Documents" "Videos" "Music" "Archives" "Others")

# File extensions for each category
declare -A EXTENSIONS
EXTENSIONS=(
    ["Images"]="jpg jpeg png gif bmp svg tiff webp"
    ["Documents"]="pdf doc docx txt odt ppt pptx xls xlsx csv"
    ["Videos"]="mp4 mkv mov avi wmv flv"
    ["Music"]="mp3 wav flac ogg m4a aac"
    ["Archives"]="zip tar gz bz2 rar 7z"
)

# Create target directories if they don't exist
echo "Creating target directories..."
for dir in "${TARGET_DIRS[@]}"; do
    mkdir -p "$DOWNLOADS_DIR/$dir"
done

# Function to move files to appropriate folder
move_files() {
    local category=$1
    local extensions=${EXTENSIONS[$category]}

    for ext in $extensions; do
        find "$DOWNLOADS_DIR" -maxdepth 1 -type f -iname "*.$ext" -exec mv {} "$DOWNLOADS_DIR/$category/" \;
    done
}

# Move files into categorized folders
echo "Organizing files..."
for category in "${!EXTENSIONS[@]}"; do
    move_files "$category"
done

# Move remaining files to "Others"
echo "Moving uncategorized files to 'Others'..."
find "$DOWNLOADS_DIR" -maxdepth 1 -type f -exec mv {} "$DOWNLOADS_DIR/Others/" \;

echo "Cleanup complete! Your Downloads folder is now organized."
