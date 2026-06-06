# vim: set ft=make :

# Interactive picker for ujust recipes
[group("utilities")]
pick:
    #!/usr/bin/env bash
    set -euo pipefail

    REPO="Anakagung2009-bit/AgungOS-ujust-picker"
    DEST="$HOME/.local/bin/ujust-picker"

    # Ensure local bin directory exists
    mkdir -p "$(dirname "$DEST")"

    echo "Checking for latest release from GitHub..."
    API_JSON=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" || true)

    if [[ -z "$API_JSON" ]]; then
        if [[ -f "$DEST" ]]; then
            echo "⚠️  GitHub unreachable. Using existing binary at $DEST"
            clear
            exec "$DEST"
        else
            echo "❌ GitHub unreachable and no local binary found. Falling back to list view."
            just --choose
            exit 0
        fi
    fi

    # Parse latest asset and tag
    ASSET_URL=$(echo "$API_JSON" | jq -r '.assets[] | select(.name | test("x86_64$")) | .browser_download_url')
    TAG_NAME=$(echo "$API_JSON" | jq -r '.tag_name')
    CACHED_TAG_FILE="$DEST.version"

    if [[ -z "$ASSET_URL" ]]; then
        echo "❌ Could not locate x86_64 asset in the latest release."
        exit 1
    fi

    # Check if we already have the latest version
    if [[ -f "$DEST" && -f "$CACHED_TAG_FILE" ]]; then
        CURRENT_TAG=$(<"$CACHED_TAG_FILE")
        if [[ "$CURRENT_TAG" == "$TAG_NAME" ]]; then
            echo "✅ Binary already up to date ($TAG_NAME). Running..."
            clear
            exec "$DEST"
        fi
    fi

    echo "⬇️  Downloading updated binary from release $TAG_NAME"
    curl -L "$ASSET_URL" -o "$DEST"
    chmod +x "$DEST"
    echo "$TAG_NAME" > "$CACHED_TAG_FILE"

    echo "🚀 Running picker..."
    clear
    exec "$DEST"
