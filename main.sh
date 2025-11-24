#!/bin/bash

SCRIPT_DIR="$(dirname "$0")/scripts"

# --- Imports ---
# This pulls the code from the separate license file
if [[ -f "$SCRIPT_DIR/license_module.sh" ]]; then
    source "$SCRIPT_DIR/license_module.sh"
else
    echo "Error: license_module.sh not found."
    exit 1
fi

# DeelTech Solutions - Main Program Interface
check_license
DEFAULT_CHOICE=1

while true; do
    echo "=============================================="
    echo "     DEELTECH FACULTY ONBOARDING PROGRAM      "
    echo "=============================================="
    echo "1) Run Web Scraper & Name Parser (DEFAULT)"
    echo "2) Manually Add User"
    echo "3) Create Faculty User Accounts"
    echo "4) Delete Existing Users"
    echo "5) Exit"
    echo

    read -p "Enter choice [1-5] (press ENTER for default): " choice
    choice=${choice:-$DEFAULT_CHOICE}

    case $choice in
        1)
            echo "[INFO] Running scraper..."
            bash "$SCRIPT_DIR/scraper.sh"
            ;;
        2) 
            echo "[INFO] Starting manual entry..."
            bash "$SCRIPT_DIR/manual_entry.sh"
            ;;
        3)
            # This is the specific "option there to create user from list"
            echo "[INFO] Processing existing list..."
            bash "$SCRIPT_DIR/batch_process.sh"
            ;;
        4)
            echo "[INFO] Erasing all Users"
            bash "$SCRIPT_DIR/cleanup.sh"
            ;;
        5)
            echo "[INFO] Exiting program"
            exit 0
            ;;
        *)
            echo "[ERROR] Invalid choice."
            ;;
    esac
    echo ""
    read -p "Press Enter to continue..."
    # clear # Uncomment this line if you want the screen to wipe clean every time
done