#!/bin/bash

# DeelTech Solutions - Core User Creation Module
# Arguments:
#   $1 = First Name
#   $2 = Last Name

# --- Setup Paths ---
# Use absolute paths relative to this script location
SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$SCRIPT_DIR/.."
ACCOUNTS_FILE="$PROJECT_ROOT/created_accounts.txt"

first_name=$1
last_name=$2

# --- Validation ---
if [[ -z "$first_name" || -z "$last_name" ]]; then
    echo "[ERROR] Create User module requires First and Last name."
    exit 1
fi

# --- Logic ---

# 1. Clean inputs (remove special chars)
clean_first=$(echo "$first_name" | tr -cd '[:alnum:]')
clean_last=$(echo "$last_name" | tr -cd '[:alnum:]')

# [cite_start]2. Generate Username: first.last (lowercase) [cite: 84]
username=$(echo "${clean_first}.${clean_last}" | tr '[:upper:]' '[:lower:]')

# [cite_start]3. Generate Password: firstnamelastnameDEELTECH (lowercase) [cite: 85, 92]
password=$(echo "${clean_first}${clean_last}deeltech" | tr '[:upper:]' '[:lower:]')

# [cite_start]4. Create System Account [cite: 14, 26]
if id "$username" &>/dev/null; then
    echo "[WARN] User '$username' already exists. Skipping."
else
    # Create user with home dir
    useradd -m -s /bin/bash "$username"
    
    # Set the password
    echo "$username:$password" | chpasswd
    
    if [[ $? -eq 0 ]]; then
        echo "[SUCCESS] Created system user: $username"
        
        # 5. Log Credentials to file
        echo "Username: $username | Password: $password" >> "$ACCOUNTS_FILE"
        echo "[INFO] Credentials saved to created_accounts.txt"
    else
        echo "[ERROR] Failed to set password for $username"
    fi
fi