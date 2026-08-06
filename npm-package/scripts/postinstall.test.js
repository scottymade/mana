const assert = require('assert');
const fs = require('fs');
const os = require('os');
const path = require('path');
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
