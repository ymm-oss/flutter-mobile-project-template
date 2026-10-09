# アーキテクチャ

> [!TIP]
> 責務範囲はプロジェクトの開始時に議論するべきです。どのように分離するかはプロジェクトによって異なるためです。

## ディレクトリ構造

以下にディレクトリ構造を示します。

```bash
.
├── apps
│   ├── app
│   │   ├── presentation
│   │   └── composition_root
│   └── catalog
│
└── packages
    ├── design_domain_ui # (optional)
    ├── design_ui
    ├── debug
    ├── design_theme
    ├── application
    ├── infrastructure
    ├── domain_model
    ├── domain_logic
    ├── shared
    ├── util_logic
    └── util_ui
```

## レイヤー・パッケージ構造

> [!NOTE]
> Shared, Util, Debug レイヤーは依存の向きを記載しようとすると複雑になってしまうため、記載していません。
>
> - Shared, Util レイヤーはどのレイヤーにも依存しておらず、Shared, Util 以外の全てのレイヤーから参照可能
> - Debug レイヤーは全てのレイヤーに依存可能で、Presentation レイヤーからのみ参照される
>   - リリースビルドから除外するため、`apps/app/lib/debug/debug_features_impl.dart` からのみ参照する（詳細は [internal_debug package](../packages/debug/README.md) を参照）

```mermaid
flowchart TD
  %% Style Definitions
  classDef directory fill:#f0f8ff,stroke:#333,stroke-width:2px,color:#000000;
  classDef package fill:#ffffe0,stroke:#333,stroke-width:2px,color:#000000;
  classDef optional fill:#ffffe0,stroke:#333,stroke-width:2px,stroke-dasharray:5 5,color:#000000;

  %% App Source Code (directly in app source)
  subgraph "App Source Code"
    direction TB
    subgraph "Presentation Layer"
      presentation[presentation]
      class presentation directory
    end
    subgraph "CompositionRoot Layer"
      composition_root[composition_root]
      class composition_root directory
    end
  end

  %% Design Layer
  subgraph "Design Layer"
    design_domain_ui["design_domain_ui (optional)"]
    class design_domain_ui optional

    design_ui[design_ui]
    class design_ui package

    design_theme[design_theme]
    class design_theme package
  end

  %% Application Layer
  subgraph "Application Layer"
    application_pkg[application]
    class application_pkg package
  end

  %% Infrastructure Layer
  subgraph "Infrastructure Layer"
    infrastructure_pkg[infrastructure]
    class infrastructure_pkg package
  end

  %% Domain Layer
  subgraph "Domain Layer"
    domain_model[domain_model]
    class domain_model package

    domain_logic[domain_logic]
    class domain_logic package
  end

  %% Debug Layer
  subgraph "Debug Layer"
    debug[debug]
    class debug package
  end

  %% Shared Layer
  subgraph "Shared Layer"
    shared[shared]
    class shared package
  end

  %% Util Layer
  subgraph "Util Layer"
    util_logic[util_logic]
    class util_logic package

    util_ui[util_ui]
    class util_ui package
  end

  %% Dependencies
  presentation --> composition_root
  presentation --> domain_model
  presentation --> design_theme
  presentation --> design_ui
  presentation --> design_domain_ui

  composition_root --> infrastructure_pkg
  composition_root --> application_pkg
  composition_root --> domain_logic

  application_pkg --> domain_model
  application_pkg --> domain_logic

  infrastructure_pkg --> domain_model
  infrastructure_pkg --> domain_logic

  design_domain_ui --> design_ui
  design_domain_ui --> design_theme
  design_domain_ui --> domain_model

  design_ui --> design_theme

  domain_logic --> domain_model

  %% Debug Layer Dependencies
  presentation --> debug

  %% Legend
  subgraph "Legend"
    dir_legend[Directory]
    class dir_legend directory
    pkg_legend[Package]
    class pkg_legend package
    opt_legend[Optional Package]
    class opt_legend optional
  end
```

## アーキテクチャの詳細

### 設計思想

本プロジェクトでは、**Clean Architecture** と **Composition Root パターン** を組み合わせたアーキテクチャを採用しています。

#### Clean Architecture の原則

