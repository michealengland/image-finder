#!/usr/bin/env zsh

set -e  # exit on errors

project_dir="$1"
images_dir="$2"

if [[ -z "$project_dir" || -z "$images_dir" ]]; then
  echo "Usage: ./check-images.sh <project_dir> <images_dir>"
  exit 1
fi

echo ""
echo "🔍 Scanning for images in: $images_dir"
echo "🔍 Searching within project: $project_dir"
echo ""

# Spinner function
spinner() {
  local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  local i=0
  while true; do
    printf "\r%s" "${frames[i]}"
    i=$(( (i+1) % ${#frames[@]} ))
    sleep 0.07
  done
}

# Start spinner in background
spinner &
spinner_pid=$!

# Make sure to stop spinner on exit or interrupt
cleanup() {
  kill "$spinner_pid" 2>/dev/null || true
  wait "$spinner_pid" 2>/dev/null || true
  printf "\r   \r"  # clear spinner line
}
trap cleanup EXIT INT TERM

# Get all directories under images_dir (sorted)
dirs=($(find "$images_dir" -type d | sort))

for dir in $dirs; do
  rel_dir="${dir#$images_dir/}"

  echo "📁 Directory: ${rel_dir:-/}"

  # Get sorted list of image files inside the directory
  images=($(find "$dir" -maxdepth 1 -type f \( \
      -iname "*.png" -o \
      -iname "*.jpg" -o \
      -iname "*.jpeg" -o \
      -iname "*.gif" -o \
      -iname "*.webp" -o \
      -iname "*.svg" \
    \) | sort))

  if [[ ${#images[@]} -eq 0 ]]; then
    echo "  (no images)"
    echo ""
    continue
  fi

  for img in $images; do
    img_name=$(basename "$img")

    # Search for usage
    found_path=$(grep -Rsl -- "$img_name" "$project_dir" | head -n 1)

    if [[ -n "$found_path" ]]; then
      echo "  ✅ $img_name"
      echo "     • image: $img"
      echo "     • used in: $found_path"
    else
      echo "  ❌ $img_name"
      echo "     • image: $img"
      # For images not found, don't display the used-in line
    fi
  done

  echo ""
done

echo "Done."
