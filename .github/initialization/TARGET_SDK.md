---
title: "[初期セットアップ] Target SDK の設定"
labels: initialization
---

# Target SDK バージョンの設定

このIssueは、FlutterプロジェクトでサポートするOSバージョン（Target SDK）を適切に設定するためのものです。
OSのバージョン指定は、アプリが利用できる機能や、ストアでの公開、ユーザーの利用体験に影響します。

## 背景

### iOS

- **iOS Deployment Target**: Xcodeプロジェクト設定で指定する、アプリが動作する最も古いiOSバージョンです。Flutterフレームワーク自体がサポートする最小iOSバージョン（例: iOS 15.0）より低いバージョンを指定すると、ビルドエラーや実行時エラーが発生する可能性があります。

<img src="https://github.com/user-attachments/assets/3e315659-e74e-4de7-ba9c-1bbb6761ce61" width="500" />

- **Minimum Deployments**: アプリがサポートする最小OSバージョンを示します。

<img src="https://github.com/user-attachments/assets/532c25bf-4a74-410f-a62c-33437e5c37ad" width="500" />

### Android

- **targetSdkVersion**: アプリがテストされ、最適化されているAndroid APIレベルを指定します。Google Playストアでは、最新に近い `targetSdkVersion` の設定が推奨されており、古いバージョンだと警告が表示されたり、将来的に公開できなくなる可能性があります。

- **minSdkVersion**: アプリが動作する最も古いAndroid APIレベルを指定します。Flutter自体も最小要件があり、また、利用するプラグインによってはより新しいAPIレベルが必要になることがあります。

```kotlin
// android/app/build.gradle.kts

android {
        ...
    defaultConfig {
        ...
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        ...
    }
```

- **compileSdkVersion**: アプリのコンパイルに使用するAndroid SDKのバージョンです。通常、`targetSdkVersion` と同じかそれ以上の最新バージョンを指定します。

```kotlin
// android/app/build.gradle.kts

android {
    ...
    compileSdk = flutter.compileSdkVersion
```

### 補足

- `flutter.minSdkVersion` や `flutter.targetSdkVersion`等の設定値は**packages/flutter_tools/gradle/src/main/kotlin/FlutterExtension.kt**に記載されています。

```kotlin
// Mise を使用している場合
// <USER_PATH>/.local/share/mise/installs/flutter/<FLUTTER_VERSION>/packages/flutter_tools/gradle/src/main/kotlin/FlutterExtension.kt

open class FlutterExtension {
    /** Sets the compileSdkVersion used by default in Flutter app projects. */
    val compileSdkVersion: Int = 35

    /** Sets the minSdkVersion used by default in Flutter app projects. */
    val minSdkVersion: Int = 21

    /**
     * Sets the targetSdkVersion used by default in Flutter app projects.
     * targetSdkVersion should always be the latest available stable version.
     *
     * See https://developer.android.com/guide/topics/manifest/uses-sdk-element.
     */
    val targetSdkVersion: Int = 35

    /**
```

## Todo

以下の設定値を確認し、プロジェクトの要件に合わせて更新してください。

### iOS

- [ ] **iOS Deployment Target の更新:**
  - Xcodeで `Runner` > `Build Settings` > `All` >`Deployment` > `iOS Deployment Target` を設定します。

- [ ] **Minimum Deployments の更新**

### Android

- [ ] **targetSdkVersion の更新:**
  - **考慮事項:** Google Playの最新要件、新機能の利用、セキュリティパッチの適用。通常は最新の安定版APIレベルに設定します。
- [ ] **minSdkVersionの更新:**
- [ ] **compileSdkVersionの更新:**

## 推奨事項

- **iOS:** Appleは最新のOSへのアップデートを推奨しています。Flutterのサポート範囲内で、可能な限り新しいバージョンを `iOS Deployment Target` とすることが一般的です。
- **Android:** Google Play Consoleの要件を確認し、`targetSdkVersion` は定期的に最新のものに追従することが重要です。`minSdkVersion` は、プロジェクトのターゲットユーザー層と、サポートする機能のバランスを考慮して決定します。

## ドキュメント更新

- [ ] プロジェクトの `README.md` や関連ドキュメントに、設定したiOS Deployment Target, Android `minSdkVersion`, `targetSdkVersion` を記載します。

**全てのタスクが完了したら、このIssueを閉じてください。**
