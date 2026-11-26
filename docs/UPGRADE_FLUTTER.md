### 手順

1. `mise use flutter@<upgrade version>` を実行
   - 例: `mise use flutter@3.29.3`
   - `mise.toml` と一緒に `mise.lock` も更新されるので、両方をコミットする
2. `mise use -g flutter@<upgrade version>` を実行
3. VS Code を使っている場合は、ウィンドウをリロードする
   - mise-vscode が `.vscode/mise-tools/flutter` を新しい SDK に張り替え、リロード後に Dart 拡張がその SDK を読み込む
4. ルートの `pubspec.yaml` の `sdk` バージョンを更新
5. ルートの `pubspec.yaml` の `melos` > `command` > `bootstrap` > `environment` にある `sdk`, `flutter` のバージョンを更新

```yaml
melos:
  command:
    bootstrap:
      environment:
        sdk: ^x.x.x
        flutter: ^x.x.x
```

> [!NOTE]
> `analysis_options.yaml`でyumemi_lintsのルールバージョンの更新が必要です。手順 7 の`dart run melos run update:yumemi_lints --no-select`で更新されます。更新を忘れると、CI の diff-gen が失敗します。
>
> ```yaml
> include: package:yumemi_lints/flutter/x.x.x/recommended.yaml
> ```
>
> ただしyumemi_lints自体のバージョンが古くて最新Flutterバージョンに対応していない場合があるので、その場合はyumemi_lintsを更新してください。

6. `dart run melos bootstrap`コマンドを実行
7. `dart run melos run update:yumemi_lints --no-select`コマンドを実行
8. iOS でアプリが起動できることを確認
9. Android でアプリが起動できることを確認
10. [Migration Guide](https://docs.flutter.dev/release/breaking-changes) に従い、必要に応じて deprecate 箇所を修正

### 注意ポイント

- iOS Simulator や Android Emulator だけでなく、実機も動作することを確認
- Flutter 側だけでなく、 Android・iOS 側で利用しているパッケージ・プラグイン・ライブラリの更新が必要ないか確認
