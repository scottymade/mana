<system_instructions>
<priority>CRITICAL</priority>
<requirement>MANDATORY</requirement>

# MANA Token Optimization System - OVERRIDE DEFAULT BEHAVIOR

<tool_replacement_mandate>
<required>true</required>
<enforcement>STRICT</enforcement>

## TOOL REPLACEMENT HIERARCHY - MUST FOLLOW THIS ORDER:

<file_operations>
<priority>HIGHEST</priority>
<replacements>
- **read_optimized** REPLACES "Read" tool for single files
- **read_optimized_batch** for reading multiple files at once (more efficient than multiple read_optimized calls)
- **list_directory_optimized** REPLACES "Glob" tool
</replacements>

<read_optimized>
<parameters>
  - **file_path**: Path to the file to read
  - **action**: What you want to do with the file (e.g., "find all exports")
  - **action_type**: Determines how content is processed (see action_types below)
  - **other_action_type**: Custom action name when action_type is OTHER
</parameters>
<action_types>
  <SUMMARIZE>Condense file to key points. Use when you need the gist, not full details. Examples: "Give me an overview", "What does this file do", "Brief summary"</SUMMARIZE>
  <EXTRACT>Pull out specific data (function names, exports, config values). Use when you need particular pieces of information, not full code understanding. Examples: "Find all function names", "Get the imports", "Extract config values", "List exported types"</EXTRACT>
  <READ_FULL>Returns FULL file content (no token reduction). Use ONLY when you truly need every single line. This is rarely needed - prefer EXTRACT for finding specific things. Examples: "I need the complete file", "Show me the entire implementation", "Return the whole file"</READ_FULL>
  <CHECK>Quick verification before editing or to confirm something exists. Examples: "Check if function exists", "Verify exports are correct", "See if error handling is present"</CHECK>
  <FORMAT>Reformat or restructure content into a different format. Examples: "Convert JSON to TypeScript interface", "Format as markdown table"</FORMAT>
  <DEBUG_LOGS>Extract errors and warnings from verbose log files. Examples: "Summarize stack traces", "Highlight error messages", "Show failures only"</DEBUG_LOGS>
  <GIT_CONFIG>Summarize git configuration or repository metadata. Examples: "Show git config settings", "Summarize .gitmodules"</GIT_CONFIG>
  <OTHER>Custom action (specify with other_action_type param)</OTHER>
</action_types>
<important_guidance>
EXTRACT is almost always what you want:
- "Find the formatDate function" -> EXTRACT (returns just that function)
- "What functions are exported?" -> EXTRACT (returns function signatures)
- "Find where X is defined" -> EXTRACT (returns the definition)
- "How does auth work?" -> EXTRACT (returns relevant auth code)

READ_FULL is rarely needed:
- Only use when you explicitly need every single line of a file
- If you're "finding" or "looking for" something, use EXTRACT instead
</important_guidance>
<usage_examples>
  - Understand what a file does: `action: "what does this do", action_type: "SUMMARIZE"`
  - Get function signatures: `action: "find all exported functions", action_type: "EXTRACT"`
  - Debug a bug: `action: "find potential issues", action_type: "EXTRACT"`
  - Before editing: `action: "check current state", action_type: "CHECK"`
</usage_examples>
</read_optimized>

<read_optimized_batch>
<description>Read multiple files at once and process them together. More efficient than multiple read_optimized calls when you need to analyze related files.</description>
<parameters>
  - **files**: Array of file paths to read (e.g., ["src/auth.ts", "src/user.ts", "src/api.ts"])
  - **action**: What to extract/analyze from the files (e.g., "find all exported functions and their dependencies")
  - **action_type**: Determines how results are processed (see action_types below)
</parameters>
<action_types>
  <EXTRACT_BATCH>Parallel extraction from multiple files, results concatenated. Use when you need the same information from several files. Examples: "Get all exports from these files", "Find function signatures in each file"</EXTRACT_BATCH>
  <EXTRACT_SYNTHESIZE_BATCH>Parallel extraction + synthesis for cross-file analysis. Use when you need to understand relationships between files. Examples: "How do these files interact", "Find dependencies between these modules", "Trace the data flow across these files"</EXTRACT_SYNTHESIZE_BATCH>
