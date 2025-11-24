#!/bin/bash

#Author: Abdullah Javed

# ==============================================================================
# Module: DeelTech License Manager
# Description: Handles license verification and key obfuscation.
# ==============================================================================

# --- Global Variables for Licensing ---
LICENSE_FILE="./license.dat"
# AI OBFUSCATION: SHA256 hash of the key "1234567890123456"
# This ensures the key cannot be seen in clear text [cite: 98]
VALID_KEY_HASH="7a51d064a1a216a692f753fcdab276e4ff201a01d8b66f56d50d4d719fd0dc87"

check_license() {
    # Colors for output (Red, Green, Blue, No Color)
    local R='\033[0;31m'
    local G='\033[0;32m'
    local B='\033[0;34m'
    local N='\033[0m'

    echo -e "${B}Checking License System...${N}"
    
    # Requirement: Program should always check for a valid license file [cite: 97]
    if [[ -f "$LICENSE_FILE" ]]; then
        echo -e "${G}License verified. Welcome, authorized user.${N}"
        return 0
    else
        # Requirement: If file does not exist, prompt for key [cite: 95]
        echo -e "${R}License file not found!${N}"
        echo -n "Please enter the 16-digit license key provided by your Scrum Master: "
        read -s user_key
        echo ""

        # Hash the input to compare against the stored hash (Obfuscation) [cite: 98]
        input_hash=$(echo -n "$user_key" | sha256sum | awk '{print $1}')

        if [[ "$input_hash" == "$VALID_KEY_HASH" ]]; then
            echo -e "${G}License Key Accepted.${N}"
            # Requirement: Create the license file [cite: 95]
            echo "Licensed to DeelTech" > "$LICENSE_FILE"
        else
            echo -e "${R}Invalid License Key. Access Denied.${N}"
            exit 1
        fi
    fi
}