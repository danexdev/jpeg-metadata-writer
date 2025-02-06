
# JPEG Metadata Writer

Automate the process of writing metadata (title, description, and keywords) into JPEG images using a Bash script and JSON metadata. This tool is designed for batch processing and simplifies embedding EXIF metadata into images.

## Features

- Reads metadata from a JSON file.
- Writes `title`, `description`, and `keywords` into EXIF metadata fields of JPEG files.
- Supports batch processing for multiple images.
- Allows selecting a **source folder** for images and metadata JSON files (default: current directory).
- Allows specifying an **output folder** for tagged images (default: `Tagged`).
- Copies images to the output folder before modifying metadata.
- Overwrites original files in the output directory (can be customized to keep backups).

## Prerequisites

Before using the script, ensure the following tools are installed on your macOS or Linux system:

1. **exiftool**: For writing metadata into JPEG files.
   ```bash
   brew install exiftool
   ```

2. **jq**: For parsing JSON files.
   ```bash
   brew install jq
   ```

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/danexdev/jpeg-metadata-writer.git
   cd jpeg-metadata-writer
   ```

2. Place your JPEG files and metadata JSON files in the **source folder** (default: current directory).

3. Ensure the metadata JSON files match the following format.

## JSON Metadata Format

The JSON file should have an array of objects, with each object containing:

- `filename`: Name of the image file (must match the file in the source folder).
- `title`: The title of the image.
- `description`: A detailed description of the image.
- `keywords`: A comma-separated list of keywords for the image.

**Example:**
```json
[
  {
    "filename": "20221223_111456.jpg",
    "title": "Snow-Covered Forest with Bright Sunlight and Mountain View",
    "description": "A stunning winter scene featuring a snow-covered forest under a bright blue sky, illuminated by sunlight with a view of distant mountains and a serene valley.",
    "keywords": "snow-covered forest, winter sunlight, blue sky, serene valley, distant mountains, winter landscape, frosty surroundings"
  },
  {
    "filename": "20221224_115516.jpg",
    "title": "Horses Feeding at Snow-Covered Shelter in Winter Forest",
    "description": "A peaceful scene of horses feeding at a snow-covered wooden shelter, surrounded by a winter forest and illuminated by soft sunlight under a clear sky.",
    "keywords": "horses feeding, snow-covered shelter, winter forest, tranquil scene, soft sunlight, serene nature"
  }
]
```

## Usage

1. Make the script executable:
   ```bash
   chmod +x write_metadata.sh
   ```

2. Run the script:
   ```bash
   ./write_metadata.sh
   ```

3. The script will:
   - Ask for the **source folder** (default: current directory).
   - Ask for the **output folder** (default: `Tagged`).
   - Read metadata from JSON files (`*.metadata.json`).
   - Match each `filename` in the JSON with the corresponding image in the source folder.
   - Copy the image to the output folder before applying metadata.
   - Write metadata into the copied JPEG files.

## Output

For each image processed, the script will output:
```
Enter the source folder (default: current directory):
Enter the output folder name (default: Tagged):

Processing metadata file: example.metadata.json
Writing metadata for 20221223_111456.jpg...
    1 image files updated
Metadata written for 20221223_111456.jpg and saved in Tagged
Writing metadata for 20221224_115516.jpg...
    1 image files updated
Metadata written for 20221224_115516.jpg and saved in Tagged

Metadata writing process completed! Tagged images are in the 'Tagged' folder.
```

## Directory Structure

```
jpeg-metadata-writer/
├── images/               # Optional: Directory containing source JPEG images (can be any folder)
├── metadata.json         # JSON file with metadata (or multiple *.metadata.json files)
├── write_metadata.sh     # Bash script for writing metadata
├── README.md             # Project documentation
```

## Customization

- Modify the `SOURCE_DIR` and `OUTPUT_DIR` in the script for default directory changes.
- To keep backups of the original images in the output folder, remove the `-overwrite_original` option in the script.

## License

This project is licensed under the MIT License. Feel free to use and modify it as needed.

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests for enhancements and bug fixes.

---

Happy coding! 🚀
