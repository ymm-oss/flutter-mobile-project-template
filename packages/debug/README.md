# internal_debug package

デバッグ画面などのデバッグビルド専用の機能を提供するパッケージです。

## リリースビルドからの除外

デバッグ画面には検証用の操作や文字列リテラルが含まれるため、UI 上の動線を消すだけでなく、リリースビルドのバイナリからコード自体を除外しています。

- `apps/app` では、このパッケージを `dev_dependencies` に定義しています。
- このパッケージを参照してよいのは `apps/app/lib/debug/debug_features_impl.dart` のみです。
  - アプリの他のコードは、`DebugFeatures` インターフェース（`apps/app/lib/debug/debug_features.dart`）と `debugFeaturesProvider` を通してデバッグ機能を利用します。
- `DebugFeatures` の実装は `main.dart` で `kDebugMode` がコンパイル時定数であることを利用して生成しています。リリースビルドでは実装への参照が無くなるため、Dart の tree shaking によって除外されます。

除外されていることは、次のコマンドで確認できます。CI でも実行しています。

```shell
melos run check:debug_tree_shaking
```

### 制約

- Flutter が生成する Dart プラグインレジストラントは `dev_dependencies` のプラグインもリリースビルドで登録するため、`shake_gesture` のプラットフォーム実装の登録処理（Dart コード）はリリースビルドに残ります。
- Flutter 3.35 未満では、pub workspace 構成や推移的な依存のプラグインを `dev_dependencies` として判定できないため、`shake_gesture` のネイティブコードもリリースビルドに残ります。
- iOS では Flutter 側の対応が未完了のため、`dev_dependencies` のプラグインがリリースビルドに残ります（[flutter/flutter#163874](https://github.com/flutter/flutter/issues/163874)）。
