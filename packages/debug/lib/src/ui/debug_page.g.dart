// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'debug_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(debugPageNavigator)
final debugPageNavigatorProvider = DebugPageNavigatorProvider._();

final class DebugPageNavigatorProvider
    extends
        $FunctionalProvider<
          DebugPageNavigator,
          DebugPageNavigator,
          DebugPageNavigator
        >
    with $Provider<DebugPageNavigator> {
  DebugPageNavigatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugPageNavigatorProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$debugPageNavigatorHash();

  @$internal
  @override
  $ProviderElement<DebugPageNavigator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DebugPageNavigator create(Ref ref) {
    return debugPageNavigator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebugPageNavigator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebugPageNavigator>(value),
    );
  }
}

String _$debugPageNavigatorHash() =>
    r'8716c128bd9fb8db1107d07189b9db556a01d64e';

@ProviderFor(debugPagePresenter)
final debugPagePresenterProvider = DebugPagePresenterProvider._();

final class DebugPagePresenterProvider
    extends
        $FunctionalProvider<
          DebugPagePresenter,
          DebugPagePresenter,
          DebugPagePresenter
        >
    with $Provider<DebugPagePresenter> {
  DebugPagePresenterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugPagePresenterProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$debugPagePresenterHash();

  @$internal
  @override
  $ProviderElement<DebugPagePresenter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DebugPagePresenter create(Ref ref) {
    return debugPagePresenter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebugPagePresenter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebugPagePresenter>(value),
    );
  }
}

String _$debugPagePresenterHash() =>
    r'679d386296e3bc30d22f5d9e4a64b245637a3203';

@ProviderFor(EnableAccessibilityTools)
final enableAccessibilityToolsProvider = EnableAccessibilityToolsProvider._();

final class EnableAccessibilityToolsProvider
    extends $NotifierProvider<EnableAccessibilityTools, bool> {
  EnableAccessibilityToolsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enableAccessibilityToolsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enableAccessibilityToolsHash();

  @$internal
  @override
  EnableAccessibilityTools create() => EnableAccessibilityTools();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$enableAccessibilityToolsHash() =>
    r'16671b0538cbc32e899796ddc0f897baac32bb49';

abstract class _$EnableAccessibilityTools extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
