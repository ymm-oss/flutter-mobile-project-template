// 通信タブ。モックサーバーが受けたリクエストと返した応答を、新しいものから一覧にする。
// 一覧は 1 秒ごとに差分だけを読み、中身は 1 件を選んだときに読む。
// admin.js の request、showStatus、formatBody、openOperation を使う。

const trafficApi = "api/traffic";

// サーバーが持つ件数と同じにする。
const trafficMaxEntries = 200;

const trafficPollMs = 1000;

const sourceLabels = {
  spec: "仕様書",
  edited: "編集した応答",
  specError: "仕様書の異常系",
  unmatched: "仕様書にない",
};

const trafficElements = {
  pause: document.getElementById("traffic-pause"),
  clear: document.getElementById("traffic-clear"),
  empty: document.getElementById("traffic-empty"),
  list: document.getElementById("traffic-list"),
  detail: document.getElementById("traffic-detail"),
  title: document.getElementById("traffic-title"),
  meta: document.getElementById("traffic-meta"),
  operation: document.getElementById("traffic-operation"),
  requestHeaders: document.getElementById("traffic-request-headers"),
  requestBody: document.getElementById("traffic-request-body"),
  responseHeaders: document.getElementById("traffic-response-headers"),
  responseBody: document.getElementById("traffic-response-body"),
};

let trafficEntries = [];
let trafficLastId = 0;
let trafficSelectedId = null;
let trafficPaused = false;
let trafficTimer = null;
let trafficOperationKey = null;

function startTraffic() {
  stopTraffic();
  renderTrafficList();
  const tick = async () => {
    if (!trafficPaused) {
      try {
        await pollTraffic();
      } catch (error) {
        showStatus(error.message, { error: true });
      }
    }
    trafficTimer = setTimeout(tick, trafficPollMs);
  };
  tick();
}

function stopTraffic() {
  clearTimeout(trafficTimer);
  trafficTimer = null;
}

async function pollTraffic() {
  const json = await request("GET", `${trafficApi}?after=${trafficLastId}`);
  // サーバーを起動し直すと、id は 1 から振り直される。
  if (json.lastId < trafficLastId) {
    resetTraffic();
    renderTrafficList();
    return pollTraffic();
  }
  trafficLastId = json.lastId;
  // 増えたときだけ描き直し、選んでいる行のフォーカスを保つ。
  if (json.entries.length > 0) {
    trafficEntries = [...trafficEntries, ...json.entries].slice(-trafficMaxEntries);
    renderTrafficList();
  }
}

function resetTraffic() {
  trafficEntries = [];
  trafficLastId = 0;
  trafficSelectedId = null;
  trafficElements.detail.hidden = true;
}

function formatTime(iso) {
  return new Date(iso).toLocaleTimeString(undefined, { hour12: false });
}

function renderTrafficList() {
  trafficElements.empty.hidden = trafficEntries.length > 0;
  trafficElements.list.replaceChildren(
    ...trafficEntries.toReversed().map((entry) => {
      const button = document.createElement("button");
      button.type = "button";
      button.setAttribute("aria-current", String(entry.id === trafficSelectedId));
      const cells = [
        ["time", formatTime(entry.time)],
        ["method", entry.method],
        ["path", entry.path],
        ["status", entry.statusCode],
        ["duration", `${entry.durationMs} ms`],
      ];
      for (const [name, text] of cells) {
        const cell = document.createElement("span");
        cell.className = name;
        cell.textContent = text;
        button.append(cell);
      }
      button.classList.toggle("failed", entry.statusCode >= 400);
      button.addEventListener("click", () => run(() => selectTraffic(entry.id), ""));
      const item = document.createElement("li");
      item.append(button);
      return item;
    }),
  );
}

function headersText(headers) {
  return Object.entries(headers)
    .map(([name, value]) => `${name}: ${value}`)
    .join("\n");
}

function bodyText(body, contentType, truncated) {
  if (body === "") {
    return "（本文なし）";
  }
  const text = truncated ? body : formatBody(body, contentType);
  return truncated ? `${text}\n…（長いため、ここまでを残しています）` : text;
}

async function selectTraffic(id) {
  trafficSelectedId = id;
  renderTrafficList();
  const entry = await request("GET", `${trafficApi}/${id}`);
  trafficElements.detail.hidden = false;
  trafficElements.title.textContent = `${entry.method} ${entry.path}`;
  trafficElements.meta.textContent = [
    formatTime(entry.time),
    `${entry.statusCode}`,
    sourceLabels[entry.source] ?? entry.source,
    `${entry.durationMs} ms`,
    entry.operationKey,
  ]
    .filter(Boolean)
    .join(" / ");
  trafficOperationKey = entry.operationKey;
  trafficElements.operation.hidden = entry.operationKey === null;
  trafficElements.requestHeaders.textContent = headersText(entry.requestHeaders);
  trafficElements.requestBody.textContent = bodyText(
    entry.requestBody,
    entry.requestHeaders["content-type"],
    entry.requestBodyTruncated,
  );
  trafficElements.responseHeaders.textContent = entry.responseContentType
    ? `content-type: ${entry.responseContentType}`
    : "";
  trafficElements.responseBody.textContent = bodyText(
    entry.responseBody,
    entry.responseContentType,
    entry.responseBodyTruncated,
  );
}

trafficElements.pause.addEventListener("click", () => {
  trafficPaused = !trafficPaused;
  trafficElements.pause.setAttribute("aria-pressed", String(trafficPaused));
  trafficElements.pause.textContent = trafficPaused ? "再開" : "一時停止";
});

trafficElements.clear.addEventListener("click", () => {
  run(async () => {
    await request("DELETE", trafficApi);
    resetTraffic();
    renderTrafficList();
  }, "履歴を消しました。");
});

trafficElements.operation.addEventListener("click", () => {
  if (trafficOperationKey !== null) {
    openOperation(trafficOperationKey);
  }
});
