// プロファイル。operation ごとの設定をまとめて名前を付けて保存し、切り替える。
// 共有のプロファイルは読むだけで、保存と削除は自分用のプロファイルにだけ行う。
// admin.js の request、run、showStatus、load を使う。

const profileApi = "api/profiles";

const profileElements = {
  select: document.getElementById("profile-select"),
  apply: document.getElementById("profile-apply"),
  save: document.getElementById("profile-save"),
  delete: document.getElementById("profile-delete"),
};

// 選択肢の値。共有と自分用に同じ名前があっても区別できるよう、種類を付ける。
function profileValue({ name, shared }) {
  return `${shared ? "shared" : "local"}:${name}`;
}

function selectedProfile() {
  const value = profileElements.select.value;
  if (!value) {
    return null;
  }
  const separator = value.indexOf(":");
  return { name: value.slice(separator + 1), shared: value.slice(0, separator) === "shared" };
}

function updateProfileButtons() {
  const profile = selectedProfile();
  profileElements.apply.disabled = profile === null;
  profileElements.delete.disabled = profile === null || profile.shared;
}

async function loadProfiles(selected = selectedProfile()) {
  const { profiles } = await request("GET", profileApi);
  const placeholder = document.createElement("option");
  placeholder.value = "";
  placeholder.textContent = profiles.length === 0 ? "（保存したものはありません）" : "選んでください";
  const groups = [
    ["共有", profiles.filter((profile) => profile.shared)],
    ["自分用", profiles.filter((profile) => !profile.shared)],
  ]
    .filter(([, items]) => items.length > 0)
    .map(([label, items]) => {
      const group = document.createElement("optgroup");
      group.label = label;
      group.append(
        ...items.map((profile) => {
          const option = document.createElement("option");
          option.value = profileValue(profile);
          option.textContent = profile.name;
          return option;
        }),
      );
      return group;
    });
  profileElements.select.replaceChildren(placeholder, ...groups);
  const value = selected ? profileValue(selected) : "";
  profileElements.select.value = profiles.some((profile) => profileValue(profile) === value)
    ? value
    : "";
  updateProfileButtons();
}

function localProfilePath(name) {
  return `${profileApi}/local/${encodeURIComponent(name)}`;
}

profileElements.select.addEventListener("change", updateProfileButtons);

// 適用すると、プロファイルにない operation は既定に戻る。
profileElements.apply.addEventListener("click", () => {
  const profile = selectedProfile();
  if (!profile) {
    return;
  }
  run(async () => {
    const { skipped } = await request("POST", `${profileApi}/apply`, profile);
    await load();
    if (skipped.length > 0) {
      throw new Error(
        `プロファイル「${profile.name}」を適用しました。仕様書と合わない次の設定は読み飛ばしました。` +
          skipped.join(" "),
      );
    }
  }, `プロファイル「${profile.name}」を適用しました。`);
});

profileElements.save.addEventListener("click", () => {
  const current = selectedProfile();
  const name = prompt(
    "今の設定を自分用のプロファイルに保存します。名前を入力してください。同じ名前があれば上書きします。",
    current && !current.shared ? current.name : "",
  );
  if (name === null) {
    return;
  }
  run(async () => {
    const saved = await request("PUT", localProfilePath(name));
    await loadProfiles(saved);
  }, `プロファイル「${name}」を保存しました。`);
});

profileElements.delete.addEventListener("click", () => {
  const profile = selectedProfile();
  if (!profile || profile.shared || !confirm(`プロファイル「${profile.name}」を消します。`)) {
    return;
  }
  run(async () => {
    await request("DELETE", localProfilePath(profile.name));
    await loadProfiles(null);
  }, `プロファイル「${profile.name}」を消しました。`);
});
