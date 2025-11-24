#!/bin/bash

# DeelTech Solutions - System Cleanup
# Description: Removes all users listed in faculty_names.txt and deletes the account log.

SCRIPT_DIR="$(dirname "$0")"
# Fix path to be absolute
SCRIPT_DIR="$(cd "$SCRIPT_DIR" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."

NAMES_FILE="$PROJECT_ROOT/faculty_names.txt"
ACCOUNTS_FILE="$PROJECT_ROOT/created_accounts.txt"

echo "----------------------------------------"
echo "[CLEANUP] Removing created users..."

# Check if list exists
if [[ ! -f "$NAMES_FILE" ]]; then
    echo "[WARN] No name list found. Nothing to clean."
    exit 0
fi

# Loop through list and delete users
while read -r first_name last_name; do
    if [[ -n "$first_name" && -n "$last_name" ]]; then
        # Reconstruct Username
        clean_first=$(echo "$first_name" | tr -cd '[:alnum:]')
        clean_last=$(echo "$last_name" | tr -cd '[:alnum:]')
        username=$(echo "${clean_first}.${clean_last}" | tr '[:upper:]' '[:lower:]')

        # Check and Delete
        if id "$username" &>/dev/null; then
            # -r removes the home directory too
            userdel -r "$username"
            echo "[DELETED] $username"
        fi
    fi
done < "$NAMES_FILE"

# Remove the accounts file containing passwords
if [[ -f "$ACCOUNTS_FILE" ]]; then
    rm "$ACCOUNTS_FILE"
    echo "[INFO] Removed sensitive credentials file."
fi

echo "[SUCCESS] System reset complete."
echo "----------------------------------------"