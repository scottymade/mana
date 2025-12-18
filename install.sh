#!/bin/bash
# MANA MCP Server Installer
# Downloads and installs the MANA MCP Server binary and instructions for your platform
#
# Usage: curl -fsSL https://raw.githubusercontent.com/scottymade/mana/main/install.sh | bash
set -e

# Configuration
REPO="scottymade/mana"
BINARY_NAME="mana-mcp"
INSTALL_DIR="/usr/local/bin"
INSTRUCTIONS_URL="https://raw.githubusercontent.com/scottymade/mana/main/instructions/CLAUDE_INSTRUCTIONS.md"

echo ""
echo "  __  __    _    _   _    _    "
echo " |  \/  |  / \  | \ | |  / \   "
echo " | |\/| | / _ \ |  \| | / _ \  "
echo " | |  | |/ ___ \| |\  |/ ___ \ "
echo " |_|  |_/_/   \_\_| \_/_/   \_\\"
echo ""
echo " LLM Token Optimizer - Installer"
echo " ================================"
echo ""

# Detect OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$OS" in
  darwin) OS="darwin"; OS_NAME="macOS" ;;
  linux) OS="linux"; OS_NAME="Linux" ;;
  mingw*|msys*|cygwin*) OS="windows"; OS_NAME="Windows" ;;
  *) echo "Error: Unsupported OS: $OS"; exit 1 ;;
esac

# Detect Architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64|amd64) ARCH="x64"; ARCH_NAME="x64" ;;
  arm64|aarch64) ARCH="arm64"; ARCH_NAME="ARM64" ;;
  *) echo "Error: Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Construct filename
if [ "$OS" = "windows" ]; then
  FILENAME="${BINARY_NAME}-${OS}-${ARCH}.exe"
else
  FILENAME="${BINARY_NAME}-${OS}-${ARCH}"
fi

echo "Detected: $OS_NAME $ARCH_NAME"
echo ""

# Get latest release URL
echo "Fetching latest release..."
LATEST_RELEASE=$(curl -sL "https://api.github.com/repos/$REPO/releases/latest" | grep -o "https://github.com/$REPO/releases/download/[^\"]*/$FILENAME" | head -1)

if [ -z "$LATEST_RELEASE" ]; then
  echo "Error: Could not find binary for $OS-$ARCH"
  echo "Please check https://github.com/$REPO/releases for available binaries"
  exit 1
fi

echo "Downloading $FILENAME..."

# Download to temp location
curl -sL "$LATEST_RELEASE" -o "/tmp/$BINARY_NAME"

# Install binary
if [ "$OS" = "windows" ]; then
  mkdir -p "$HOME/.local/bin"
  mv "/tmp/$BINARY_NAME" "$HOME/.local/bin/$BINARY_NAME.exe"
  INSTALLED_PATH="$HOME/.local/bin/$BINARY_NAME.exe"
else
  chmod +x "/tmp/$BINARY_NAME"

  # Try /usr/local/bin first, fall back to ~/.local/bin
  if [ -w "$INSTALL_DIR" ]; then
    mv "/tmp/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"
    INSTALLED_PATH="$INSTALL_DIR/$BINARY_NAME"
  else
    mkdir -p "$HOME/.local/bin"
    mv "/tmp/$BINARY_NAME" "$HOME/.local/bin/$BINARY_NAME"
    INSTALLED_PATH="$HOME/.local/bin/$BINARY_NAME"
  fi
fi

echo "Binary installed: $INSTALLED_PATH"
echo ""

# Detect IDEs and offer to install instructions
echo "----------------------------------------"
echo "Step 2: Install Claude Instructions"
echo "----------------------------------------"
echo ""
echo "MANA needs to teach Claude to use optimized tools."
echo "This requires adding instructions to your IDE's config."
echo ""

CLAUDE_DIR="$HOME/.claude"
CURSOR_DIR="$HOME/.cursor"
WINDSURF_DIR="$HOME/.codeium/windsurf"

FOUND_IDES=""

if [ -d "$CLAUDE_DIR" ]; then
  FOUND_IDES="$FOUND_IDES claude"
  echo "  [1] Claude Code    (~/.claude/)"
fi

if [ -d "$CURSOR_DIR" ]; then
  FOUND_IDES="$FOUND_IDES cursor"
  echo "  [2] Cursor         (~/.cursor/)"
fi

if [ -d "$WINDSURF_DIR" ] || [ -d "$HOME/.windsurf" ]; then
  FOUND_IDES="$FOUND_IDES windsurf"
  echo "  [3] Windsurf       (~/.codeium/windsurf/)"
