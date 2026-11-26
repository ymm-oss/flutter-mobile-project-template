// モックサーバーの管理画面。operation ごとに、正常系か異常系の応答と、遅延を設定する。
// 応答は、仕様書のステータスコードを選んで example を編集欄に入れ、必要なら編集する。
// 編集しなければ、仕様書の応答を返す。
// ビルドせずに動くよう、ブラウザーの標準の機能だけで書く。

const api = "api/operations";

const elements = {
  status: document.getElementById("status"),
  operations: document.getElementById("operations"),
  editor: document.getElementById("editor"),
  title: document.getElementById("editor-title"),
  form: document.getElementById("settings-form"),
  statusSelect: document.getElementById("status-select"),
  customStatusLabel: document.getElementById("custom-status-label"),
  responseStatus: document.getElementById("response-status"),
  responseContentType: document.getElementById("response-content-type"),
  responseBody: document.getElementById("response-body"),
  delay: document.getElementById("delay"),
  reset: document.getElementById("reset"),
  resetAll: document.getElementById("reset-all"),
};

const defaultContentType = "application/json; charset=utf-8";

// ステータスコードの選択肢で、仕様書にないコードを入力するときの値。
const otherStatus = "other";

// 最後に編集欄に入れた仕様書の応答。編集したかどうかを、これと比べて決める。
let filled = null;

let operations = [];
// 選んでいる operation のキー。再読み込みしても同じ operation を開けるよう、URL の # に置く。
let selectedKey = decodeURIComponent(location.hash.slice(1));

function showStatus(message, { error = false } = {}) {
  elements.status.textContent = message;
  elements.status.classList.toggle("error", error);
}

async function request(method, path, body) {
  const response = await fetch(path, {
    method,
    headers: body === undefined ? {} : { "content-type": "application/json" },
    body: body === undefined ? undefined : JSON.stringify(body),
  });
  if (response.status === 204) {
    return null;
  }
  const json = await response.json();
  if (!response.ok) {
    throw new Error(json.message ?? `${response.status} が返りました。`);
  }
  return json;
}

function operationPath(key) {
  return `${api}/${encodeURIComponent(key)}`;
}

function isChanged(settings) {
  return settings.response !== null || settings.delayMs !== 0;
}

function replaceOperation(updated) {
  operations = operations.map((operation) => (operation.key === updated.key ? updated : operation));
}

function renderList() {
  elements.operations.replaceChildren(
    ...operations.map((operation) => {
      const button = document.createElement("button");
      button.type = "button";
      button.setAttribute("aria-current", String(operation.key === selectedKey));
      button.classList.toggle("changed", isChanged(operation.settings));
      const method = document.createElement("span");
      method.className = "method";
      method.textContent = operation.method;
      const path = document.createElement("span");
      path.textContent = operation.path;
      button.append(method, path);
      if (operation.operationId) {
        const id = document.createElement("span");
        id.className = "operation-id";
        id.textContent = operation.operationId;
        button.append(id);
      }
      button.addEventListener("click", () => select(operation.key));
      const item = document.createElement("li");
      item.append(button);
      return item;
    }),
  );
}

// JSON の本文は、編集しやすいよう字下げして表示する。
function formatBody(body, contentType) {
  if (body === null || body === undefined) {
    return "";
  }
  if (!/json/i.test(contentType ?? "")) {
    return body;
  }
  try {
    return JSON.stringify(JSON.parse(body), null, 2);
  } catch {
    return body;
  }
}

function selectedOperation() {
  return operations.find((operation) => operation.key === selectedKey);
}

function isError() {
  return elements.form.elements.kind.value === "error";
}

function isErrorStatus(statusCode) {
  return statusCode < 200 || statusCode > 299;
}

// 正常系か異常系の、仕様書にある応答。
function specResponses(operation) {
  if (isError()) {
    return operation.errorResponses;
  }
  return operation.response.statusCode == null ? [] : [operation.response];
}

function specResponseOf(operation, statusCode) {
  return specResponses(operation).find((response) => response.statusCode === statusCode);
}

// [statusCode] の仕様書の応答を編集欄に入れる。仕様書になければ、空の応答を入れる。
function fillFromSpec(operation, statusCode) {
  const spec = specResponseOf(operation, statusCode);
  const contentType = spec?.contentType ?? defaultContentType;
  let body = spec?.body ?? "";
  if (!spec && isError()) {
    body = '{\n  "message": ""\n}';
  }
  fillEditedResponse(operation, { statusCode, contentType, body });
  filled = {
    contentType: elements.responseContentType.value,
    body: elements.responseBody.value,
  };
}

// 正常系と異常系を切り替えたときは、仕様書の最初の応答を入れる。
function fillFirstSpec(operation) {
  const first = specResponses(operation)[0];
  fillFromSpec(operation, first?.statusCode ?? (isError() ? 500 : 200));
}

function fillEditedResponse(operation, { statusCode, contentType, body }) {
  setStatusCode(operation, statusCode);
  elements.responseContentType.value = contentType;
  elements.responseBody.value = formatBody(body, contentType);
}

// JSON の本文は、字下げの違いを無視して比べる。
function sameBody(a, b, contentType) {
  if (/json/i.test(contentType)) {
    try {
      return JSON.stringify(JSON.parse(a)) === JSON.stringify(JSON.parse(b));
    } catch {
      // JSON として読めなければ、文字列のまま比べる。
    }
  }
  return a === b;
}

function isEdited() {
  const contentType = elements.responseContentType.value;
  return (
    filled === null ||
    contentType !== filled.contentType ||
    !sameBody(elements.responseBody.value, filled.body, contentType)
  );
}

