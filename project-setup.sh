#!/bin/bash
# ============================================================================
# MANA Project Setup Script
# ============================================================================
#
# This script configures MANA for a single project. It does two things:
#   1. Creates .mcp.json with your API key (MCP server configuration)
#   2. Adds Claude instructions to CLAUDE.md so Claude uses MANA tools
#
# Prerequisites:
#   - MANA must be installed first: npm install -g @scottymade/mana-mcp
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/scottymade/mana/main/project-setup.sh | bash -s -- YOUR_API_KEY
#
# ============================================================================

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

REPO="scottymade/mana"
REPO_RAW_URL="https://raw.githubusercontent.com/$REPO/main"
INSTRUCTIONS_URL="$REPO_RAW_URL/instructions/CLAUDE_INSTRUCTIONS.md"

# ============================================================================
# PARSE AND VALIDATE ARGUMENTS
# ============================================================================

API_KEY="$1"

if [ -z "$API_KEY" ]; then
  echo "Error: API key is required"
  echo ""
  echo "Usage: curl -fsSL https://raw.githubusercontent.com/$REPO/main/project-setup.sh | bash -s -- YOUR_API_KEY"
  echo ""
  echo "Get your API key at https://devmana.ai"
  exit 1
fi

# Validate API key format (soft check - warn but continue)
if [[ ! "$API_KEY" =~ ^sk_mana_ ]]; then
  echo "Warning: API key doesn't match expected format (sk_mana_...)"
  echo "Continuing anyway..."
fi

# ============================================================================
# CHECK PREREQUISITES
# ============================================================================
# Verify mana-mcp is installed via npm

if ! command -v mana-mcp &> /dev/null; then
  echo "Error: mana-mcp not found in PATH"
  echo ""
  echo "Please install MANA first:"
  echo "  npm install -g @scottymade/mana-mcp"
  echo ""
  exit 1
fi

echo "Found mana-mcp at: $(which mana-mcp)"

# ============================================================================
# CHECK FOR EXISTING .mcp.json
# ============================================================================

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
# CREATE .mcp.json
# ============================================================================
# This tells Claude Code how to start the MANA MCP server.
# Since mana-mcp is in PATH (from npm install), we just use the command name.

cat > .mcp.json << EOF
{
  "mcpServers": {
    "mana": {
      "command": "mana-mcp",
      "args": ["--api-key=$API_KEY"]
    }
  }
}
EOF

echo "Created .mcp.json"

# ============================================================================
# INSTALL CLAUDE INSTRUCTIONS (CLAUDE.md at project root)
# ============================================================================
# The instructions teach Claude to use MANA's optimized tools.
# We prepend to existing CLAUDE.md or create new if it doesn't exist.

echo "Installing Claude instructions..."

# Download instructions to temp file
TEMP_INSTRUCTIONS=$(mktemp)
if command -v curl &> /dev/null; then
  curl -fsSL "$INSTRUCTIONS_URL" -o "$TEMP_INSTRUCTIONS"
elif command -v wget &> /dev/null; then
  wget -q "$INSTRUCTIONS_URL" -O "$TEMP_INSTRUCTIONS"
else
  echo "Error: curl or wget required" >&2
  exit 1
fi

CLAUDE_MD="CLAUDE.md"

if [ -f "$CLAUDE_MD" ]; then
  # Check if MANA instructions already present (avoid duplicates)
  if grep -q "MANA Token Optimization" "$CLAUDE_MD"; then
    echo "MANA instructions already in $CLAUDE_MD - skipping"
  else
    # Prepend MANA instructions to existing file
    echo "Prepending MANA instructions to existing $CLAUDE_MD"
    {
      cat "$TEMP_INSTRUCTIONS"
      echo ""
      echo "---"
      echo ""
      cat "$CLAUDE_MD"
    } > "${CLAUDE_MD}.new"
    mv "${CLAUDE_MD}.new" "$CLAUDE_MD"
  fi
else
  # Create new CLAUDE.md
  echo "Creating $CLAUDE_MD"
  cp "$TEMP_INSTRUCTIONS" "$CLAUDE_MD"
fi

rm -f "$TEMP_INSTRUCTIONS"

# ============================================================================
# SUCCESS
# ============================================================================

echo ""
echo "============================================"
echo "  MANA configured for this project!"
echo "============================================"
echo ""
echo "Files created/updated:"
echo "  - .mcp.json (MCP server config)"
echo "  - CLAUDE.md (Claude instructions)"
echo ""
echo "Next steps:"
echo "  1. Add .mcp.json to .gitignore (keeps API key private)"
echo "  2. Restart Claude Code"
echo "  3. Run /mcp to verify MANA is connected"
echo ""