fi

if [ -z "$FOUND_IDES" ]; then
  echo "  No supported IDEs detected."
  echo ""
  echo "  You can manually install instructions later by running:"
  echo "  curl -fsSL $INSTRUCTIONS_URL >> ~/.claude/CLAUDE.md"
fi

echo ""
echo "  [s] Skip - I'll install instructions manually"
echo "  [a] All detected IDEs"
echo ""

# Check if running interactively
if [ -t 0 ]; then
  read -p "Install instructions for which IDE(s)? [1/2/3/a/s]: " choice
else
  choice="s"
  echo "Non-interactive mode - skipping instructions install."
  echo "Run this script directly (not piped) to install instructions."
fi

install_claude_instructions() {
  echo "Installing Claude Code instructions..."
  if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    # Check if already installed
    if grep -q "MANA Token Optimization" "$CLAUDE_DIR/CLAUDE.md" 2>/dev/null; then
      echo "  Already installed in ~/.claude/CLAUDE.md"
      return
    fi
    echo "" >> "$CLAUDE_DIR/CLAUDE.md"
    curl -sL "$INSTRUCTIONS_URL" >> "$CLAUDE_DIR/CLAUDE.md"
  else
    curl -sL "$INSTRUCTIONS_URL" > "$CLAUDE_DIR/CLAUDE.md"
  fi
  echo "  Installed to ~/.claude/CLAUDE.md"
}

install_cursor_instructions() {
  echo "Installing Cursor instructions..."
  mkdir -p "$CURSOR_DIR/rules"
  if [ -f "$CURSOR_DIR/rules/mana.md" ]; then
    if grep -q "MANA Token Optimization" "$CURSOR_DIR/rules/mana.md" 2>/dev/null; then
      echo "  Already installed in ~/.cursor/rules/mana.md"
      return
    fi
  fi
  curl -sL "$INSTRUCTIONS_URL" > "$CURSOR_DIR/rules/mana.md"
  echo "  Installed to ~/.cursor/rules/mana.md"
}

install_windsurf_instructions() {
  echo "Installing Windsurf instructions..."
  TARGET_DIR="$WINDSURF_DIR"
  [ ! -d "$TARGET_DIR" ] && TARGET_DIR="$HOME/.windsurf"

  if [ -f "$TARGET_DIR/rules.md" ]; then
    if grep -q "MANA Token Optimization" "$TARGET_DIR/rules.md" 2>/dev/null; then
      echo "  Already installed in $TARGET_DIR/rules.md"
      return
    fi
    echo "" >> "$TARGET_DIR/rules.md"
    curl -sL "$INSTRUCTIONS_URL" >> "$TARGET_DIR/rules.md"
  else
    mkdir -p "$TARGET_DIR"
    curl -sL "$INSTRUCTIONS_URL" > "$TARGET_DIR/rules.md"
  fi
  echo "  Installed to $TARGET_DIR/rules.md"
}

case "$choice" in
  1)
    [ -d "$CLAUDE_DIR" ] && install_claude_instructions
    ;;
  2)
    [ -d "$CURSOR_DIR" ] && install_cursor_instructions
    ;;
  3)
    ([ -d "$WINDSURF_DIR" ] || [ -d "$HOME/.windsurf" ]) && install_windsurf_instructions
    ;;
  a|A|all)
    [ -d "$CLAUDE_DIR" ] && install_claude_instructions
    [ -d "$CURSOR_DIR" ] && install_cursor_instructions
    ([ -d "$WINDSURF_DIR" ] || [ -d "$HOME/.windsurf" ]) && install_windsurf_instructions
    ;;
  s|S|skip|"")
    echo "Skipping instructions install."
    ;;
  *)
    echo "Invalid choice. Skipping instructions install."
    ;;
esac

echo ""
echo "========================================"
echo " Installation Complete!"
echo "========================================"
echo ""
echo " Binary: $INSTALLED_PATH"
echo ""
echo " Next steps:"
echo ""
echo " 1. Add your API key to your IDE's MCP config:"
echo ""
echo '    "mcpServers": {'
echo '      "mana": {'
echo "        \"command\": \"$INSTALLED_PATH\","
echo '        "args": ["--api-key=YOUR_API_KEY"]'
echo '      }'
echo '    }'
echo ""
echo " 2. Get your API key at: https://devmana.ai/settings"
echo ""
echo " 3. Restart your IDE"
echo ""
echo " Documentation: https://devmana.ai/docs"
echo ""
