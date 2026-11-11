---
title: "[初期セットアップ（任意）] multi_device_preview で複数の端末サイズを同時に確認できるようにする"
labels:
  - initialization
  - optional
---

# multi_device_preview の導入

この Issue の対応は任意です。

[multi_device_preview](https://pub.dev/packages/multi_device_preview) を導入すると、アプリを複数の端末サイズ・文字サイズで 1 つの macOS ウィンドウに並べて動かせます。

- 1 台目への操作（タップ・スクロール・文字入力）が、ほかの端末の同じ要素にも送られる。レイアウト崩れや文字のはみ出しを全サイズで同時に確認できる
- App Store 用のスクリーンショットを、端末ごとの正確なピクセルサイズで保存できる（ステータスバーの時刻は既定で `9:41`）
- Marionette MCP を使えば AI エージェントからも操作できる

実機での確認の代わりにはなりません。ネイティブ UI・WebView・ソフトウェアキーボードは対象外です。

この手順は multi_device_preview 1.3.0 以上を前提にしています（GlobalKey が共有されたときのログや、`init` が `ProviderScope`・`TranslationProvider` の中からルート Widget を見つける動作は 1.3.0 からです）。

## 1. アプリ側の GlobalKey を直す

全端末が 1 つのプロセスで動くため、グローバル変数や static フィールドに置いた `GlobalKey` は全端末で共有されてしまいます。テンプレートには該当するキーが 2 つあるので、先に直してください（背景は [ymm-oss/flutter-mobile-project-template#725](https://github.com/ymm-oss/flutter-mobile-project-template/issues/725)）。直さないと、起動直後から `Multiple widgets used the same GlobalKey` と `ProviderScope was rebuilt with a different ProviderScope ancestor` が出続けます。

どちらの変更も、通常のアプリとしての動作は変わりません。

### `rootNavigatorKey` を削除する

debug ルート（`/debug` 配下）はトップレベルのルートなので、`$parentNavigatorKey` がなくてもルートの Navigator に積まれます。`GoRouter` はキーを渡さなければ自前で作ります。

- `apps/app/lib/router/router.dart`: `rootNavigatorKey` の定義と `navigatorKey: rootNavigatorKey` を削除する
- `apps/app/lib/debug/routes/debug_page_route.dart`: 3 つの `static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;` を削除する

コードの生成は、次の `SnackBarManager` の変更のあとにまとめて行います。

shell の中のルートを全画面で出したいなどで、ルートの Navigator のキーが必要になったときは、グローバル変数ではなく `routerProvider` の中で作ってください。

### `SnackBarManager` のキーを ProviderScope ごとにする

`SnackBarManager.rootScaffoldMessengerKey` は static なので、キーを Provider で持つ形に変えます。`ProviderScope` ごとに 1 つ作られるので、端末ごとに別のキーになります。

`apps/app/lib/presentation/providers/scaffold_messenger_key_provider.dart` を追加します。

```dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scaffold_messenger_key_provider.g.dart';

/// `MaterialApp` の `ScaffoldMessenger` のキー。
///
/// `ProviderScope` ごとに 1 つ作られるため、アプリのインスタンスを同時に複数動かしても
/// キーが共有されない。
@Riverpod(keepAlive: true)
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey(Ref ref) =>
    GlobalKey<ScaffoldMessengerState>();
```

`apps/app/lib/main.dart` で、このキーを使います。`SnackBarManager` の import は不要になります。

```dart
import 'package:flutter_app/presentation/providers/scaffold_messenger_key_provider.dart';

// 強制アップデートの通知
ref.read(scaffoldMessengerKeyProvider).currentState
  ?..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(message)));

// MaterialApp.router
scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
```

`packages/debug/lib/src/ui/debug_page.dart` は `MaterialApp` の下にあるので、`ScaffoldMessenger.of(context)` で出せます。

```dart
ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(content: Text('An error occurred: ${value.error}')),
  );
```

ほかに呼び出し元がなければ、`packages/util_ui/lib/snack_bar_manager.dart` は削除して構いません。`scaffoldMessengerKey` の指定を外すだけだと SnackBar が出なくなるので注意してください。

### コードを生成し直す

2 つの変更を入れたら、コードを生成します。`scaffold_messenger_key_provider.g.dart` が作られ、go_router の `*.g.dart` から `parentNavigatorKey` の指定が消えます。生成するまでは `scaffoldMessengerKeyProvider` が無いため、コンパイルできません（`mise run bootstrap` では生成されません）。

```sh
cd apps/app
dart run build_runner build
```

## 2. ホストアプリを作る

パッケージが推奨する「別ホストアプリ」の方式で導入します。`apps/app` には `macos/` を追加せず、`apps/app_preview` に macOS 専用のホストアプリを作ります。

```sh
cd apps/app
flutter pub add dev:multi_device_preview:^1.3.0
dart run multi_device_preview:init --host ../app_preview
```

`init` が行うこと:

- `apps/app_preview` を作成する（assets の宣言とシンボリックリンクも用意する）
- `apps/app_preview/pubspec.yaml` に次を書く
  - `dependencies` に `flutter_app`（`apps/app` への path 依存）と `multi_device_preview`（`apps/app` の dev_dependencies と同じバージョン指定）。`apps/app` の dev_dependencies はホストからは見えないため、ホスト側の `dependencies` に入れる
  - `apps/app` が使っている `flutter_riverpod`
  - `resolution: workspace`（workspace のメンバーに必要）
- `flutter create` が入れる `flutter_lints` と `analysis_options.yaml` を外し、workspace の lint 設定に従わせる
- `lib/main.dart` にエントリポイントの雛形を書く
- macOS の entitlements を設定する（sandbox 無効・ネットワーク・JIT）

## 3. workspace に追加する

ルートの `pubspec.yaml` の `workspace:` に `apps/app_preview` を追加し、bootstrap します。

```yaml
workspace:
  # apps
  - apps/app
  - apps/app_preview # 追加
  - apps/catalog
  # packages
  # ...（ほかのメンバーはそのまま）
```

```sh
mise run bootstrap
```

次の変更をコミットしてください。

- `apps/app_preview/`
- `apps/app/pubspec.yaml`（`multi_device_preview` の dev 依存）
- ルートの `pubspec.yaml` と `pubspec.lock`（CI は `flutter pub get --enforce-lockfile` で依存を解決するため、ロックファイルがコミットされていないと失敗します）
- `.github/labeler.yml` と `.github/labels.yml`（bootstrap で `@apps/app_preview` が追加されます。PR のラベル付けに使います）

## 4. エントリポイントを仕上げる

`init` は `apps/app/lib/main.dart` の `runApp` から雛形を作ります。ただし `main()` で行っている初期化は、エントリポイント側でも同じように行う必要があります。`apps/app_preview/lib/main.dart` を次のように仕上げてください。

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_app/app_initializer.dart';
import 'package:flutter_app/debug/debug_features_impl.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/presentation/providers/debug_features_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internal_design_ui/i18n.dart';
import 'package:multi_device_preview/multi_device_preview.dart';

Future<void> main() async {
  final controller = MultiDevicePreviewController(
    devices: const [
      PreviewDevice(preset: DevicePresets.iPhone17),
      PreviewDevice(preset: DevicePresets.iPhoneSe3),
      PreviewDevice(preset: DevicePresets.iPhoneSe3, textScale: 1.5),
      PreviewDevice(preset: DevicePresets.pixel9),
    ],
  );
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();

  // 全端末で共有する初期化（SharedPreferences・PackageInfo など）
  final (:overrideProviders) = await AppInitializer.initialize();

  runMultiDevicePreview(
    controller: controller,
    // slang の TranslationProvider は GlobalKey を持つため、全端末の上に 1 つだけ置く
    wrapper: (child) => TranslationProvider(child: child),
    // 端末ごとに呼ばれる。ProviderScope も端末ごとに作り、状態を分ける
    appBuilder: (context, slot) {
      final debugFeatures = createDebugFeatures();
      return ProviderScope(
        overrides: [
          ...overrideProviders,
          debugFeaturesProvider.overrideWithValue(debugFeatures),
          ...debugFeatures.overrides,
        ],
        observers: debugFeatures.observers,
        retry: (_, _) => null,
        child: const MainApp(),
      );
    },
  );
}
```

エントリポイントが import するパッケージのうち、`init` が追加しない `internal_design_ui` を `apps/app_preview/pubspec.yaml` の `dependencies` に追加します。

```sh
cd apps/app_preview
flutter pub add 'internal_design_ui:{"path":"../../packages/design_ui"}'
```

`apps/app/lib/main.dart` との違いは次のとおりです。

- `LicenseRegistry.addLicense` は、プレビューではライセンス画面を確認しないので省略している。必要なら同じ処理を足す
- `createDebugFeatures()` を `kDebugMode` のガードなしで呼んでいる。`apps/app/lib/debug/debug_features.dart` は、リリースビルドから tree shaking で除外するために `kDebugMode` でガードして呼ぶ前提だが、このホストは `flutter run` でのプレビュー専用で、リリースビルドは作らないため

`apps/app/lib/main.dart` で override や初期化を増やしたときは、このエントリポイントにも同じ変更を入れてください（入れないと、override が前提のプロバイダが `UnimplementedError` を投げます）。

## 5. 起動する

`BuildConfig` は flavor を `--dart-define` から読むため、`apps/app` と同じく flavor ファイルを渡します。

```sh
cd apps/app_preview
flutter run -d macos --dart-define-from-file=../app/flavor/dev.json
```

ツールバーからは、端末の追加・変更、文字サイズの変更、同期のオン/オフ、全端末の再起動、スクリーンショットの保存ができます。デバッグメニュー（Shift+D）は 1 台目で開きます。

## 6. （任意）AI エージェントから操作できるようにする

[multi_device_preview_marionette](https://pub.dev/packages/multi_device_preview_marionette) を追加すると、Marionette MCP からプレビューを操作できます。

```sh
cd apps/app_preview
flutter pub add multi_device_preview_marionette marionette_flutter
```

`main()` の先頭（`WidgetsFlutterBinding.ensureInitialized()` より前）で Marionette を初期化します。

```dart
import 'package:flutter/foundation.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:multi_device_preview_marionette/multi_device_preview_marionette.dart';

Future<void> main() async {
  final controller = MultiDevicePreviewController(devices: const [/* ... */]);
  if (!kReleaseMode) {
    MarionetteBinding.ensureInitialized(
      multiDevicePreviewMarionetteConfiguration,
    );
    registerMultiDevicePreviewMarionetteExtensions(controller);
  }
  WidgetsFlutterBinding.ensureInitialized();
  // ...
}
```

## 注意点

全端末が 1 つのプロセスで動くため、次の制約があります（詳しくは [Requirements for your app](https://pub.dev/packages/multi_device_preview#requirements-for-your-app)）。

- **グローバル変数や static フィールドに置いた `GlobalKey` は使えない**: 全端末で共有されてしまい、`Multiple widgets used the same GlobalKey` が出ます。どのキーが原因かと対処法はログに表示されます。手順 1 のあとにキーを追加するときも、アプリのインスタンスごと（Provider や `routerProvider` の中など）に作ってください
- **永続化した状態は全端末で共有される**: SharedPreferences・Keychain・ファイル（テーマ設定・ログイン状態など）
- **macOS 実装がないプラグインは呼び出しに失敗する**: 計測・クラッシュ収集・プッシュ通知などの SDK を追加したら、エントリポイントでは初期化しないか、`MissingPluginException` を握りつぶしてください
