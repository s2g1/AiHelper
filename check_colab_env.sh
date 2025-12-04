#!/bin/bash

# ===============================
# Colab Environment Setup Script
# ===============================

# --- 1. Mount Google Drive ---
if [ ! -d "/content/drive" ]; then
    echo "Mounting Google Drive..."
    python3 - <<END
from google.colab import drive
drive.mount('/content/drive')
END
fi

# --- 2. Clone GitHub repo if not present ---
REPO_DIR="/content/my-colab-scripts"
REPO_URL="https://github.com/username/my-colab-scripts.git"

if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning repository..."
    git clone "$REPO_URL" "$REPO_DIR"
else
    echo "Repository already exists. Pulling latest changes..."
    cd "$REPO_DIR"
    git pull
    cd -
fi

# --- 3. Run repo script to check environment ---
if [ -f "$REPO_DIR/check_env.sh" ]; then
    echo "Running environment check script from repo..."
    bash "$REPO_DIR/check_env.sh"
else
    echo "No check_env.sh found in repo. Skipping..."
fi

# --- 4. Check and set GPT API key ---
if [ -z "$GPT_API_KEY" ]; then
    echo "GPT_API_KEY not found in environment. Loading from Drive..."
    if [ -f "/content/drive/MyDrive/keys/gpt_api_key.txt" ]; then
        export GPT_API_KEY=$(cat /content/drive/MyDrive/keys/gpt_api_key.txt)
        echo "GPT_API_KEY set."
    else
        echo "GPT API key file not found in Drive!"
    fi
else
    echo "GPT_API_KEY already exists."
fi

# --- 5. Set up terminal aliases ---
ALIASES_FILE="$REPO_DIR/colab_aliases.sh"

if [ -f "$ALIASES_FILE" ]; then
    echo "Loading aliases..."
    source "$ALIASES_FILE"
else
    echo "Creating default aliases..."
    # Example aliases
    alias ll='ls -la'
    alias gs='git status'
fi

echo "Environment setup complete!"
