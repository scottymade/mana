<p align="center">
  <a href="https://devmana.ai">
    <img src="docs/mana-promo-api-spend.png" alt="Mana - Boss-Tier AI. Minion-Tier Costs. Save 50-70% on AI Coding API Costs" width="800">
  </a>
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
    <img src="https://img.shields.io/badge/AI%20Coding%20Agent-MCP%20Server-purple.svg" alt="Mana AI Coding Agent MCP Server">
  </a>
  <a href="https://github.com/scottymade/mana/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/scottymade/mana" alt="License">
  </a>
</p>

---

<a href="https://devmana.ai">MANA</a> intercepts bloated tool responses and routes them through lightweight models benchmarked for task accuracy. File reads, bash outputs, search results, and MCP calls — all optimized before reaching your AI coding agent, saving 50-70% on API costs. Your agent keeps its full power for the boss fights — architecture, debugging, code generation. The minion work gets handled for a fraction of the cost.

**Result: Same AI intelligence. 50-70% less spend. No change to your workflow.**

---

## Your Mana Bar Has a Hole In It

*Debuff effect: Token bleed on every tool call. Here's how it stacks:*

### File Operations Are Mana Vampires

Your AI agent reads an entire component file. 2,847 lines. Only 40 were relevant to your query. That's 2,800+ wasted tokens per file op. One trash mob just ate your spell slots.

### Bash Commands Siphon Mana on Every Cast

You run `npm run test`. Your AI agent gets back 5,000 tokens - suite names, timing breakdowns, coverage reports. You just needed to know: is the build alive? Mana bar blinked red for a pulse check.

### Directory Searches Burn Through Reserves

Your AI agent casts Locate Object to find a file. Miss. Recasts with new keywords. Miss. Third cast, broader search. Nothing batched. That's 3x the tokens for one file path.

### It's a Wipe. Pull the Combat Log — Here's What Killed You.

| 70-90% | MCP bloat | 2-3x |
|--------|-----------|------|
| of tokens go to tool bloat — not your actual work | unfiltered API calls draining mana on every lookup | faster bleed in large codebases |

**You're not bad at token management. The debuff was running before you even started coding.**

---

## How It Works

**Reclaim Your Mana Pool**

You don't need a bigger mana pool. You need to stop the drain on the one you have.

<a href="https://devmana.ai">MANA</a> saves 50-70% of your budget from going to bloated tool responses, unfiltered MCP calls, and brute-force file searches — routing the low-level work to optimized models so you stop paying boss rates for minion work.

- Your AI agent's full intelligence on architecture & code
- Minion work routed to minion-tier models
- Your existing workflow, unchanged
- Same firepower, at a fraction of the mana cost

Your AI coding agent keeps its full power for architecture, debugging, and code generation — the actual boss fights. <a href="https://devmana.ai">MANA</a> just stops it from burning spell slots on everything else.

**Smart Routing** — Every tool action routes to a lightweight model benchmarked as the most accurate for that specific job.

**Lean Processing** — Optimized models handle the heavy lifting—reading files, parsing bash outputs, extracting precise answers.

**Compounding Savings** — Leaner responses mean leaner context. Savings stack with every turn. Longer sessions, fewer tokens burned.

### Your API Budget, Stretched 2-3x Further

| Monthly API Spend | Estimated Waste | With <a href="https://devmana.ai">MANA</a> |
|-------------------|-----------------|-----------|
| $600/mo | ~$420 goes to bloat | **Save $300-420/mo** |
| $1,500/mo | ~$1,050 goes to bloat | **Save $750-1,050/mo** |
| $2,500/mo | ~$1,750 goes to bloat | **Save $1,250-1,750/mo** |

**Same AI intelligence. 50-70% less spend. No change to your workflow.**

---

## Mana Dashboard

<p align="center">
  <a href="https://waitlist.devmana.ai">
    <img src="docs/mana-dashboard.png" alt="Mana Dashboard" width="800">
  </a>
</p>

---

## Quick Start

```bash
# 1. Install
npm install -g @scottymade/mana

# 2. Setup (auto-detects your platforms, prompts for API key)
mana setup
```