このアーキテクチャは以下の原則に基づいて設計されています：

1. **依存関係の逆転**: 上位レイヤーは下位レイヤーに依存し、下位レイヤーは上位レイヤーに依存しない
2. **関心の分離**: 各レイヤーは明確な責務を持ち、他のレイヤーの実装詳細を知らない
3. **テスタビリティ**: 各レイヤーは独立してテスト可能
4. **保守性**: 変更の影響範囲を局所化し、拡張性を確保

#### Composition Root パターン

**Composition Root** は、アプリケーションの依存関係を構成する場所です。このパターンにより、依存関係の注入を一箇所で管理し、アプリケーションの構造を明確にします。

##### 実装場所

```shell
apps/app/lib/composition_root/
├── data_sources/              # データソースの依存関係を定義
├── repositories/              # リポジトリの依存関係を定義
└── use_cases/                 # ユースケースの依存関係を定義
```

##### 実装例

```dart
// composition_root/repositories/theme_setting_repository.dart
@riverpod
ThemeSettingRepository themeSettingRepository(Ref ref) {
  final dataSource = ref.watch(sharedPreferenceDataSourceProvider);
  return ThemeSettingRepositoryImpl(dataSource);
}
```

### 実装コンポーネント図

アーキテクチャの各レイヤーで実装される具体的なコンポーネントとその依存関係を以下の図で示します：

```mermaid
flowchart TD
  %% Style Definitions
  classDef presentation fill:#e1f5fe,stroke:#01579b,stroke-width:2px,color:#000000;
  classDef composition fill:#f3e5f5,stroke:#4a148c,stroke-width:2px,color:#000000;
  classDef application fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px,color:#000000;
  classDef infrastructure fill:#fff3e0,stroke:#e65100,stroke-width:2px,color:#000000;
  classDef domain fill:#fce4ec,stroke:#880e4f,stroke-width:2px,color:#000000;
  classDef design fill:#f1f8e9,stroke:#33691e,stroke-width:2px,color:#000000;

  %% Presentation Layer
  subgraph "Presentation Layer"
    UI[UI Components]
    Providers[State Providers]
    class UI presentation
    class Providers presentation
  end

  %% Composition Root Layer
  subgraph "Composition Root Layer"
    DI[Dependency Injection]
    class DI composition
  end

  %% Application Layer
  subgraph "Application Layer"
    UseCases[Use Cases]
    AppServices[Application Services]
    class UseCases application
    class AppServices application
  end

  %% Infrastructure Layer
  subgraph "Infrastructure Layer"
    Repos[Repository Implementations]
    DataSources[Data Sources]
    External[External APIs]
    class Repos infrastructure
    class DataSources infrastructure
    class External infrastructure
  end

  %% Domain Layer
  subgraph "Domain Layer"
    DomainModel[Domain Models]
    RepoInterfaces[Repository Interfaces]
    class DomainModel domain
    class RepoInterfaces domain
  end

  %% Design Layer
  subgraph "Design Layer"
    DesignUI[Design UI Components]
    DesignTheme[Design Theme]
    class DesignUI design
    class DesignTheme design
  end

  %% Dependencies (arrows show dependency direction)
  UI --> Providers
  UI --> DesignUI
  UI --> DesignTheme
  
  Providers --> DI
  Providers --> UseCases
  
  DI --> UseCases
  DI --> Repos
  DI --> RepoInterfaces
  
  UseCases --> AppServices
  UseCases --> RepoInterfaces
  UseCases --> DomainModel
  
  AppServices --> RepoInterfaces
  AppServices --> DomainModel
  
  Repos --> DataSources
  Repos --> External
  Repos --> DomainModel
  
  DataSources --> External
  
  DesignUI --> DesignTheme
```

### エラーハンドリングの方針

> [!NOTE]
> 必ずプロジェクトごとに方針について検討して、別途ドキュメントにまとめてください。

基本的には以下の方針に従ってください：

- **Infrastructure Layer**: `Exception` をキャッチして `DomainException` に変換して投げる
- **Application Layer**: `DomainException` をキャッチして適切なデータに変換して返却する

### レイヤー間の責務と実装パターン

#### Presentation Layer

