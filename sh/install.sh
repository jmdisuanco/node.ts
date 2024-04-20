#!/bin/bash

# Function to download and unzip archive
download_and_unzip () {
  branch_name="$1"  # Capture the branch name argument
  unzip_dir="${2:-my_project}"  # Capture the optional unzip directory argument (defaulting to 'my_project' if not provided)

  # Download URL (replace with actual URL format, including branch name)
  download_url="https://github.com/jmdisuanco/node.ts/archive/$branch_name.zip"

  # Archive filename (replace with actual filename, including extension)
  archive_filename="node.ts.zip"

  # **WARNING** Downloading and executing scripts from untrusted sources can be dangerous.
  # Please review the contents of this script (download_and_unzip.sh) before running it.

  # Try downloading with curl (if available)
  if command -v curl &> /dev/null; then
    echo "Downloading archive for branch '$branch_name' with curl..."
    curl -sSL "$download_url" -o "$archive_filename"
    download_result=$?
  else
    # If curl fails, try wget (if available)
    if command -v wget &> /dev/null; then
      echo "curl not found, trying wget..."
      wget "$download_url" -O "$archive_filename"
      download_result=$?
    else
      # Exit if both curl and wget are unavailable
      echo "Error: Neither curl nor wget is installed. Please install one of them."
      exit 1
    fi
  fi

  # Check if download was successful (either curl or wget)
  if [ $download_result -eq 0 ]; then
    echo "Download complete!"
  else
    echo "Error downloading archive. Please check the URL."
    exit 1
  fi

  # Unzip the archive (assuming unzip is available)
  if command -v unzip &> /dev/null; then
    echo "Unzipping archive..."
    unzip  "$archive_filename" -d "tmp"
    unzip_result=$?

    # Check if unzip was successful
    if [ $unzip_result -eq 0 ]; then
      mkdir $unzip_dir
      mv ./tmp/*/* $unzip_dir/.
      rm -rf $unzip_dir/sh
      rm -rf tmp
      rm -rf $archive_filename
      echo "Unzip successful! The template files for branch '$branch_name' are in the '$unzip_dir' directory."
    else
      echo "Error unzipping archive."
      exit 1
    fi
  else
    echo "Warning: unzip command not found. Downloaded archive remains in '$archive_filename'."
  fi
}

# Script usage message (if no arguments provided)
if [ $# -lt 1 ]; then
  echo "Usage: $0 <branch_name> [unzip_dir]"
  echo "  <branch_name>: The name of the branch to download (e.g., main, develop)"
  echo "  [unzip_dir]: (Optional) The directory name for unzipped files (defaults to 'my_template')"
  exit 1
fi

# Call the download_and_unzip function with arguments
download_and_unzip "$1" "$2"

echo "All done!"