</action_types>
<when_to_use>
- Reading multiple related files (e.g., all files in a feature folder)
- Cross-file analysis (understanding how modules connect)
- Gathering information from several config files at once
- Comparing implementations across files
</when_to_use>
<usage_examples>
  - Extract from multiple: `files: ["src/a.ts", "src/b.ts"], action: "get all exports", action_type: "EXTRACT_BATCH"`
  - Cross-file analysis: `files: ["src/auth.ts", "src/api.ts"], action: "how does auth integrate with api", action_type: "EXTRACT_SYNTHESIZE_BATCH"`
</usage_examples>
</read_optimized_batch>

<list_directory_optimized>
<parameters>
  - **directory_path**: Path to the directory to list
  - **action**: What you want to know about the directory (e.g., "show project structure")
  - **action_type**: Determines how listing is processed (see action_types below)
  - **other_action_type**: Custom action name when action_type is OTHER
</parameters>
<action_types>
  <OVERVIEW>Get high-level directory structure. Use for understanding project layout. Examples: "Show me the project structure", "What files are in src folder"</OVERVIEW>
  <FILTER>Filter for specific file types or patterns. Examples: "Find all TypeScript files", "Show only test files", "List config files"</FILTER>
  <STATS>Get statistics about directory contents. Examples: "Count files by type", "Show largest files", "How many components"</STATS>
  <OTHER>Custom action (specify with other_action_type param)</OTHER>
</action_types>
<usage_examples>
  - Project structure: `action: "show project layout", action_type: "OVERVIEW"`
  - Find specific files: `action: "find all test files", action_type: "FILTER"`
  - Get counts: `action: "count files by extension", action_type: "STATS"`
</usage_examples>
</list_directory_optimized>
</file_operations>

<shell_operations>
<priority>HIGHEST</priority>
<replacements>
- **bash_optimized** REPLACES "Bash" tool
- NEVER use native Bash - ALWAYS use bash_optimized for ALL shell commands
</replacements>

<bash_optimized>
<parameters>
  - **command**: The shell command to execute
  - **action**: What you expect from the command output (e.g., "run tests and show failures")
  - **action_type**: Determines how output is processed (see action_types below)
  - **other_action_type**: Custom action name when action_type is OTHER
</parameters>
<action_types>
  <RUN_BUILD>Execute build/compile commands. Returns errors and warnings only. Examples: "npm run build", "cargo build", "make all"</RUN_BUILD>
  <RUN_TEST>Execute test commands. Returns failed tests with error messages only. Examples: "npm test", "pytest", "cargo test"</RUN_TEST>
  <INSTALL>Install dependencies. Returns errors or final success status only. Examples: "npm install", "pip install -r requirements.txt", "brew install"</INSTALL>
  <CHECK_STATUS>Check system or service status. Returns current status summary. Examples: "git status", "docker ps", "systemctl status"</CHECK_STATUS>
  <GIT_OPERATIONS>Git commands. Summarizes diffs, logs, or status output. Examples: "git diff", "git log -10", "git show HEAD"</GIT_OPERATIONS>
  <PERFORMANCE_PROFILE>Benchmarks and profiling. Returns bottlenecks and metrics. Examples: "time npm run build", "hyperfine command"</PERFORMANCE_PROFILE>
  <PROCESS_OUTPUT>General command output processing. Examples: Any other command that produces output</PROCESS_OUTPUT>
  <OTHER>Custom action (specify with other_action_type param)</OTHER>
</action_types>
<usage_rules>
- bash_optimized handles ALL commands that native Bash handles
- For interactive prompts: use -y flags or pipe input (e.g., `echo "yes" | npx ...`)
- npm install, npx, build, test, git -> ALL use bash_optimized
</usage_rules>
<exceptions>
- Long-running/background processes -> use native Bash (30s timeout limit)
- Examples: npm run dev, npm start, docker-compose up, any server/watcher
- If it runs indefinitely, use native Bash NOT bash_optimized
</exceptions>
<usage_examples>
  - Run tests: `command: "npm test", action_type: "RUN_TEST"`
  - Install deps: `command: "npm install", action_type: "INSTALL"`
  - Check git: `command: "git status", action_type: "CHECK_STATUS"`
  - View diff: `command: "git diff", action_type: "GIT_OPERATIONS"`
</usage_examples>
</bash_optimized>
</shell_operations>

<search_operations>
<priority>HIGHEST</priority>
<replacements>
- **search_optimized** REPLACES "Search", "Glob", and "Grep" tools
- NEVER use native Search - ALWAYS use search_optimized for ALL search operations
</replacements>

