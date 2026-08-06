#!/usr/bin/env node
// ============================================================================
// MANA MCP - Postinstall Script
// ============================================================================
// This script runs after `npm install` and downloads the correct binary
// for the user's operating system and architecture.
//
// Supported platforms:
//   - macOS (darwin) arm64 (M1/M2/M3)
//   - macOS (darwin) x64 (Intel)
//   - Linux x64
// ============================================================================

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { execFileSync } = require('child_process');

// ============================================================================
// Configuration
// ============================================================================

const REPO = 'scottymade/mana';
const CURL_PATH = process.platform === 'win32'
  ? path.join(process.env.SystemRoot || 'C:\\Windows', 'System32', 'curl.exe')
  : (fs.existsSync('/usr/bin/curl') ? '/usr/bin/curl' : '/usr/local/bin/curl');

// Map of platform/arch to binary name
const BINARY_MAP = {
  'darwin-arm64': 'mana-mcp-darwin-arm64',
  'darwin-x64': 'mana-mcp-darwin-x64',
  'linux-x64': 'mana-mcp-linux-x64',
};

// ============================================================================
// Helper Functions
// ============================================================================

/**
 * Get the binary name for the current platform
 */
function getBinaryName() {
  const platform = process.platform;
  const arch = process.arch;
  const key = `${platform}-${arch}`;

  const binaryName = BINARY_MAP[key];

  if (!binaryName) {
    console.error(`\nError: Unsupported platform: ${platform}-${arch}`);
    console.error('MANA supports: macOS (arm64, x64), Linux (x64)\n');
    process.exit(1);
  }

  return binaryName;
}

/**
 * Download a file from URL to destination using curl
 * More reliable than Node https for following GitHub redirects
 */
function downloadFile(url, dest) {
  try {
    execFileSync(
      CURL_PATH,
      [
        '-fsSL',
        '--proto', '=https',
        '--proto-redir', '=https',
        '--tlsv1.2',
        '--retry', '3',
        '--retry-all-errors',
        url,
        '-o', dest,
      ],
      { stdio: 'pipe' },
    );
  } catch (error) {
    throw new Error(`Failed to download: ${error.message}`);
  }
}

function sha256File(filePath) {
  return crypto.createHash('sha256').update(fs.readFileSync(filePath)).digest('hex');
}

function expectedChecksum(manifest, version, binaryName) {
  if (!manifest || manifest.version !== version) {
    throw new Error(`Checksum manifest does not match package version ${version}`);
  }
  const checksum = manifest.sha256 && manifest.sha256[binaryName];
  if (typeof checksum !== 'string' || !/^[a-f0-9]{64}$/i.test(checksum)) {
    throw new Error(`No valid SHA-256 checksum published for ${binaryName}`);
  }
  return checksum.toLowerCase();
}

// ============================================================================
// Main
// ============================================================================

async function main() {
  const packageJson = require('../package.json');
  const version = packageJson.version;
  if (typeof version !== 'string' || !/^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?$/.test(version)) {
    throw new Error(`Invalid package version: ${String(version)}`);
  }
  const binaryName = getBinaryName();
  const downloadUrl = `https://github.com/${REPO}/releases/download/v${version}/${binaryName}`;
  const binDir = path.join(__dirname, '..', 'bin');
  const binaryPath = path.join(binDir, binaryName);
  const temporaryPath = `${binaryPath}.download-${process.pid}`;
  const manifest = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'checksums.json'), 'utf8'));
  const expected = expectedChecksum(manifest, version, binaryName);

  console.log(`\nMANA: Installing ${binaryName}...`);

  // Ensure bin directory exists
  if (!fs.existsSync(binDir)) {
    fs.mkdirSync(binDir, { recursive: true });
  }

  // Download the binary
  try {
    downloadFile(downloadUrl, temporaryPath);
    const actual = sha256File(temporaryPath);
    if (actual !== expected) {
      throw new Error(
        `SHA-256 mismatch for ${binaryName}: expected ${expected}, received ${actual}`,
      );
    }
    fs.renameSync(temporaryPath, binaryPath);
  } catch (error) {
    try { fs.unlinkSync(temporaryPath); } catch { /* absent or already promoted */ }
    console.error(`\nError downloading MANA binary: ${error.message}`);
    console.error(`URL: ${downloadUrl}\n`);
    process.exit(1);
  }

  // Make it executable
  fs.chmodSync(binaryPath, 0o755);

  // Create a symlink or copy as 'mana-binary' so the wrapper can find it
  const symlinkPath = path.join(binDir, 'mana-binary');
  try {
    if (fs.existsSync(symlinkPath)) {
      fs.unlinkSync(symlinkPath);
    }
    // Use copy instead of symlink for better cross-platform support
    fs.copyFileSync(binaryPath, symlinkPath);
    fs.chmodSync(symlinkPath, 0o755);
  } catch (error) {
    // If copy fails, the wrapper will fall back to detecting the binary
    console.warn(`Warning: Could not create binary link: ${error.message}`);
  }

  console.log('MANA: Installation complete!\n');
  console.log('Next steps:');
  console.log('  1. Create .mcp.json in your project (see README)');
  console.log('  2. Add MANA instructions to .claude/CLAUDE.md');
  console.log('  3. Restart Claude Code\n');
}

if (require.main === module) {
  main().catch((error) => {
    console.error('MANA installation failed:', error.message);
    process.exit(1);
  });
}

module.exports = { expectedChecksum, getBinaryName, main, sha256File };
