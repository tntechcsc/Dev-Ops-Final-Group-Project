#!/bin/bash

# DeelTech Solutions – Core User Creation Module (Phase 3)
# Arguments:
#   $1 = First Name
#   $2 = Last Name

# --- Setup Paths ---
SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$SCRIPT_DIR/.."
ACCOUNTS_FILE="$PROJECT_ROOT/created_accounts.txt"

first_name="$1"
last_name="$2"

# --- Validation ---
if [[ -z "$first_name" || -z "$last_name" ]]; then
    echo "[ERROR] Create User module requires first and last name."
    echo "Usage: $0 <FirstName> <LastName>"
    exit 1
fi

# --- Password Generator ---
generate_password() {
    # 12-character random password using letters and numbers only
    tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 12
}

# 1. Clean inputs (remove special chars)
clean_first=$(echo "$first_name" | tr -cd '[:alnum:]')
clean_last=$(echo "$last_name" | tr -cd '[:alnum:]')

# 2. Generate username: first.last (lowercase)
username=$(echo "${clean_first}.${clean_last}" | tr '[:upper:]' '[:lower:]')

# 3. Generate RANDOM 12-character password
password="$(generate_password)"

# 4. Create System Account
if id "$username" &>/dev/null; then
    echo "[WARN] User '$username' already exists. Skipping."
else
    # Create user with home directory and bash shell
    if useradd -m -s /bin/bash -c "${first_name} ${last_name}" "$username"; then

        # Set the password
        echo "${username}:${password}" | chpasswd

        if [[ $? -eq 0 ]]; then
            echo "[SUCCESS] Created system user: $username"

            # 5. Log credentials to file
            # If file doesn't exist yet, add a header row
            if [[ ! -f "$ACCOUNTS_FILE" ]]; then
                echo "Username | Password" > "$ACCOUNTS_FILE"
            fi

            echo "Username: ${username} | Password: ${password}" >> "$ACCOUNTS_FILE"
            echo "[INFO] Credentials saved to $(basename "$ACCOUNTS_FILE")"
        else
            echo "[ERROR] Failed to set password for $username"
        fi
    else
        echo "[ERROR] Failed to create system user '$username'"
    fi
fi
