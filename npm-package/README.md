# @scottymade/mana-mcp

MANA - LLM Token Usage Optimizer for Claude Code

Optimizes token-heavy tool outputs, saving 50-80% on every operation. Double your Claude Code usage.

## Installation

```bash
npm install -g @scottymade/mana-mcp
```

## Setup

After installing, you need to configure MANA for your project:

### 1. Get Your API Key

Sign up at [devmana.ai](https://devmana.ai) and create an API key.

### 2. Create `.mcp.json` in your project

```json
{
  "mcpServers": {
    "mana": {
      "command": "mana-mcp",
      "args": ["--api-key=YOUR_API_KEY"]
    }
  }
}
```

### 3. Add Claude Instructions

Add the MANA instructions to `.claude/CLAUDE.md` in your project:

```bash
mkdir -p .claude
curl -fsSL https://raw.githubusercontent.com/scottymade/mana/main/instructions/CLAUDE_INSTRUCTIONS.md >> .claude/CLAUDE.md
```

### 4. Restart Claude Code

Run `/mcp` to verify MANA is connected.

## Documentation

Full documentation at [github.com/scottymade/mana](https://github.com/scottymade/mana)

## License

Apache-2.0
