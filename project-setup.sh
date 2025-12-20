#!/bin/bash
# MANA Project Setup Script
# Creates .mcp.json in the current directory to enable MANA for this project
#
# Usage: curl -fsSL https://raw.githubusercontent.com/scottymade/mana/main/project-setup.sh | bash -s -- YOUR_API_KEY
#    or: ./project-setup.sh YOUR_API_KEY

set -e

API_KEY="$1"

if [ -z "$API_KEY" ]; then
  echo "Error: API key is required"
  echo ""
  echo "Usage: $0 <api-key>"
  echo ""
  echo "Get your API key at https://devmana.ai/settings"
  exit 1
fi

# Validate API key format (should start with sk_mana_)
if [[ ! "$API_KEY" =~ ^sk_mana_ ]]; then
  echo "Warning: API key doesn't match expected format (sk_mana_...)"
  echo "Continuing anyway..."
fi

# Check if .mcp.json already exists
if [ -f ".mcp.json" ]; then
  echo "Warning: .mcp.json already exists in this directory"
  read -p "Overwrite? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
  fi
fi

# Detect binary path based on OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64|amd64) ARCH="x64" ;;
  arm64|aarch64) ARCH="arm64" ;;
esac

case "$OS" in
  darwin) BINARY_NAME="mana-mcp-darwin-$ARCH" ;;
  linux) BINARY_NAME="mana-mcp-linux-x64" ;;
  *) echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

# Binary location (download if not present)
MANA_DIR="$HOME/.mana"
BINARY_PATH="$MANA_DIR/$BINARY_NAME"

if [ ! -f "$BINARY_PATH" ]; then
  echo "Downloading MANA MCP server..."
  mkdir -p "$MANA_DIR"

  DOWNLOAD_URL="https://github.com/scottymade/mana/releases/latest/download/$BINARY_NAME"

  if command -v curl &> /dev/null; then
    curl -fsSL "$DOWNLOAD_URL" -o "$BINARY_PATH"
  elif command -v wget &> /dev/null; then
    wget -q "$DOWNLOAD_URL" -O "$BINARY_PATH"
  else
    echo "Error: curl or wget required to download binary" >&2
    exit 1
  fi

  chmod +x "$BINARY_PATH"
  echo "Downloaded to $BINARY_PATH"
fi

# Create .mcp.json
cat > .mcp.json << EOF
{
  "mcpServers": {
    "mana": {
      "command": "$BINARY_PATH",
      "args": ["--api-key=$API_KEY"]
    }
  }
}
EOF

echo ""
echo "✓ MANA configured for this project!"
echo ""
echo "Created: .mcp.json"
echo "Binary:  $BINARY_PATH"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code in this project"
echo "  2. Run /mcp to verify MANA is connected"
echo ""
echo "Note: Add .mcp.json to .gitignore to keep your API key private"