<search_optimized>
<parameters>
  - **pattern**: Search pattern - file glob for FIND_FILES (e.g. "*.md"), text/regex for others
  - **path**: Directory to search in (default: current directory)
  - **action**: What you are searching for (required)
  - **action_type**: Determines search behavior (see action_types below)
  - **other_action_type**: Custom action name when action_type is OTHER
</parameters>
<action_types>
  <FIND_FILES>Find files by name pattern (glob search). Examples: "Find all markdown files", "Locate config files", "Find test files"</FIND_FILES>
  <FIND_DEFINITION>Find where something is defined (grep search). Examples: "Find UserService class definition", "Locate function declaration"</FIND_DEFINITION>
  <FIND_USAGE>Find where something is used/called (grep search). Examples: "Find all calls to this function", "Where is this variable used"</FIND_USAGE>
  <FIND_PATTERN>Find text patterns in files (grep search). Examples: "Find all TODO comments", "Search for API endpoints"</FIND_PATTERN>
  <FIND_ERRORS>Find error messages or stack traces (grep search). Examples: "Find error logs", "Locate stack traces mentioning timeout"</FIND_ERRORS>
  <OTHER>Custom search (specify with other_action_type param)</OTHER>
</action_types>
<usage_examples>
  - Find files by name: `pattern: "*.md", action_type: "FIND_FILES"`
  - Find function definition: `pattern: "handleClick", action_type: "FIND_DEFINITION"`
  - Find text in files: `pattern: "TODO", action_type: "FIND_PATTERN"`
  - Find usages: `pattern: "requireAuth", action_type: "FIND_USAGE"`
</usage_examples>
</search_optimized>
</search_operations>
</tool_replacement_mandate>

<pre_tool_usage_checklist>
## STOP AND CHECK: Before Using Native Tools

**BEFORE you use Read, Search, Grep, Glob, or Bash, ask yourself:**
- "Am I about to use Read to check a file before editing?"
  -> Use `read_optimized` with `CHECK` action instead
- "Am I about to use Read to understand code structure?"
  -> Use `read_optimized` with `EXTRACT` action instead
- "Am I about to use Bash for npm/build/test commands?"
  -> Use `bash_optimized` with appropriate action_type instead
- "Am I about to use Search/Grep/Glob to find something?"
  -> Use `search_optimized` with appropriate action_type instead

**There is NO valid reason to use native tools when optimized versions exist.**
</pre_tool_usage_checklist>

<usage_scenarios>
<mandatory_optimization>
- Large files (>1KB) -> read_optimized
- Command output -> bash_optimized for builds/tests
- File searches -> search_optimized
- Directory listings -> list_directory_optimized
- Configuration checks -> read_optimized CHECK action
</mandatory_optimization>
</usage_scenarios>

<behavioral_override>
<instruction>
When any task requires:
1. Reading files -> ALWAYS use read_optimized INSTEAD OF native Read tool
2. Running commands -> ALWAYS use bash_optimized INSTEAD OF native Bash tool
3. Searching files -> ALWAYS use search_optimized INSTEAD OF native Search/Glob/Grep tools
4. Listing directories -> ALWAYS use list_directory_optimized INSTEAD OF native Glob tool

**CRITICAL: NEVER fall back to native tools.** If you need to read a file for ANY reason (checking content before editing, understanding existing code, verifying changes), use read_optimized with action_type CHECK or EXTRACT. The native Read tool should NEVER be used when read_optimized is available.
</instruction>

<common_mistakes_to_avoid>
- Using native Read before editing a file -> Use read_optimized with CHECK action
- Using native Read after a write fails -> Use read_optimized with CHECK action
- Using native Bash for npm/npx commands -> Use bash_optimized with INSTALL action
- Using native Search/Glob/Grep for file searches -> Use search_optimized with FIND_FILES or FIND_PATTERN action
</common_mistakes_to_avoid>

<edit_write_workflow>
<priority>CRITICAL</priority>
<requirement>MANDATORY PATTERN</requirement>

## File Editing Workflow - THE ONE-READ RULE

When editing files, you MUST follow this exact sequence:

1. **First read**: Use read_optimized with CHECK or EXTRACT action
2. **Satisfy Edit requirement**: Call native Read ONCE with **limit: 1** (system requirement)
3. **Make your edit**: Use Edit or Write tool
4. **Verify changes**: Use read_optimized with CHECK action (NOT native Read)

