#!/bin/bash

# Directory containing JPEG images
IMAGE_DIR="./images"

# Path to the JSON file
METADATA_FILE="./metadata.json"

# Check if files exist
if [ ! -d "$IMAGE_DIR" ]; then
  echo "Error: Image directory not found!"
  exit 1
fi

if [ ! -f "$METADATA_FILE" ]; then
  echo "Error: Metadata file not found!"
  exit 1
fi

# Parse JSON and process each entry
jq -c '.[]' "$METADATA_FILE" | while read -r entry; do
  FILENAME=$(echo "$entry" | jq -r '.filename')
  TITLE=$(echo "$entry" | jq -r '.title')
  DESCRIPTION=$(echo "$entry" | jq -r '.description')
  KEYWORDS=$(echo "$entry" | jq -r '.keywords')

  IMAGE_PATH="$IMAGE_DIR/$FILENAME"

  # Check if the image file exists
  if [ ! -f "$IMAGE_PATH" ]; then
    echo "Error: Image file not found: $FILENAME"
    continue
  fi

  # Write metadata using exiftool
  echo "Writing metadata for $FILENAME..."
  exiftool \
    -XPTitle="$TITLE" \
    -ImageDescription="$DESCRIPTION" \
    -XPKeywords="$KEYWORDS" \
    -overwrite_original \
    "$IMAGE_PATH"

  echo "Metadata written for $FILENAME"
done

echo "Metadata writing process completed!"
