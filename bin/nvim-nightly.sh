#!/bin/zsh

set -e

# Test for required directories
if [ ! -d "$HOME/tmp" ]; then
  echo "Error: Directory ~/tmp does not exist." >&2
  exit 1
fi
if [ ! -d "$HOME/bin" ]; then
  echo "Error: Directory ~/bin does not exist." >&2
  exit 1
fi

OS=$(uname -s)

PKG_NAME=""
EXTRACTED_DIR=""
IS_MACOS=false

if [ "$OS" = "Darwin" ]; then
  IS_MACOS=true
  # The nightly release seems to have a universal binary now.
  PKG_NAME="nvim-macos-arm64.tar.gz"
  EXTRACTED_DIR="nvim-macos"
elif [ "$OS" = "Linux" ]; then
  # Using the name provided by the user.
  PKG_NAME="nvim-linux-x86_64.tar.gz"
  EXTRACTED_DIR="nvim-linux-x86_64"
else
  echo "Unsupported OS: $OS"
  exit 1
fi

echo "Detected $OS. Downloading $PKG_NAME..."
DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/nightly/$PKG_NAME"
ARCHIVE_PATH="$HOME/tmp/$PKG_NAME"
TMP_DIR="$HOME/tmp"
BIN_DIR="$HOME/bin"

# Download
curl -L -o "$ARCHIVE_PATH" "$DOWNLOAD_URL"

# macOS specific step from original script
if [ "$IS_MACOS" = true ]; then
  echo "Removing extended attributes..."
  xattr -c "$ARCHIVE_PATH"
fi

# Extract
echo "Extracting archive to $TMP_DIR..."
# Remove existing extracted dir to avoid issues
if [ -d "$TMP_DIR/$EXTRACTED_DIR" ]; then
    echo "Removing existing directory $TMP_DIR/$EXTRACTED_DIR"
    rm -rf "$TMP_DIR/$EXTRACTED_DIR"
fi
tar xzvf "$ARCHIVE_PATH" -C "$TMP_DIR"

# Verify
echo "Verifying nvim version..."
"$TMP_DIR/$EXTRACTED_DIR/bin/nvim" --version

# Symlink, as in original script
echo "Creating symlink in $BIN_DIR..."
ln -nsf "$TMP_DIR/$EXTRACTED_DIR/bin/nvim" "$BIN_DIR/nvim"

# Cleanup archive file, as in original script
echo "Cleaning up archive file..."
rm "$ARCHIVE_PATH"

echo "Neovim nightly setup complete. 'nvim' is available at $BIN_DIR/nvim"
echo "Make sure $BIN_DIR is in your PATH."
