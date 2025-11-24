#!/bin/bash

# DeelTech Solutions
# Author: Andrew Sullivan
# Date: 2025-11-22

URL="https://www.tntech.edu/engineering/programs/csc/faculty-and-staff.php"
OUTPUT="faculty_raw.html"
NAMES_FILE="faculty_names.txt"

echo "[INFO] Downloading faculty page…"
curl -s "$URL" -o "$OUTPUT"

echo "[INFO] Parsing names…"

grep -oP '<h[34][^>]*>.*?</h[34]>' "$OUTPUT" \
    | sed -E 's/<[^>]+>//g' \
    | sed -E 's/&nbsp;//g' \
    | sed -E 's/Dr\. |Prof\. |Professor |Mr\. |Ms\. |Mrs\. //g; s/, Ph\.D\.//g; s/, PhD//g' \
    | grep -v -E 'Professors|Lecturers|Faculty|Adjunct|Staff|Associate|Senior|Assistant' \
    | awk 'NF >= 2 {print $1, $NF}' \
    > "$NAMES_FILE"

echo "[INFO] Done. Parsed names saved to $NAMES_FILE"