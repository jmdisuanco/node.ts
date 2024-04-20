#!/bin/bash

download_and_unzip () {
  download_url="https://github.com/jmdisuanco/node.ts/archive/$branch_name.zip"
  archive_filename="node.ts.zip"

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
      echo "cd $unzip_dir"
      echo "nvm use"
      echo "pnpm install or yarn install or pnm install"
    else
      echo "Error unzipping archive."
      exit 1
    fi
  else
    echo "Warning: unzip command not found. Downloaded archive remains in '$archive_filename'."
  fi
}

read -p "Enter the branch name (e.g., main): " branch_name
read -p "Project name: " unzip_dir

  while [[ -z "$branch_name" ]]; do
    read -p "Enter the branch name (e.g., main): " branch_name
  done

    while [[ -z "$unzip_dir" ]]; do
      read -p "Project name:" unzip_dir
    done

# Call the download_and_unzip function with arguments
download_and_unzip "$branch_name" "$unzip_dir"

echo "All done!"