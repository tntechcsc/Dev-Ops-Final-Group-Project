#!/bin/bash

# DeelTech Solutions - Batch User Processor
# Description: Reads faculty_names.txt and creates accounts for everyone listed.

SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$SCRIPT_DIR/.."
NAMES_FILE="$PROJECT_ROOT/faculty_names.txt"

echo "----------------------------------------"
echo "[INFO] Starting Batch User Creation..."

# Check if the list exists
if [[ ! -f "$NAMES_FILE" ]]; then
    echo "[ERROR] No name list found at $NAMES_FILE"
    echo "Please run the Scraper (Option 1) or Manual Entry (Option 2) first."
    exit 1
fi

# Loop through the file
while read -r first_name last_name; do
    # Only process lines that have both names (skips empty lines)
    if [[ -n "$first_name" && -n "$last_name" ]]; then
        # Call the single user creation script
        bash "$SCRIPT_DIR/create_user.sh" "$first_name" "$last_name"
    fi
done < "$NAMES_FILE"

echo "[SUCCESS] Batch processing complete."
echo "----------------------------------------"