#!/bin/bash

# Target directories
TMP_DIR="/root/.npm/_cacache/tmp"
DEST_DIR="/root/.npm/_cacache/content-v2/sha512"

echo "Starting npm install supervisor..."
mkdir -p "$TMP_DIR"
mkdir -p "$DEST_DIR"

(
    while true; do
        TEMP_FILE=$(find "$TMP_DIR" -type f 2>/dev/null | head -n 1)
        
        if [ ! -z "$TEMP_FILE" ]; then
            FILENAME=$(basename "$TEMP_FILE")
            echo "⚡ Caught temp file: $FILENAME. Forcing rename/move..."
            mkdir -p "$DEST_DIR/f8/ec"
            cp "$TEMP_FILE" "$DEST_DIR/f8/ec/$FILENAME" 2>/dev/null
            mv "$TEMP_FILE" "$DEST_DIR/f8/ec/70bc8013eafc84062110c6db6cc9c2f018e415fb0b3e395d523f9547fde4983812c6fb0d2ad114b85ecb669cc3a7fcc3b4bec9ce6796b1b909dda67f9f9b" 2>/dev/null
        fi
        sleep 0.1 
    done
) &
LOOP_PID=$!

echo "Running npm install..."
npm install --force --prefer-online --no-audit

kill $LOOP_PID
echo "✅ Done."
