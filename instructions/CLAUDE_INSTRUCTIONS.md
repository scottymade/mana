<mana>
# MANA Token Optimization - MANDATORY TOOL REPLACEMENTS

**CRITICAL: NEVER use native Read, Bash, Search, Grep, or Glob tools. ALWAYS use MANA optimized versions.**

**There is NO valid reason to use native tools when optimized versions exist. NEVER fall back to native tools.**

🛑 **STOP AND CHECK** before using any native tool:
- "Am I about to use Read?" → Use `read_optimized` instead
- "Am I about to use Bash?" → Use `bash_optimized` instead  
- "Am I about to use Search/Grep/Glob?" → Use `search_optimized` instead

## Tool Replacements

| Native Tool | MANA Replacement |
|-------------|------------------|
| Read | **read_optimized** (prefer EXTRACT action_type for finding things) |
| Read (multiple files) | **read_optimized_batch** |
| Bash | **bash_optimized** (exception: long-running servers use native Bash) |
| Search/Grep/Glob | **search_optimized** |
| Glob (directories) | **list_directory_optimized** |

⚠️ **EXTRACT is almost always what you want** for read_optimized. READ_FULL is rarely needed — only when you explicitly need every single line.

**bash_optimized tip:** For interactive prompts, use -y flags or pipe input (e.g., `echo "yes" | npx create-next-app`)

---

## CRITICAL: File Editing Workflow

**The ONE-READ RULE:** When editing files:

1. **First:** `read_optimized` with CHECK or EXTRACT
2. **Satisfy Edit requirement:** Native Read with `limit: 1` (ONE line only!)
3. **Edit:** Use Edit/Write tool
4. **Verify:** `read_optimized` with CHECK (NOT native Read)

```
✅ read_optimized → Read(limit:1) → Edit → read_optimized
❌ read_optimized → Read(full) → Edit → Read → Read
```

**The "Ticket" Concept:** Think of native Read as a one-time ticket to use Edit/Write:
- 🎫 Buy cheapest ticket ONCE: `Read(file_path, offset=0, limit=1)`
- 🎬 Use Edit/Write
- ⚡ Return to read_optimized IMMEDIATELY

**When you see "File has not been read yet":** This is expected.
1. Call native Read ONCE with `limit: 1`
2. Proceed with Edit/Write
3. Switch back to read_optimized immediately

**HARD RULE: Never use native Read twice in a row.** If you use native Read in consecutive messages, you have made an error.

**Self-check before calling native Read:**
- "Did I just use native Read in my last response? If yes, I MUST use read_optimized instead."

**Stop if you catch yourself thinking:**
- "I'll just use Read since I already used it once..." → **STOP** - return to read_optimized
- "It's easier to stick with Read..." → **STOP** - return to read_optimized

**Common mistakes:**
- ❌ Using native Read before editing → Use read_optimized with CHECK
- ❌ Using native Read after a write fails → Use read_optimized with CHECK
- ❌ Reading full file when limit:1 works → Always use limit:1

Token savings: ~480 tokens per edit (96% reduction)

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