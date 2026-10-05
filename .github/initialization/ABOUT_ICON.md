---
title: "[初期セットアップ] アイコンの設定"
labels: initialization
---

## アイコンについて

### iOS

- iOSのアイコンの場合、Apple Storeで使用されている画像サイズは1024x1024で、それ以外のサイズの場合は[flutter_launcher_icons]が自動的に小さいものを生成します。
- アイコンのサイズは1024x1024以下でも問題ありませんが、小さすぎると画質が悪いアイコンになる可能性があります。

### Android

- Adaptive Launcher IconsはAndroid 8.0（APIレベル26）で導入され、デバイスの種類ごとに異なる形で表示できるようになりました。
  - `adaptive_icon_foreground`
    - ロゴまたはアイコン画像
    - 画像のサイズは1024x1024。
    - アイコンの大きさは画像の大きさの0.67倍程度にすると収まりが良い。

  - `adaptive_icon_background`
    - アイコンの背景画像
    - カラーコードまたは背景画像が必須。
    - 画像のサイズは1024x1024。

- 以下の表には、特定のアイコンが含まれています。画像には枠線がありますが、視認性のためにつけているだけで、アイコンを追加する際には枠線は必要ありません。
- 詳しい説明は[adaptive icon guide]を確認してください。

|                                                          `adaptive_icon_foreground`                                                          |                                                          `adaptive_icon_background`                                                          |
| :------------------------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------------------------: |
| <img src="https://github.com/ymm-oss/flutter-mobile-project-template/assets/67954894/0d1e1559-1600-4c12-aea6-2b4b234c7f41" width="300" /> | <img src="https://github.com/ymm-oss/flutter-mobile-project-template/assets/67954894/521be3f1-945c-4c08-9c81-6f612679801c" width="300" /> |

<!-- Links -->

[flutter_launcher_icons]: https://pub.dev/packages/flutter_launcher_icons
[adaptive icon guide]: https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive?hl=ja
