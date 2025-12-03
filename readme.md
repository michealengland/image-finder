# Image Finder

A simple Zsh script to check if images in a project’s assets directory are being used anywhere in the project.
It scans all subdirectories of your images folder and reports for each image whether it is used, along with the file(s) where it is referenced.

---

## Features

- Recursively scans all images in the images directory and subdirectories
- Checks for image usage across the entire project
- Outputs results alphabetically by folder and filename
- Shows image path and location(s) where it is used
- Indicates unused images clearly
- Handles nested directories and spaces in filenames
- Interrupt-safe (stops cleanly on Ctrl+C)

---

## Requirements

- Zsh
- `grep` and `find` available in your environment

---

## Installation

Make the script executable:

```bash
chmod +x check-images.sh

## Usage

```bash
./check-images.sh /path/to/project /path/to/project/images
```

- /path/to/project – The root directory of your project to search
- /path/to/project/images – The images (assets) directory to check

---

## Example Output

```bash
🔍 Scanning for images in: ./assets/images
🔍 Searching within project: ./my-project

📁 Directory: icons
  ✅ arrow.svg
     • image: ./assets/images/icons/arrow.svg
     • used in: ./my-project/components/button.html
  ❌ unused-icon.png
     • image: ./assets/images/icons/unused-icon.png

📁 Directory: banners
  ✅ hero.jpg
     • image: ./assets/images/banners/hero.jpg
     • used in: ./my-project/index.html

Done.
```

---

## Notes:

1. Images are checked in alphabetical order per folder and filename.
2. The script will exit immediately if interrupted (Ctrl+C).
3. Only literal filename matches are detected; it does not detect hashed filenames automatically.