**責務**: ユーザーインターフェースの表示とユーザー操作の処理

**実装パターン**:

- `ConsumerWidget` を使用して `Provider` の状態を監視
- ビジネスロジックは直接実装せず `Provider` を通じてユースケースを呼び出し
- UI 状態の管理は `Provider` や `Notifier`, `AsyncNotifier` を使用

**実装時の注意点**:

- すべての操作に UseCase を用意するのは過剰な場合がある
- 単純な CRUD 操作などは Presentation Layer から直接 Repository を呼び出しても良い
- 複雑なビジネスロジックや複数の Repository を組み合わせる場合は UseCase を活用
- 実際のプロジェクトでは、アーキテクチャの純粋性と実装コストのバランスを考慮して判断する

```dart
// presentation/providers/theme_setting_provider.dart
@riverpod
class ThemeSettingNotifier extends _$ThemeSettingNotifier {
  @override
  ThemeSetting build() {
    final repository = ref.watch(themeSettingRepositoryProvider);
    return repository.getThemeSetting();
  }

  Future<void> changeThemeSetting(ThemeSetting theme) async {
    final useCase = ref.read(changeThemeSettingUseCaseProvider);
    await useCase.call(theme);
    state = theme;
  }
}

// presentation/ui/setting/setting_page.dart
class SettingPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSetting = ref.watch(themeSettingNotifierProvider);

    return ElevatedButton(
      onPressed: () {
        ref.read(themeSettingNotifierProvider.notifier)
            .changeThemeSetting(ThemeSetting.light);
      },
      child: Text('テーマ変更: ${themeSetting.name}'),
    );
  }
}
```

#### Application Layer

**責務**: ユースケースの実装とアプリケーション固有のビジネスロジック

**実装パターン**:

- 各ユースケースは単一の責務を持つ
- ドメインロジックを呼び出してアプリケーション固有の処理を実装
- リポジトリインターフェースに依存し、実装詳細は知らない

```dart
// application/theme_setting/change_theme_setting_use_case.dart
class ChangeThemeSettingUseCase {
  const ChangeThemeSettingUseCase({
    required this.themeSettingRepository,
  });

  final ThemeSettingRepository themeSettingRepository;

  Future<void> call(ThemeSetting themeSetting) async {
    await themeSettingRepository.saveThemeSetting(themeSetting);
  }
}
```

#### Infrastructure Layer

**責務**: 外部システムとの連携とデータの永続化

**実装パターン**:

- リポジトリインターフェースの実装を提供
- 外部 API、データベース、ファイルシステムとの連携
- ドメインモデルと外部データ形式の変換

```dart
// infrastructure/theme_setting/theme_setting_repository_impl.dart
class ThemeSettingRepositoryImpl implements ThemeSettingRepository {
  const ThemeSettingRepositoryImpl(this._sharedPreference);

  final SharedPreferenceDataSource _sharedPreference;

  @override
  ThemeSetting getThemeSetting() {
    return _sharedPreference.getThemeSetting();
  }

  @override
  Future<void> saveThemeSetting(ThemeSetting themeSetting) async {
    await _sharedPreference.saveThemeSetting(themeSetting.index);
  }
}
```

#### Domain Layer

**責務**: ビジネスルールとドメインロジックの実装

**実装パターン**:

- `domain_model`: エンティティ、値オブジェクト、集約の定義
- `domain_logic`: ドメインサービス、リポジトリインターフェースの定義
- 他のレイヤーに依存しない純粋なビジネスロジック

```dart
// domain_model/theme_setting/theme_setting.dart
enum ThemeSetting {
  system,
  light,
  dark,
}

// domain_logic/theme_setting/theme_setting_repository.dart
abstract class ThemeSettingRepository {
  ThemeSetting getThemeSetting();
  Future<void> saveThemeSetting(ThemeSetting themeSetting);
}
```

#### Design Layer

**責務**: デザインシステムの提供と UI コンポーネントの管理

**実装パターン**:

- `design_theme`: カラーパレット、タイポグラフィ、スペーシングなどのテーマ定義
- `design_ui`: 再利用可能な UI コンポーネントの提供
- `design_domain_ui`: ドメイン固有の UI コンポーネント（オプション）
