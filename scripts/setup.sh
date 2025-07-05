#!/bin/bash
set -e

# --- Configuration ---
# The base URL for raw file content on GitHub.
BASE_URL="https://raw.githubusercontent.com/n4cl/cursor-rules/main"
PROFILE=$1

# --- Main Logic ---

# Show usage if no profile is specified
if [ -z "$PROFILE" ]; then
  echo "Usage: curl -sSL <script_url> | bash -s {profile_name|clear}"
  echo "Available profiles: dev, blog"
  exit 1
fi

# Create .cursor directory if it doesn't exist
TARGET_DIR=".cursor"
mkdir -p "$TARGET_DIR"

# Handle the 'clear' command
if [ "$PROFILE" = "clear" ]; then
  echo "Clearing existing rules from $TARGET_DIR/..."
  # Remove only the .mdc files to avoid deleting other user files
  find "$TARGET_DIR" -maxdepth 1 -type f -name "*.mdc" -delete
  echo "All rules cleared."
  exit 0
fi

# Define the URL for the profile definition file
PROFILE_URL="$BASE_URL/profiles/${PROFILE}.txt"

# Download the profile definition file
echo "Fetching profile: $PROFILE from $PROFILE_URL"
# Use curl with -f to fail silently on 404 errors, and capture the list
RULE_LIST=$(curl -fsSL "$PROFILE_URL")

if [ -z "$RULE_LIST" ]; then
  echo "Error: Profile '$PROFILE' not found or is empty."
  echo "Please ensure the profile exists and is accessible at $PROFILE_URL"
  exit 1
fi

# First, clear any existing rules to ensure a clean state
echo "Clearing existing rules..."
find "$TARGET_DIR" -maxdepth 1 -type f -name "*.mdc" -delete

# Download each rule file specified in the profile
echo "Setting up profile: $PROFILE"

# Use a while-read loop to handle the downloaded list
while IFS= read -r rule_path; do
  # Skip any empty lines
  if [ -z "$rule_path" ]; then
    continue
  fi

  FILE_URL="$BASE_URL/$rule_path"
  FILE_NAME=$(basename "$rule_path")
  DEST_PATH="$TARGET_DIR/$FILE_NAME"

  echo "  - Downloading $FILE_NAME..."
  curl -fsSL "$FILE_URL" -o "$DEST_PATH"

done <<< "$RULE_LIST" # Here-string to pass the list to the loop

echo "Profile '$PROFILE' set up successfully in $TARGET_DIR/"