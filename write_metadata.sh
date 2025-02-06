#!/bin/bash

# Ask the user for a source directory (default: current directory)
read -p "Enter the source folder (default: current directory): " SOURCE_DIR
SOURCE_DIR=${SOURCE_DIR:-"."}  # Use current directory if no input is provided

# Ask the user for an output directory name (default: "Tagged")
read -p "Enter the output folder name (default: Tagged): " OUTPUT_DIR
OUTPUT_DIR=${OUTPUT_DIR:-Tagged}  # Use "Tagged" if no input is provided

# Create the output directory if it does not exist
mkdir -p "$OUTPUT_DIR"

# Look for metadata files with the pattern *.metadata.json in the source directory
METADATA_FILES=$(ls "$SOURCE_DIR"/*.metadata.json 2>/dev/null)

# Check if there are any metadata files
if [ -z "$METADATA_FILES" ]; then
  echo "Error: No metadata files (*.metadata.json) found in $SOURCE_DIR!"
  exit 1
fi

# Process each metadata JSON file
for METADATA_FILE in $METADATA_FILES; do
  echo "Processing metadata file: $METADATA_FILE"

  # Parse JSON and process each entry
  jq -c '.[]' "$METADATA_FILE" | while read -r entry; do
    FILENAME=$(echo "$entry" | jq -r '.filename')
    TITLE=$(echo "$entry" | jq -r '.title')
    DESCRIPTION=$(echo "$entry" | jq -r '.description')
    KEYWORDS=$(echo "$entry" | jq -r '.keywords')

    # Look for the image file in the source directory
    IMAGE_PATH="$SOURCE_DIR/$FILENAME"

    # Check if the image file exists
    if [ ! -f "$IMAGE_PATH" ]; then
      echo "Error: Image file not found: $FILENAME in $SOURCE_DIR"
      continue
    fi

    # Copy the image to the output directory before modifying it
    OUTPUT_IMAGE_PATH="$OUTPUT_DIR/$FILENAME"
    cp "$IMAGE_PATH" "$OUTPUT_IMAGE_PATH"

    # Write metadata using exiftool
    echo "Writing metadata for $FILENAME..."
    exiftool       -XPTitle="$TITLE"       -ImageDescription="$DESCRIPTION"       -XPKeywords="$KEYWORDS"       -overwrite_original       "$OUTPUT_IMAGE_PATH"

    echo "Metadata written for $FILENAME and saved in $OUTPUT_DIR"
  done
done

echo "Metadata writing process completed! Tagged images are in the '$OUTPUT_DIR' folder."
