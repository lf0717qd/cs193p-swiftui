
const https = require('https');
const fs = require('fs');
const path = require('path');

const CLIENT_ID = '178c6fc778ccc68e1d6a'; // GitHub CLI OAuth app (public client id)
const SCOPES = 'repo workflow gist read:org';
const TOKEN_FILE = path.join(process.env.TEMP, 'gh-device-token.txt');

function post(form) {
  return new Promise((resolve, reject) => {
    const body = new URLSearchParams(form).toString();
    const req = https.request({
      host: 'github.com', port: 443, path: '/login/oauth/access_token', method: 'POST',
      servername: 'github.com', timeout: 12000,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/x-www-form-urlencoded',
        'content-length': Buffer.byteLength(body),
        'user-agent': 'dsh-device-flow'
      }
    }, (res) => {
      let d = '';
      res.on('data', (c) => d += c);
      res.on('end', () => {
        try { resolve({ status: res.statusCode, json: JSON.parse(d) }); }
        catch { resolve({ status: res.statusCode, json: { error: 'parse_failed', raw: d.slice(0, 300) } }); }
      });
    });
    req.on('timeout', () => req.destroy(new Error('timeout')));
    req.on('error', reject);
    req.end(body);
  });
}

async function requestCode() {
  for (let i = 1; i <= 25; i++) {
    try {
      const r = await post({ client_id: CLIENT_ID, scope: SCOPES });
      if (r.json && r.json.device_code) return r.json;
      console.log('[code attempt ' + i + '] unexpected: ' + JSON.stringify(r.json).slice(0, 200));
    } catch (e) {
      console.log('[code attempt ' + i + '] ' + (e.code || e.message));
    }
    await new Promise((r) => setTimeout(r, 1500));
  }
  return null;
}

(async () => {
  const dc = await requestCode();
  if (!dc) { console.log('FATAL: cannot reach github.com/login/oauth/access_token'); process.exit(2); }

  console.log('=========================================');
  console.log('  ONE-TIME CODE: ' + dc.user_code);
  console.log('  OPEN: ' + dc.verification_uri);
  console.log('  EXPIRES IN: ' + Math.round(dc.expires_in / 60) + ' min');
  console.log('=========================================');

  const deadline = Date.now() + dc.expires_in * 1000;
  let interval = (dc.interval || 5) * 1000;
  let attempt = 0;

  while (Date.now() < deadline) {
    await new Promise((r) => setTimeout(r, interval));
    attempt++;
    let r;
    try {
      r = await post({ client_id: CLIENT_ID, device_code: dc.device_code, grant_type: 'urn:ietf:params:oauth:grant-type:device_code' });
    } catch (e) {
      process.stdout.write('[poll ' + attempt + '] net ' + (e.code || e.message) + ' (retrying)\n');
      continue;
    }
    const j = r.json || {};
    if (j.access_token) {
      fs.writeFileSync(TOKEN_FILE, j.access_token, 'utf8');
      console.log('SUCCESS: token saved, scope=' + (j.scope || '(default)'));
      process.exit(0);
    }
    if (j.error === 'authorization_pending') { process.stdout.write('[poll ' + attempt + '] pending\n'); continue; }
    if (j.error === 'slow_down') { interval += 5000; process.stdout.write('[poll ' + attempt + '] slow_down\n'); continue; }
    console.log('[poll ' + attempt + '] ' + (j.error || 'unknown') + ' ' + JSON.stringify(j).slice(0, 200));
    if (j.error === 'expired_token' || j.error === 'access_denied') process.exit(3);
  }
  console.log('EXPIRED');
  process.exit(4);
})();
