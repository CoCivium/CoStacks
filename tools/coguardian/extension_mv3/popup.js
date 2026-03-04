const hb = document.getElementById('hb');
const status = document.getElementById('status');

chrome.storage.local.get(['lastHeartbeatUtc'], (v) => {
  hb.textContent = (v && v.lastHeartbeatUtc) ? v.lastHeartbeatUtc : 'n/a';
  status.textContent = 'active';
});

document.getElementById('openDocs').addEventListener('click', async () => {
  await chrome.tabs.create({ url: 'https://github.com/CoCivium/CoStacks/blob/main/docs/COHEALTH__LATEST.md' });
});

document.getElementById('openRepo').addEventListener('click', async () => {
  await chrome.tabs.create({ url: 'https://github.com/CoCivium/CoStacks' });
});