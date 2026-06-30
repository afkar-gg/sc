#!/bin/bash
LOG_FILE="npm_install_error.log"

echo "Starting Log-Parsing npm Cache Fixer..."

while true; do
    echo "Running npm install..."
    
    npm install --force --prefer-online --no-audit 2>&1 | tee "$LOG_FILE"
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo "Success! npm install completed successfully."
        rm -f "$LOG_FILE"
        break
    fi

    if grep -q "ENOENT: no such file or directory, rename" "$LOG_FILE"; then
        echo "Detected cache rename failure. Parsing paths from log..."

        DEST_PATH=$(sed -n "s/.*rename '.*' -> '\([^']*\)'.*/\1/p" "$LOG_FILE" | head -n 1)
        PKG_RAW=$(sed -n "s/.*trying to fetch https:\/\/registry.npmjs.org\/\([^:]*\):.*/\1/p" "$LOG_FILE" | head -n 1)
        PKG_NAME=$(echo "$PKG_RAW" | sed 's/%2[fF]/\//g')

        if [ ! -z "$DEST_PATH" ] && [ ! -z "$PKG_NAME" ]; then
            echo "Broken package identified: $PKG_NAME"
            echo "Target cache path: $DEST_PATH"
            
            echo "Querying npm registry for $PKG_NAME source code..."
            TARBALL_URL=$(npm view "$PKG_NAME" dist.tarball 2>/dev/null)
            
            if [ ! -z "$TARBALL_URL" ]; then
                echo "Pre-filling cache: Downloading tarball directly to target destination..."
                mkdir -p "$(dirname "$DEST_PATH")"
                curl -sL "$TARBALL_URL" -o "$DEST_PATH"
                
                echo "Cache seeded successfully! Restarting install process..."
                echo "--------------------------------------------------------"
            else
                echo "Error: Could not resolve download URL for $PKG_NAME. Aborting to avoid loop."
                break
            fi
        else
            echo "Error: Failed to parse package name or destination path from the error log."
            break
        fi
    else
        echo "npm install failed with a different error. Review the logs above."
        break
    fi
done