function currentStatusCode() {
  const value = elements.statusSelect.value;
  return Number(value === otherStatus ? elements.responseStatus.value : value);
}

// 仕様書にあるコードなら選択肢から選び、なければ「そのほか」に入力する。
function setStatusCode(operation, statusCode) {
  const spec = specResponseOf(operation, statusCode);
  elements.statusSelect.value = spec ? `${statusCode}` : otherStatus;
  elements.responseStatus.value = spec ? "" : statusCode;
  updateCustomStatus();
}

function updateCustomStatus() {
  const custom = elements.statusSelect.value === otherStatus;
  elements.customStatusLabel.hidden = !custom;
  // 隠した入力欄は、フォームの検査から外す。
  elements.responseStatus.disabled = !custom;
}

function renderStatusOptions(operation) {
  const options = [
    ...specResponses(operation).map((response) => [
      `${response.statusCode}`,
      [response.statusCode, response.description].filter(Boolean).join(" "),
    ]),
    [otherStatus, "そのほか（入力する）"],
  ];
  elements.statusSelect.replaceChildren(
    ...options.map(([value, label]) => {
      const option = document.createElement("option");
      option.value = value;
      option.textContent = label;
      return option;
    }),
  );
}

// example がない仕様書の応答を選んでいるときは、空のまま保存すると 501 を返すことを示す。
function updateBodyPlaceholder(operation) {
  const spec = specResponseOf(operation, currentStatusCode());
  elements.responseBody.placeholder = spec?.missing
    ? `仕様書に example がないため、空のまま保存すると 501 を返します。\n${spec.missing}`
    : "";
}

function renderEditor() {
  const operation = selectedOperation();
  if (!operation) {
    elements.editor.hidden = true;
    return;
  }
  elements.editor.hidden = false;
  elements.title.textContent = operation.operationId
    ? `${operation.key}（${operation.operationId}）`
    : operation.key;

  const { response } = operation.settings;
  const error =
    response?.type === "specError" ||
    (response?.type === "edited" && isErrorStatus(response.statusCode));
  elements.form.elements.kind.value = error ? "error" : "success";
  updateKind(operation);
  if (response?.type === "edited") {
    fillEditedResponse(operation, response);
    filled = null;
  } else if (response?.type === "specError") {
    fillFromSpec(operation, response.statusCode);
  } else {
    fillFirstSpec(operation);
  }
  updateBodyPlaceholder(operation);
  elements.delay.value = operation.settings.delayMs;
}

function updateKind(operation) {
  const error = isError();
  elements.responseStatus.min = error ? 300 : 200;
  elements.responseStatus.max = error ? 599 : 299;
  renderStatusOptions(operation);
}

function select(key) {
  selectedKey = key;
  history.replaceState(null, "", `#${encodeURIComponent(key)}`);
  showStatus("");
  renderList();
  renderEditor();
}

function readEditedResponse() {
  return {
    statusCode: currentStatusCode(),
    contentType: elements.responseContentType.value,
    body: elements.responseBody.value,
  };
}

function readResponse() {
  const operation = selectedOperation();
  const edited = readEditedResponse();
  if (!Number.isInteger(edited.statusCode) || isErrorStatus(edited.statusCode) !== isError()) {
    throw new Error(
      isError()
        ? "異常系のステータスコードには 300 から 599 を指定してください。"
        : "正常系のステータスコードには 200 から 299 を指定してください。",
    );
  }
  const spec = specResponseOf(operation, edited.statusCode);
  // example がない仕様書の応答は、本文が空なら編集していないものとして扱う。
  const unchanged = spec?.missing ? edited.body.trim() === "" : spec && !isEdited();
  if (!unchanged) {
    return { type: "edited", ...edited };
  }
  return isError() ? { type: "specError", statusCode: spec.statusCode } : null;
}

function readSettings() {
  return { response: readResponse(), delayMs: Number(elements.delay.value) };
}

async function run(action, message) {
  try {
    await action();
    showStatus(message);
  } catch (error) {
    showStatus(error.message, { error: true });
  }
}

async function load() {
  const json = await request("GET", api);
  operations = json.operations;
  renderList();
  renderEditor();
}

// 正常系と異常系を切り替えたときは、仕様書の最初の応答を編集欄に入れ直す。
elements.form.addEventListener("change", (event) => {
  const operation = selectedOperation();
  if (operation && event.target.name === "kind") {
    updateKind(operation);
    fillFirstSpec(operation);
    updateBodyPlaceholder(operation);
  }
});

// 仕様書のステータスコードを選んだときは、その応答を編集欄に入れる。
// 「そのほか」を選んだときは、編集欄をそのままにして、コードを入力してもらう。
elements.statusSelect.addEventListener("change", () => {
  const operation = selectedOperation();
  if (!operation) {
    return;
  }
  if (elements.statusSelect.value === otherStatus) {
    updateCustomStatus();
    elements.responseStatus.focus();
  } else {
    fillFromSpec(operation, Number(elements.statusSelect.value));
  }
  updateBodyPlaceholder(operation);
});

elements.form.addEventListener("submit", (event) => {
  event.preventDefault();
  run(async () => {
    replaceOperation(await request("PUT", operationPath(selectedKey), readSettings()));
    renderList();
    renderEditor();
  }, "保存しました。");
});

elements.reset.addEventListener("click", () => {
  run(async () => {
    replaceOperation(await request("DELETE", operationPath(selectedKey)));
    renderList();
    renderEditor();
  }, "既定に戻しました。");
});

elements.resetAll.addEventListener("click", () => {
  run(async () => {
    await request("DELETE", api);
    await load();
  }, "すべての operation を既定に戻しました。");
});

run(load, "");
