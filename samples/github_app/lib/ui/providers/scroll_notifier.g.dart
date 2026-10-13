// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroll_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScrollNotifier)
final scrollProvider = ScrollNotifierProvider._();

final class ScrollNotifierProvider
    extends $NotifierProvider<ScrollNotifier, void> {
  ScrollNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scrollProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scrollNotifierHash();

  @$internal
  @override
  ScrollNotifier create() => ScrollNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$scrollNotifierHash() => r'4e43fc3145511dce39d9721397f56efad2885530';

abstract class _$ScrollNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
