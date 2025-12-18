# Changelog

All notable changes to MANA MCP Server will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-XX-XX

### Added
- Initial public release
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
- Claude Code Plugin Marketplace integration
- Universal install script for cross-IDE support
- Cross-platform binaries (macOS ARM64/x64, Linux x64, Windows x64)

### Platforms
- macOS Apple Silicon (darwin-arm64)
- macOS Intel (darwin-x64)
- Linux x64 (linux-x64)
- Windows x64 (windows-x64)
