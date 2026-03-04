chrome.runtime.onInstalled.addListener(() => {
  chrome.alarms.create("coguardian_heartbeat", { periodInMinutes: 1 });
});
chrome.alarms.onAlarm.addListener((a) => {
  if (a && a.name === "coguardian_heartbeat") {
    chrome.storage.local.set({ lastHeartbeatUtc: new Date().toISOString() });
  }
});