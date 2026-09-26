const assert = require('assert');
const fs = require('fs');
const os = require('os');
const path = require('path');
const vm = require('node:vm');
const { test } = require('node:test');
const { expectedChecksum, sha256File } = require('./postinstall');

const tempDir = fs.mkdtempSync(path.join(os.tmpdir(), 'mana-postinstall-test-'));
try {
  const fixture = path.join(tempDir, 'binary');
  fs.writeFileSync(fixture, 'verified mana binary');
  const checksum = sha256File(fixture);
  const manifest = { version: '1.9.8', sha256: { binary: checksum } };

  assert.strictEqual(expectedChecksum(manifest, '1.9.8', 'binary'), checksum);
  assert.throws(
    () => expectedChecksum(manifest, '1.9.9', 'binary'),
    /does not match package version/,
  );
  assert.throws(
    () => expectedChecksum(manifest, '1.9.8', 'missing'),
    /No valid SHA-256 checksum/,
  );
  console.log('postinstall integrity tests passed');
} finally {
  fs.rmSync(tempDir, { recursive: true, force: true });
}

// Runs the real installer against an owned fixture; never invokes curl or
// codesign, downloads an executable, or touches the installed Mana/configuration.
async function runFixtureInstall({ signatureValid }) {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'mana-postinstall-output-'));
  try {
    const payload = 'harmless binary fixture';
    const binaryName = 'mana-mcp-darwin-arm64';
    const version = '1.2.3';
    const crypto = require('node:crypto');
    fs.writeFileSync(path.join(root, 'checksums.json'), JSON.stringify({
      version,
      sha256: { [binaryName]: crypto.createHash('sha256').update(payload).digest('hex') },
    }));
    const output = [];
    const codesignCalls = [];
    let downloads = 0;
    const binaryPath = path.join(root, 'bin', binaryName);
    const fixtureRequire = (name) => {
      if (name === '../package.json') return { version };
      if (name === 'child_process') return { execFileSync: (command, args) => {
        if (command === '/usr/bin/codesign') {
          codesignCalls.push([...args]); // copy out of the vm realm for deepStrictEqual
          // Signing must only ever touch the checksum-verified, promoted binary.
          assert.strictEqual(args[args.length - 1], binaryPath);
          if (args[0] === '--verify' && !signatureValid) throw new Error('invalid signature');
          return;
        }
        downloads++;
        assert.ok(args.includes(`https://github.com/scottymade/mana/releases/download/v${version}/${binaryName}`));
        const destination = args[args.indexOf('-o') + 1];
        assert.strictEqual(destination, path.join(root, 'bin', `${binaryName}.download-123`));
        fs.writeFileSync(destination, payload);
      } };
      assert.ok(['fs', 'path', 'crypto'].includes(name), `unexpected import: ${name}`);
      return require(name);
    };
    const context = {
      require: fixtureRequire,
      module: { exports: {} },
      __dirname: path.join(root, 'scripts'),
      process: { platform: 'darwin', arch: 'arm64', env: {}, pid: 123,
        exit: (code) => { throw new Error(`unexpected exit ${code}`); } },
      console: { log: (...args) => output.push(args.join(' ')),
        warn: (...args) => { throw new Error(args.join(' ')); },
        error: (...args) => { throw new Error(args.join(' ')); } },
    };
    vm.runInNewContext(fs.readFileSync(path.join(__dirname, 'postinstall.js'), 'utf8'), context);
    await context.module.exports.main();
    const installed = fs.readFileSync(path.join(root, 'bin', 'mana-binary'), 'utf8');
    return { binaryPath, codesignCalls, downloads, installed, output, payload };
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
}

test('successful installation prints only its completion message', async () => {
  const result = await runFixtureInstall({ signatureValid: true });
  assert.strictEqual(result.downloads, 1);
  assert.strictEqual(result.installed, result.payload);
  assert.deepStrictEqual(result.output, ['  Installation complete!']);
});

test('macOS binary with a valid signature is left untouched', async () => {
  const result = await runFixtureInstall({ signatureValid: true });
  assert.deepStrictEqual(result.codesignCalls, [['--verify', '--strict', result.binaryPath]]);
});

test('macOS binary with an invalid signature is ad-hoc re-signed before use', async () => {
  // macOS 27+ SIGKILLs binaries with invalid signatures ("zsh: killed"), so an
  // unsigned release asset must be repaired at install time, not left broken.
  const result = await runFixtureInstall({ signatureValid: false });
  assert.deepStrictEqual(result.codesignCalls, [
    ['--verify', '--strict', result.binaryPath],
    ['--force', '--sign', '-', result.binaryPath],
  ]);
  assert.deepStrictEqual(result.output, ['  Installation complete!']);
});
