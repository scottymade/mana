# @scottymade/mana

MANA - LLM Token Usage Optimizer for Claude Code

Optimizes token-heavy tool outputs, saving 50-80% on every operation. Double your Claude Code usage.

## Quick Start

### Step 1: Install MANA

```bash
npm install -g @scottymade/mana
```

Get your API key at [devmana.ai](https://devmana.ai) → **Settings** → **API Keys**

### Step 2: Add MCP Server

**2a. Project only** (run from your project root):

```bash
claude mcp add -s project mana -- mana --api-key=YOUR_API_KEY
```

**2b. Global** (run from anywhere, applies to all projects):

```bash
claude mcp add -s user mana -- mana --api-key=YOUR_API_KEY
```

### Step 3: Add Claude Instructions

**3a. Project only** (run from your project root):

```bash
{ curl -fsSL https://raw.githubusercontent.com/scottymade/mana/main/instructions/CLAUDE_INSTRUCTIONS.md; echo ""; echo "---"; echo ""; cat CLAUDE.md 2>/dev/null; } > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
```

**3b. Global** (run from anywhere, applies to all projects):

```bash
{ curl -fsSL https://raw.githubusercontent.com/scottymade/mana/main/instructions/CLAUDE_INSTRUCTIONS.md; echo ""; echo "---"; echo ""; cat ~/.claude/CLAUDE.md 2>/dev/null; } > ~/.claude/CLAUDE.md.tmp && mv ~/.claude/CLAUDE.md.tmp ~/.claude/CLAUDE.md
```

### Step 4: Restart Claude Code

Run `/mcp` to verify MANA is connected.

## Documentation

Full documentation at [github.com/scottymade/mana](https://github.com/scottymade/mana)

## License

Apache-2.0
