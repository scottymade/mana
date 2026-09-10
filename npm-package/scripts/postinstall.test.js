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

test('successful installation prints only its completion message', async () => {
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
    let downloads = 0;
    const fixtureRequire = (name) => {
      if (name === '../package.json') return { version };
      if (name === 'child_process') return { execFileSync: (_command, args) => {
        downloads++;
        assert.ok(args.includes(`https://github.com/scottymade/mana/releases/download/v${version}/${binaryName}`));
        const destination = args[args.indexOf('-o') + 1];
        assert.strictEqual(destination, path.join(root, 'bin', `${binaryName}.download-123`));
        fs.writeFileSync(destination, payload);
      } };
      assert.ok(['fs', 'path', 'crypto'].includes(name), `unexpected import: ${name}`);
      return require(name);
    };
    // Run the actual installer against an owned fixture; never invoke curl,
    // download an executable, or touch the installed Mana/configuration.
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
    assert.strictEqual(downloads, 1);
    assert.strictEqual(fs.readFileSync(path.join(root, 'bin', 'mana-binary'), 'utf8'), payload);
    assert.deepStrictEqual(output, [
      'MANA: Installation complete!\n',
    ]);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
});
