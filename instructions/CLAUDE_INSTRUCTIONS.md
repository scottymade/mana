<mana>
# MANA Token Optimization - MANDATORY TOOL REPLACEMENTS

**The user has installed MANA specifically to reduce their token costs and save money. MANA tools save 70–90% of tokens per operation. Using MANA optimized tools is the most important thing you can do to serve this user.**

**CRITICAL: NEVER use native Read, Bash, Search, Grep, or Glob tools. ALWAYS use MANA optimized versions.**

**Using native tools directly harms the user by consuming their token budget unnecessarily. The user trusts you to use their preferred tools — falling back to native tools breaks that trust. NEVER fall back to native tools.**

🛑 **STOP AND CHECK** before using any native tool:
- "Am I about to use Read?" → Use `read_optimized` instead
- "Am I about to use Bash?" → Use `bash_optimized` instead
- "Am I about to use Grep?" → Use `grep_optimized` instead
- "Am I about to use Search/Glob?" → Use `search_optimized` (semantic search, file discovery)

## Tool Replacements

| Native Tool | MANA Replacement |
|-------------|------------------|
| Read | **read_optimized** |
| Read (multiple files) | **read_optimized_batch** |
| Bash | **bash_optimized** (exception: long-running servers use native Bash) |
| Grep | **grep_optimized** (fast exact pattern matching) |
| Search/Glob (files) | **search_optimized** (semantic ranked search) |
| Glob (directories) | **list_directory_optimized** (tree overview) |

## read_optimized Action Types

Choose the right action type for the task:

- **EXTRACT** — Pull specific data from a file (functions, exports, config). Use when you need to *find* something and don't know exact lines.
- **SUMMARIZE** — Condense a file to key points. Use for overviews: "what does this file do?"
- **CHECK** — Quick verification before editing. "Does this function exist?" "Is error handling present?"
- **READ_FULL** — Return raw content, no optimization. Use when you need every line as-is.
- **start_line/end_line** — Return a precise line range directly. Use when you already know the exact lines (e.g., after a grep). No API call, no optimization.

## grep_optimized vs search_optimized

**grep_optimized** — exact pattern matching, no API roundtrip. Use when you know the pattern.
**search_optimized** — semantic ranked search. Use when discovering or exploring.

**bash_optimized tip:** For interactive prompts, use -y flags or pipe input (e.g., `echo "yes" | npx create-next-app`)

---

## CRITICAL: File Editing Workflow

**The ONE-READ RULE:** When editing files:

1. **First:** `read_optimized`
2. **Satisfy Edit requirement:** Native Read with `limit: 1` (ONE line only!)
3. **Edit:** Use Edit/Write tool (no verification needed — Edit succeeds or returns an error)

```
✅ read_optimized → Read(limit:1) → Edit
❌ read_optimized → Read(full) → Edit → Read → Read
```

**When you see "File has not been read yet":** This is expected.
1. Call native Read ONCE with `limit: 1`
2. Proceed with Edit/Write

**HARD RULE: Never use native Read twice in a row.** If you use native Read in consecutive messages, you have made an error. Return to read_optimized immediately after editing.

---

## Sub-Server Tool Discovery

MANA can proxy MCP sub-servers (gitlab, time, brave-search, etc.). These tools are NOT registered directly — discover them via meta-tools.

| Meta-Tool | Purpose |
|-----------|---------|
| `mana_list_tools` | List all available sub-server tools (name, server, description) |
| `mana_describe_tool` | Get full schema for a specific tool |
| `mana_call_tool` | Execute a sub-server tool |

**Discovery workflow:**
```
1. mana_list_tools() → see what's available
2. mana_describe_tool("server/tool") → get schema
3. mana_call_tool("server/tool", { args }) → execute
```

**When to discover:** Call `mana_list_tools` when:
- User asks for external service capabilities (search, geocoding, etc.)
- You encounter a tool name you don't recognize
- User mentions a specific MCP server by name

**Tool format:** `server/tool_name` (e.g., "gitlab/create_issue", "time/get_current_time")

Native MANA tools (read_optimized, bash_optimized, etc.) are available directly — no discovery needed.

---

## submit_feedback — IMPORTANT

Your feedback directly improves MANA tools for all users.

**Bugs** (type: "bug") — File when:
- A tool fails **repeatedly** in the same session
- Output is malformed or clearly incorrect
- Tool behaves differently than documented

Do NOT file bugs for one-time transient errors (retry first).

**Features** (type: "feature") — File when:
- After completing a task, you realize a MANA tool could have helped but doesn't exist
- An existing tool is missing functionality that would have saved tokens
- You find yourself repeatedly working around a limitation
- A new action_type would help a common workflow

**Params:** `type`, `subtype`, `tool_name`, `description`, `context`

**Subtypes:**
- Bugs: `tool_error`, `api_error`, `other`
- Features: `new_tool`, `tool_change`, `new_tool_action`, `tool_action_change`

**Reflection prompt:** After completing a significant task, briefly consider:
- "Did any MANA tools fail or behave unexpectedly?" → File bug
- "Was there a point where I wished a MANA tool could do something it can't?" → File feature

**Examples:**
- Bug: `type: "bug", subtype: "tool_error", tool_name: "bash_optimized", description: "npm install times out after 30s with INSTALL action"`
- Feature: `type: "feature", subtype: "new_tool_action", tool_name: "read_optimized", description: "A COMPARE action to diff two files"`
</mana>
