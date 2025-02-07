#!/bin/bash

# Ask the user for a source directory (default: current directory)
read -p "Enter the source folder (default: current directory): " SOURCE_DIR
SOURCE_DIR=${SOURCE_DIR:-"."}  # Use current directory if no input is provided

# Ask the user for an output directory name (default: "Tagged")
read -p "Enter the output folder name (default: Tagged): " OUTPUT_DIR
OUTPUT_DIR=${OUTPUT_DIR:-Tagged}  # Use "Tagged" if no input is provided

# Create the output directory if it does not exist
mkdir -p "$OUTPUT_DIR"

# Create CSV files (Shutterstock and Adobe Stock)
SHUTTERSTOCK_CSV="$OUTPUT_DIR/shutterstock_metadata.csv"
ADOBE_CSV="$OUTPUT_DIR/adobe_stock_metadata.csv"

# Write headers to CSV files
echo "Filename,Title,Description,Keywords,Category" > "$SHUTTERSTOCK_CSV"
echo "Filename,Title,Description,Keywords,Category" > "$ADOBE_CSV"

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
    ADOBE_CATEGORY=$(echo "$entry" | jq -r '.adobeCategory')
    SHUTTERSTOCK_CATEGORY=$(echo "$entry" | jq -r '.shutterStockCategory')

    # Escape double quotes in all fields by replacing " with ""
    ESCAPED_TITLE="\"$(echo $TITLE | sed 's/"/""/g')\""
    ESCAPED_DESCRIPTION="\"$(echo $DESCRIPTION | sed 's/"/""/g')\""
    ESCAPED_KEYWORDS="\"$(echo $KEYWORDS | sed 's/"/""/g')\""
    ESCAPED_ADOBE_CATEGORY="\"$(echo $ADOBE_CATEGORY | sed 's/"/""/g')\""
    ESCAPED_SHUTTERSTOCK_CATEGORY="\"$(echo $SHUTTERSTOCK_CATEGORY | sed 's/"/""/g')\""

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
    exiftool -XPTitle="$TITLE" -ImageDescription="$DESCRIPTION" -XPKeywords="$KEYWORDS" -overwrite_original "$OUTPUT_IMAGE_PATH"

    echo "Metadata written for $FILENAME and saved in $OUTPUT_DIR"

    # Add the metadata to Shutterstock CSV
    echo "$FILENAME,$ESCAPED_TITLE,$ESCAPED_DESCRIPTION,$ESCAPED_KEYWORDS,$ESCAPED_SHUTTERSTOCK_CATEGORY" >> "$SHUTTERSTOCK_CSV"

    # Add the metadata to Adobe Stock CSV
    echo "$FILENAME,$ESCAPED_TITLE,$ESCAPED_DESCRIPTION,$ESCAPED_KEYWORDS,$ESCAPED_ADOBE_CATEGORY" >> "$ADOBE_CSV"

  done
done

echo "Metadata writing process completed! Tagged images are in the '$OUTPUT_DIR' folder."
echo "Shutterstock CSV is saved to '$SHUTTERSTOCK_CSV'."
echo "Adobe Stock CSV is saved to '$ADOBE_CSV'."
