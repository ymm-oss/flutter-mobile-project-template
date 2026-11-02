### 手順

1. `mise use flutter@<upgrade version>` を実行
   - 例: `mise use flutter@3.29.3`
2. `mise use -g flutter@<upgrade version>` を実行
3. ルートの `.vscode/settings.json` の `dart.flutterSdkPath`,`dart.sdkPath` を更新
4. ルートの `pubspec.yaml` の `sdk` バージョンを更新
5. `melos.yaml` の `bootstrap` にある `sdk`, `flutter` 部分のバージョンを更新

```yaml
command:
  bootstrap:
    environment:
      sdk: ^x.x.x
      flutter: ^x.x.x
```

> [!NOTE]
> `analysis_options.yaml`でyumemi_lintsのルールバージョンの更新が必要ですが、こちらは`dart run melos bootstrap`のpost hooksで自動化的に更新されます。
>
> ```yaml
> include: package:yumemi_lints/flutter/x.x.x/recommended.yaml
> ```
>
> ただしyumemi_lints自体のバージョンが古くて最新Flutterバージョンに対応していない場合があるので、その場合はyumemi_lintsを更新してください。

4. `dart run melos bootstrap`コマンドを実行
5. iOS でアプリが起動できることを確認
6. Android でアプリが起動できることを確認
7. [Migration Guide](https://docs.flutter.dev/release/breaking-changes) に従い、必要に応じて deprecate 箇所を修正

### 注意ポイント

- iOS Simulator や Android Emulator だけでなく、実機も動作することを確認
- Flutter 側だけでなく、 Android・iOS 側で利用しているパッケージ・プラグイン・ライブラリの更新が必要ないか確認
