#!/bin/bash
# ============================================================================
# MANA Project Setup Script
# ============================================================================
#
# This script sets up MANA for a single project. It does three things:
#   1. Downloads the MANA MCP server binary (if not already installed)
#   2. Creates .mcp.json with your API key (MCP server configuration)
#   3. Installs Claude instructions (.claude/CLAUDE.md) so Claude uses MANA tools
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/scottymade/mana/main/project-setup.sh | bash -s -- YOUR_API_KEY
#
# Or if you've downloaded the script:
#   ./project-setup.sh YOUR_API_KEY
#
# ============================================================================

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

# GitHub repo for downloading binary and instructions
REPO="scottymade/mana"
REPO_RAW_URL="https://raw.githubusercontent.com/$REPO/main"
REPO_RELEASES_URL="https://github.com/$REPO/releases/latest/download"

# Where to store the binary (shared across all projects)
MANA_DIR="$HOME/.mana"

# Claude instructions file URL
INSTRUCTIONS_URL="$REPO_RAW_URL/instructions/CLAUDE_INSTRUCTIONS.md"

# ============================================================================
# PARSE AND VALIDATE ARGUMENTS
# ============================================================================

API_KEY="$1"

# Check if API key was provided
if [ -z "$API_KEY" ]; then
  echo "Error: API key is required"
  echo ""
  echo "Usage: $0 <api-key>"
  echo ""
  echo "Get your API key at https://devmana.ai/settings"
  exit 1
fi

# Validate API key format (should start with sk_mana_)
# This is a soft check - we warn but continue if format doesn't match
if [[ ! "$API_KEY" =~ ^sk_mana_ ]]; then
  echo "Warning: API key doesn't match expected format (sk_mana_...)"
  echo "Continuing anyway..."
fi

# ============================================================================
# CHECK FOR EXISTING .mcp.json
# ============================================================================
# If .mcp.json already exists, ask user if they want to overwrite it
# This prevents accidental overwrites of existing configurations

if [ -f ".mcp.json" ]; then
  echo "Warning: .mcp.json already exists in this directory"
  read -p "Overwrite? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
  fi
fi

# ============================================================================
# DETECT OS AND ARCHITECTURE
# ============================================================================
# We need to download the correct binary for the user's system
# Supported: macOS (arm64, x64), Linux (x64)

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Normalize architecture names to match our binary naming convention
case "$ARCH" in
  x86_64|amd64) ARCH="x64" ;;
  arm64|aarch64) ARCH="arm64" ;;
esac

# Select the correct binary name based on OS and architecture
case "$OS" in
  darwin) BINARY_NAME="mana-mcp-darwin-$ARCH" ;;
  linux) BINARY_NAME="mana-mcp-linux-x64" ;;
  *)
    echo "Error: Unsupported OS: $OS" >&2
    echo "MANA supports macOS and Linux" >&2
    exit 1
    ;;
esac

BINARY_PATH="$MANA_DIR/$BINARY_NAME"

# ============================================================================
# DOWNLOAD MANA BINARY (if not already present)
# ============================================================================
# The binary is stored in ~/.mana/ and shared across all projects
# This way we only download it once, even if you set up multiple projects

if [ ! -f "$BINARY_PATH" ]; then
  echo "Downloading MANA MCP server..."

  # Create the ~/.mana directory if it doesn't exist
  mkdir -p "$MANA_DIR"

  DOWNLOAD_URL="$REPO_RELEASES_URL/$BINARY_NAME"

  # Download using curl or wget (whichever is available)
  if command -v curl &> /dev/null; then
    curl -fsSL "$DOWNLOAD_URL" -o "$BINARY_PATH"
  elif command -v wget &> /dev/null; then
    wget -q "$DOWNLOAD_URL" -O "$BINARY_PATH"
  else
    echo "Error: curl or wget required to download binary" >&2
    exit 1
  fi

  # Make the binary executable
  chmod +x "$BINARY_PATH"
  echo "Downloaded to $BINARY_PATH"
else
  echo "MANA binary already installed at $BINARY_PATH"
fi

# ============================================================================
# CREATE .mcp.json (MCP Server Configuration)
# ============================================================================
# This file tells Claude Code how to start the MANA MCP server
# It includes the path to the binary and your API key

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

echo "Created .mcp.json"

# ============================================================================
# INSTALL CLAUDE INSTRUCTIONS (.claude/CLAUDE.md)
# ============================================================================
# The instructions file teaches Claude to use MANA's optimized tools instead
# of the native Read, Bash, Search tools. Without this, Claude won't know
# to use MANA and you won't get any token savings.
#
# If .claude/CLAUDE.md already exists, we PREPEND our instructions to it
# (so existing project instructions are preserved)
#
# If it doesn't exist, we create it fresh

echo "Installing Claude instructions..."

# Create .claude directory if it doesn't exist
mkdir -p .claude

# Download the MANA instructions to a temp file
TEMP_INSTRUCTIONS=$(mktemp)
if command -v curl &> /dev/null; then
  curl -fsSL "$INSTRUCTIONS_URL" -o "$TEMP_INSTRUCTIONS"
elif command -v wget &> /dev/null; then
  wget -q "$INSTRUCTIONS_URL" -O "$TEMP_INSTRUCTIONS"
fi

CLAUDE_MD=".claude/CLAUDE.md"

if [ -f "$CLAUDE_MD" ]; then
  # -------------------------------------------------------------------------
  # CASE 1: CLAUDE.md already exists
  # -------------------------------------------------------------------------
  # Check if MANA instructions are already present (to avoid duplicates)
  if grep -q "MANA Token Optimization" "$CLAUDE_MD"; then
    echo "MANA instructions already present in $CLAUDE_MD - skipping"
  else
    # Prepend MANA instructions to existing file
    # We add a separator so it's clear where MANA instructions end
    echo "Prepending MANA instructions to existing $CLAUDE_MD"

    # Create new file with: MANA instructions + separator + original content
    {
      cat "$TEMP_INSTRUCTIONS"
      echo ""
      echo "---"
      echo ""
      echo "# Original Project Instructions"
      echo ""
      cat "$CLAUDE_MD"
    } > "${CLAUDE_MD}.new"

    # Replace original with new file
    mv "${CLAUDE_MD}.new" "$CLAUDE_MD"
  fi
else
  # -------------------------------------------------------------------------
  # CASE 2: CLAUDE.md doesn't exist - create fresh
  # -------------------------------------------------------------------------
  echo "Creating $CLAUDE_MD"
  cp "$TEMP_INSTRUCTIONS" "$CLAUDE_MD"
fi

# Clean up temp file
rm -f "$TEMP_INSTRUCTIONS"

# ============================================================================
# SUCCESS MESSAGE
# ============================================================================

echo ""
echo "============================================"
echo "  MANA configured for this project!"
echo "============================================"
echo ""
echo "Files created:"
echo "  - .mcp.json (MCP server config with API key)"
echo "  - .claude/CLAUDE.md (Claude instructions)"
echo ""
echo "Binary location:"
echo "  - $BINARY_PATH"
echo ""
echo "Next steps:"
echo "  1. Add .mcp.json to .gitignore (keeps API key private)"
echo "  2. Restart Claude Code in this project"
echo "  3. Run /mcp to verify MANA is connected"
echo ""
echo "That's it! Claude will now use MANA's optimized tools."
echo ""