Get your API key at [devmana.ai](https://devmana.ai) → **Settings** → **API Keys**

That's it. `mana setup` detects which AI coding platforms you have installed, configures MCP + prompt injection for each one, and you're ready to go.

### Supported Platforms

Claude Code, OpenAI Codex, OpenCode, Cursor, Windsurf, GitHub Copilot, JetBrains AI, Cline, Roo Code, Continue.dev, Zed, Trae IDE, and Aider.

### Restart your editor and start saving tons of Mana!

---

## Verify It's Working

After setup, ask your agent to read a file:

```
Read the package.json file and tell me what dependencies this project uses.
```

You should see output like:

```
read_optimized [EXTRACT] -> 1,247 tokens saved (72% reduction) [1,732 -> 485]
```

If you see token savings in the output, <a href="https://devmana.ai">MANA</a> is working.

---

## How to Update MANA

```bash
npm update -g @scottymade/mana
```

The update automatically refreshes the <a href="https://devmana.ai">MANA</a> prompt across all configured platforms. Restart your editor to use the new version.

**Check your current version:**

```bash
npm list -g @scottymade/mana
```

---

## Mana Optimization Core: Your Spellbook — Optimized Versions of Internal Tools

*Your spellbook just got enchanted. Same incantations, at a fraction of the casting cost.*

<a href="https://devmana.ai">MANA</a> swaps out your AI's clunky default tools for lean, optimized versions. Same AI tool call power, at fraction of the API cost. 

### The Arsenal

| Spell | Replaces | What It Actually Does |
|-------|----------|----------------------|
| `read_optimized` | Native file read | Reads a 3,000-line file, returns only the 40 lines you needed |
| `read_optimized_batch` | Multiple file reads | Raids multiple files in one cast. Efficient looting at scale. |
| `bash_optimized` | Native shell execution | Runs a command, strips the noise from the output |
| `search_optimized` | Native grep/glob | Locally indexed semantic code searches without burning API costs on fails lookups |
| `list_directory_optimized` | Native directory listing | Maps the dungeon without drawing every brick |
| `git_optimized` | Native git commands | Git log, diff, status — compressed to what matters |

---

### Mana MCP Call Optimization: Rally Your Familiars

*Every wizard knows — a loyal familiar doesn't just follow orders.  It filters the noise so you can focus on the completing your cast at full power.*

Wizard & Archmage plan users can setup MCP sub-servers that live behind our Mana optization.  MCPs you already use — GitLab, Brave Search, database tools, custom scripts, whatever's in your party. Instead of each agent spawning and managing them separately, <a href="https://devmana.ai">MANA</a> runs them all behind a single daemon. Your AI talks to <a href="https://devmana.ai">MANA</a>, <a href="https://devmana.ai">MANA</a>  talks to your sub-servers, and every response that flows back gets the same token optimization treatment. One connection. All your tools. Leaner output on everything.

Create a config file at `~/.mana/mcp-servers.json` (global) or `.mana-mcp.json` (per-project):

```json
{
  "mcpServers": {
    "gitlab": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gitlab"],
      "env": { "GITLAB_PERSONAL_ACCESS_TOKEN": "glpat-xxxxxxxxxxxx" }
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": { "BRAVE_API_KEY": "BSA..." }
    },
    "time": {
      "command": "python",
      "args": ["-m", "mcp_server_time", "--local-timezone=America/New_York"]
    }
  }
}
```

### Context Savings for Each MCP Server Added

Similar to how Claude Code only reveals the tool definitions and schemas as they're needed, we also only show the names and descriptions of the subservers to the AI so your session saves a ton of context.  

Your AI has the ability to look into the details of the tools as needed, and can load schemas to invoke the correct tool calls and use as it normally would:

| Meta-Spell | What It Does |
|------------|-------------|
| `mana_list_tools` | Survey all available familiar abilities |
| `mana_describe_tool` | Inspect a specific ability's full schema |
| `mana_call_tool` | Command a familiar to act |

No bloat upfront. Full power on demand. The more MCP servers you add, the more context you save — and the more room your AI has to focus on the boss fights.

---

## The Archmage's Summon Circle — MCP Multiplexer

*Archmage Tier only. For those who command an army of AI Agents ready to serve.*

Every agent you spin up spawns its own instance of every MCP server available to it. Run five agents in parallel with six MCP servers each, and that's thirty separate processes eating RAM and grinding your system to a crawl. Task performance tanks. Completion times balloon. Your army of agents becomes a bottleneck instead of a force multiplier.

Mana's multiplexer lets you summon all your MCP servers through a single daemon. Configure once, use everywhere. Every agent shares the same server instances — slashing RAM usage while still getting the full Mana token optimization treatment on every response that flows through.

More agents. Less overhead. If you're running the kind of parallel workflows that bring most systems to their knees, this is how you scale without sacrifice.

---

## Troubleshooting

### "Command not found" error

Make sure the npm package is installed globally:

```bash
npm install -g @scottymade/mana

# Verify it's in PATH
which mana
```

### AI assistant isn't using MANA tools

1. Run `mana setup` again to verify configuration
2. Restart your editor after setup
3. Check that <a href="https://devmana.ai">MANA</a> tools appear in your platform's MCP/tool list

### "Invalid API key" error

1. Create a new API key in the Dashboard [app.devmana.ai](https://app.devmana.ai)
2. Run `mana setup` again with the correct key
3. Ensure the key hasn't been revoked

### API Usage

Check your API usage on your [Mana Dashboard](https://app.devmana.ai/)

---

## Support

- **Documentation**: [GitHub](https://github.com/scottymade/mana/)
- **Issues**: [GitHub Issues](https://github.com/scottymade/mana/issues)

---

## License

Proprietary / EULA  - See [LICENSE](LICENSE) for details.
