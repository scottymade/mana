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

const https = require('https');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// ============================================================================
// Configuration
// ============================================================================

const REPO = 'scottymade/mana';
const GITHUB_RELEASES_URL = `https://github.com/${REPO}/releases/latest/download`;

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
 * Download a file from URL to destination
 * Follows redirects (GitHub releases redirect to S3)
 */
function downloadFile(url, dest) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(dest);

    const request = (url) => {
      https.get(url, (response) => {
        // Handle redirects (GitHub releases return 302)
        if (response.statusCode === 301 || response.statusCode === 302) {
          const redirectUrl = response.headers.location;
          request(redirectUrl);
          return;
        }

        if (response.statusCode !== 200) {
          reject(new Error(`Failed to download: HTTP ${response.statusCode}`));
          return;
        }

        response.pipe(file);

        file.on('finish', () => {
          file.close();
          resolve();
        });
      }).on('error', (err) => {
        fs.unlink(dest, () => {}); // Delete partial file
        reject(err);
      });
    };

    request(url);
  });
}

// ============================================================================
// Main
// ============================================================================

async function main() {
  const binaryName = getBinaryName();
  const downloadUrl = `${GITHUB_RELEASES_URL}/${binaryName}`;
  const binDir = path.join(__dirname, '..', 'bin');
  const binaryPath = path.join(binDir, binaryName);

  console.log(`\nMANA: Installing ${binaryName}...`);

  // Ensure bin directory exists
  if (!fs.existsSync(binDir)) {
    fs.mkdirSync(binDir, { recursive: true });
  }

  // Download the binary
  try {
    await downloadFile(downloadUrl, binaryPath);
  } catch (error) {
    console.error(`\nError downloading MANA binary: ${error.message}`);
    console.error(`URL: ${downloadUrl}\n`);
    process.exit(1);
  }

  // Make it executable
  fs.chmodSync(binaryPath, 0o755);

  // Create a symlink or copy as 'mana-mcp-binary' so the wrapper can find it
  const symlinkPath = path.join(binDir, 'mana-mcp-binary');
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

main().catch((error) => {
  console.error('MANA installation failed:', error.message);
  process.exit(1);
});