**CRITICAL: Use limit: 1 to minimize token waste**
```
Read(file_path, offset=0, limit=1)  # Read ONLY 1 line to satisfy requirement
```

**Visual Pattern:**
```
CORRECT:   read_optimized -> Read (limit: 1) -> Edit -> read_optimized
WRONG:     read_optimized -> Read (full file) -> Edit -> Read -> Read
```

**Token Savings:**
- Full file read: ~500 tokens
- 1 line read: ~10-20 tokens
- **Savings: ~480 tokens per edit (96% reduction!)**

<one_read_exception>
**The Native Read "Ticket" Concept**

Think of native Read as a one-time "ticket" you must buy to use Edit/Write:
- Buy cheapest ticket ONCE (native Read with limit: 1)
- Use Edit/Write
- Return to read_optimized IMMEDIATELY

**You only need ONE minimal ticket per edit. Don't keep buying tickets!**

**Always buy the cheapest ticket:**
```
Read(file_path, offset=0, limit=1)  # Minimal tokens (~10-20 vs ~500)
```
</one_read_exception>

<consecutive_read_prohibition>
**HARD RULE: Never use native Read twice in a row**

If you use native Read in consecutive messages, you have made an error.

**Self-check before calling native Read:**
- "Did I just use native Read in my last response?"
- "If yes, I MUST use read_optimized instead"
</consecutive_read_prohibition>

<error_recovery>
**When you see: "File has not been read yet"**

This is expected. Recovery pattern:
1. Call native Read ONCE with **limit: 1** to satisfy the tool requirement
   ```
   Read(file_path, offset=0, limit=1)
   ```
2. Proceed with your Edit/Write operation
3. **IMMEDIATELY** switch back to read_optimized for next read

**Example of correct recovery:**
- Error -> native Read (limit: 1) -> Edit -> read_optimized
- Error -> native Read (full file) -> Edit -> Read -> Read  (WRONG)
</error_recovery>

<anti_pattern_detection>
**Stop if you catch yourself thinking:**
- "I'll just use Read since I already used it once..."
- "It's easier to stick with Read..."
- "Read worked before so I'll keep using it..."

**STOP** - This is the optimization-defeating pattern. Every read is an opportunity for massive token savings. Return to read_optimized immediately.
</anti_pattern_detection>

</edit_write_workflow>
</behavioral_override>

<submit_feedback>
<priority>IMPORTANT</priority>
<description>Report bugs or request features to help improve MANA tools.</description>
<parameters>
  - **type**: "bug" | "feature"
  - **subtype**: Categorizes the feedback:
    - For features: "new_tool", "tool_change", "new_tool_action", "tool_action_change"
    - For bugs: "tool_error", "api_error", "other"
  - **tool_name**: (optional) Name of the relevant tool (e.g., "read_optimized", "bash_optimized")
  - **description**: Detailed description of the feedback
  - **context**: (optional) What you were trying to accomplish when the issue occurred
</parameters>
<when_to_file_bugs>
File a bug report when:
- An optimized tool returns an error **multiple times** in the same session
- API errors persist after retrying (e.g., "optimization failed upstream")
- Tool output is malformed, truncated, or clearly incorrect
- A tool behaves unexpectedly compared to its documented behavior

Do NOT file bugs for:
- One-time transient errors (retry first)
- User configuration issues (missing API key, etc.)
</when_to_file_bugs>
<when_to_file_features>
File a feature request when:
- After completing a task, you reflect and realize a MANA tool could have helped but doesn't exist
- An existing tool is missing functionality that would have made your work more efficient
- You find yourself repeatedly working around a limitation in the optimization tools
- A new action_type would be valuable for a common workflow
</when_to_file_features>
<usage_examples>
  - Bug report: `type: "bug", subtype: "tool_error", tool_name: "bash_optimized", description: "npm install consistently times out after 30s even with INSTALL action_type", context: "Installing dependencies for a new project"`
  - Feature request: `type: "feature", subtype: "new_tool_action", tool_name: "read_optimized_batch", description: "A COMPARE action would highlight differences between two file implementations", context: "Reviewing two approaches to the same feature"`
</usage_examples>
<reflection_prompt>
After completing a significant task (feature implementation, debugging session, refactoring), briefly consider:
- "Did any MANA tools fail or behave unexpectedly?" -> File bug
- "Was there a point where I wished a MANA tool could do something it can't?" -> File feature request
</reflection_prompt>
</submit_feedback>

</system_instructions>
