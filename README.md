<p align="center">
  <img src="docs/mana-promo.png" alt="Mana - Double Your Claude Code Usage for 1/3 the Price" width="800">
</p>

<p align="center">
  <a href="https://github.com/scottymade/mana/releases">
    <img src="https://img.shields.io/github/v/release/scottymade/mana" alt="Version">
  </a>
  <a href="https://www.npmjs.com/package/@scottymade/mana">
    <img src="https://img.shields.io/npm/v/@scottymade/mana" alt="npm">
  </a>
  <a href="https://github.com/scottymade/mana/releases">
    <img src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg" alt="Platforms">
  </a>
  <a href="https://devmana.ai">
    <img src="https://img.shields.io/badge/Claude%20Code-MCP%20Server-purple.svg" alt="Claude Code MCP Server">
  </a>
  <a href="https://github.com/scottymade/mana/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/scottymade/mana" alt="License">
  </a>
</p>

---

MANA optimizes the token-heavy tool outputs that eat through your Claude limits. File reads, command outputs, search results - they all get intelligently routed and compressed before reaching Claude, saving 50-80% of tokens on every operation. Keeping your context lean and keeping you coding longer without hitting usage caps!

**Result: 2x the coding sessions with no change to your workflow.**

---

## Your Mana Bar Has a Hole In It

*Debuff effect: Token bleed on every tool call. Here's how it stacks:*

### File Operations Are Mana Vampires

Claude Code reads an entire component file. 2,847 lines. Only 40 were relevant to your query. That's 2,800+ wasted tokens per file op. One trash mob just ate your spell slots.

### Bash Commands Siphon Mana on Every Cast

You run `npm run test`. Claude gets back 5,000 tokens - suite names, timing breakdowns, coverage reports. You just needed to know: is the build alive? Mana bar blinked red for a pulse check.

### Directory Searches Burn Through Reserves

Claude casts Locate Object to find a file. Miss. Recasts with new keywords. Miss. Third cast, broader search. Nothing batched. That's 3x the tokens for one file path.

### It's a Wipe. Pull the Combat Log — Here's What Killed You.

| 50-80% | 6-12h | 2-3x |
|--------|-------|------|
| of tokens go to tool bloat - not your actual work | actual grinding (from 25h) | faster bleed in large codebases |

**You're not bad at token management. The trash mobs wiped your mana before you even reached the boss.**

---

## How It Works

**What If You Had a Mana Regen Buff Running 24/7?**

**_That's Mana._**

We route Claude tool calls through our custom MCP server. When Claude Code reads a 3,000-line file, Mana intercepts the bloated response, routes it through more optimized models to extract only what's relevant to your quest, then sends the filtered result back.

- Claude's full intelligence on architecture & code
- Trash mobs handled by leaner models
- Your existing workflow, unchanged
- Same firepower, at a fraction of the mana cost

Claude still handles your architecture decisions, writing clean & concise code, complex debugging, and code reviews—the actual boss fights. It just stops wasting magic on tool outputs that didn't need Claude-level intelligence in the first place.

```mermaid
flowchart TB
    USER[Your Prompt] --> CLAUDE[Claude]
    CLAUDE --> |read_optimized| MANA[MANA MCP Server]
    CLAUDE --> |bash_optimized| MANA
    CLAUDE --> |search_optimized| MANA
    MANA --> |Raw Content| API[MANA Optimization API]
    API --> |Compressed| MANA
    MANA --> |50-80% fewer tokens| CLAUDE
    CLAUDE --> RESPONSE[Claude's Response]
```

**Smart Routing** — Every tool action routes to a lightweight model benchmarked as the most accurate for that specific job.

**Lean Processing** — Optimized models handle the heavy lifting—reading files, parsing bash outputs, extracting precise answers.

**Compounding Savings** — Leaner responses mean leaner context. Savings stack with every turn. Longer sessions, fewer tokens burned.

### Mana Pool: Doubled

