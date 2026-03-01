# Changelog

All notable changes to MANA MCP Server will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.1] - 2026-03-01

### Changed
- Updated README and npm package copy to reflect new messaging

## [1.2.0] - 2026-03-01

### Added
- CLI setup and update commands with 12-platform support
- Windows x64 binary distribution

### Fixed
- Security hardening and stability improvements

## [1.1.1] - 2026-02-25

### Fixed
- Fix subscription feature check for MCP sub-server proxy initialization

## [1.1.0] - 2026-02-23

### Added
- MCP sub-server proxy — proxy and multiplex child MCP servers via meta-tools (`mana_list_tools`, `mana_describe_tool`, `mana_call_tool`)
- Dynamic meta-tool descriptions — connected sub-server names and tool names are surfaced directly in tool schema, so the LLM knows what's available without calling any tool first
- Daemon mode with session multiplexing for concurrent MCP connections
- Tier-gated features — proxy (Wizard+) and multiplexing (Archmage) gated by subscription plan
- Project-level config support (`.mana-mcp.json`) with priority: CLI flag > project > user-level config
- `index_codebase` tool for building searchable code indices
- Windows x64 binary support

### Fixed
- Removed env var backdoors (`MANA_ENABLE_MCP_PROXY`, `MANA_ENABLE_MULTIPLEXING`) that bypassed tier-gating

## [1.0.0] - 2025-12-21

### Added
- Initial public release
- npm package distribution (`npm install -g @scottymade/mana-mcp`)
- Project setup script for quick configuration
- Core MCP tools:
  - `read_optimized` - Smart file reading with action-based optimization
  - `read_optimized_batch` - Batch file processing for multiple files
  - `bash_optimized` - Command execution with intelligent output filtering
  - `search_optimized` - Combined glob and grep functionality
  - `list_directory_optimized` - Directory listing with filtering
  - `submit_feedback` - Bug and feature reporting
- Action types for fine-grained optimization:
  - SUMMARIZE, EXTRACT, READ_FULL, CHECK, FORMAT, DEBUG_LOGS, GIT_CONFIG
  - Batch types: EXTRACT_BATCH, EXTRACT_SYNTHESIZE_BATCH
- Cross-platform binaries (macOS ARM64/x64, Linux x64)

### Platforms
- macOS Apple Silicon (darwin-arm64)
- macOS Intel (darwin-x64)
- Linux x64 (linux-x64)
