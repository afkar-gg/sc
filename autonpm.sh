#!/bin/bash
LOG_FILE="npm_install_error.log"

# basically this is just an npm install with automation of fixing rename errors and caching issue

echo "Starting Log-Parsing npm Cache Fixer..."

while true; do
    echo "Running npm install..."
    
    npm install --prefer-online --no-audit 2>&1 | tee "$LOG_FILE"
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        echo "Success! npm install completed successfully."
        rm -f "$LOG_FILE"
        break
    fi

    # 1. Detect EINTEGRITY errors
    if grep -qE "code EINTEGRITY|integrity checksum failed" "$LOG_FILE"; then
        echo "Detected EINTEGRITY checksum corruption failure."
        echo "Clearing npm cache and corrupted temporary files..."
        
        # Purge npm cache directory
        npm cache clean --force 2>/dev/null
        rm -rf /tmp/npm-cache/* ~/.npm/_cacache 2>/dev/null
        
        # Extract corrupted package name if present (e.g., strip-json-comments)
        CORRUPTED_PKG=$(grep -oP "trying to fetch https://registry.npmjs.org/\K[^:]+" "$LOG_FILE" | head -n 1)
        if [ -n "$CORRUPTED_PKG" ]; then
            echo "Removing local cache/modules for corrupted package: $CORRUPTED_PKG"
            rm -rf "node_modules/$CORRUPTED_PKG" 2>/dev/null
        fi

        echo "Cache cleared! Retrying install..."
        echo "--------------------------------------------------------"
        continue
    fi

    # 2. Detect ENOENT or ENOTEMPTY rename errors
    if grep -qE "(ENOENT|ENOTEMPTY): directory not empty, rename|syscall rename" "$LOG_FILE"; then
        echo "Detected rename failure (ENOENT/ENOTEMPTY). Parsing paths from log..."

        # Extract source and destination paths from the log
        SRC_PATH=$(sed -n "s/.*rename '\([^']*\)' -> '\([^']*\)'.*/\1/p" "$LOG_FILE" | head -n 1)
        DEST_PATH=$(sed -n "s/.*rename '\([^']*\)' -> '\([^']*\)'.*/\2/p" "$LOG_FILE" | head -n 1)

        # Fallback path extraction via 'path' and 'dest' npm error lines
        if [ -z "$DEST_PATH" ]; then
            DEST_PATH=$(grep "npm ERR! dest " "$LOG_FILE" | awk '{print $4}' | head -n 1)
        fi
        if [ -z "$SRC_PATH" ]; then
            SRC_PATH=$(grep "npm ERR! path " "$LOG_FILE" | awk '{print $4}' | head -n 1)
        fi

        # Check if the error is specifically an ENOTEMPTY on node_modules renames
        if grep -q "ENOTEMPTY" "$LOG_FILE"; then
            echo "Handling ENOTEMPTY error..."
            
            # Remove colliding destination directory if present
            if [ -n "$DEST_PATH" ] && [ -e "$DEST_PATH" ]; then
                echo "Removing conflicting destination folder: $DEST_PATH"
                rm -rf "$DEST_PATH"
            fi

            # Remove colliding source directory if present
            if [ -n "$SRC_PATH" ] && [ -e "$SRC_PATH" ]; then
                echo "Removing conflicting source folder: $SRC_PATH"
                rm -rf "$SRC_PATH"
            fi

            echo "Cleaned up conflicting directory/file. Retrying install..."
            echo "--------------------------------------------------------"
            continue
        fi

        # ENOENT Cache handling logic (Tarball direct download fallback)
        PKG_RAW=$(sed -n "s/.*trying to fetch https:\/\/registry.npmjs.org\/\([^:]*\):.*/\1/p" "$LOG_FILE" | head -n 1)
        if [ -z "$PKG_RAW" ]; then
            PKG_RAW=$(sed -n "s/.*tarball data for \(.*\)@https:\/\/.*/\1/p" "$LOG_FILE" | head -n 1)
        fi
        
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