| Plan | Before | With Mana |
|------|--------|-----------|
| Claude Pro | 25 hours | **50 hours** |
| Claude Max $100 | 125 hours | **250 hours** |
| Claude Max $200 | 500 hours | **1000 hours** |

**Same Claude intelligence. Double the hours. A fraction of the price!**

---

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

> **Note:** Project-level configs override global. You can mix and match (e.g., global MCP server + per-project instructions).

### Step 3: Add Claude Instructions

#### Manual Install

Copy the contents of [CLAUDE_INSTRUCTIONS.md](https://github.com/scottymade/mana/blob/main/instructions/CLAUDE_INSTRUCTIONS.md) and **prepend** it to the beginning of your CLAUDE.md file:

**3a. Project only:** Prepend to `CLAUDE.md` in your project root

**3b. Global:** Prepend to `~/.claude/CLAUDE.md`

#### Automatic Install

**3a. Project only** (run from your project root):

```bash
{ curl -fsSL https://raw.githubusercontent.com/scottymade/mana/main/instructions/CLAUDE_INSTRUCTIONS.md; echo ""; echo "---"; echo ""; cat CLAUDE.md 2>/dev/null; } > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
```

**3b. Global** (run from anywhere, applies to all projects):

```bash
{ curl -fsSL https://raw.githubusercontent.com/scottymade/mana/main/instructions/CLAUDE_INSTRUCTIONS.md; echo ""; echo "---"; echo ""; cat ~/.claude/CLAUDE.md 2>/dev/null; } > ~/.claude/CLAUDE.md.tmp && mv ~/.claude/CLAUDE.md.tmp ~/.claude/CLAUDE.md
```

> **Note:** These commands prepend MANA instructions to existing files. Your existing CLAUDE.md content will be preserved below the MANA instructions.

---

### Restart Claude Code and start saving tons of Mana!

1. Restart Claude Code in your project
2. Run `/mcp` to verify MANA is connected

---

## Verify It's Working

After setup, ask Claude to read a file:

```
Read the package.json file and tell me what dependencies this project uses.
```

You should see output like:

```
read_optimized [EXTRACT] -> 1,247 tokens saved (72% reduction) [1,732 -> 485]
```

If you see token savings in the output, MANA is working.

---

## What the Instructions File Does

The `CLAUDE.md` file teaches Claude to:

- Use `read_optimized` instead of the native `Read` tool
- Use `bash_optimized` instead of the native `Bash` tool
- Use `search_optimized` instead of `Glob` and `Grep`
- Use `list_directory_optimized` for directory listings

Without this file, Claude will use its built-in tools and you won't get any token savings. **This step is required for MANA to work.**

---

## How to Update MANA

To get the latest version of MANA:

```bash
npm update -g @scottymade/mana
```

Or install a specific version:

```bash
npm install -g @scottymade/mana@latest
```

This will update both the npm package and automatically download the latest binary.

After updating, restart Claude Code to use the new version.

**Check your current version:**

```bash
npm list -g @scottymade/mana
```

---

## Troubleshooting

### "Command not found" error

Make sure the npm package is installed globally:

```bash
npm install -g @scottymade/mana

# Verify it's in PATH
which mana
```

### Claude isn't using MANA tools

1. Verify `CLAUDE.md` exists (project root or `~/.claude/CLAUDE.md` for global)
2. Restart Claude Code after making changes
3. Check that the instructions appear in Claude's context

### "Invalid API key" error

1. Verify your key at [devmana.ai/settings](https://devmana.ai/settings)
2. Re-run the `claude mcp add` command with the correct key
3. Ensure the key hasn't been revoked

### API Usage

Check your API usage on your [Mana Dashboard](https://app.devmana.ai/)

---

## Support

- **Documentation**: [GitHub](https://github.com/scottymade/mana/)
- **Issues**: [GitHub Issues](https://github.com/scottymade/mana/issues)
- **Bugs, Feedback and Feature Requests** can be sent via the chat feature in your [Mana Dashboard](https://app.devmana.ai/)

---

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.
