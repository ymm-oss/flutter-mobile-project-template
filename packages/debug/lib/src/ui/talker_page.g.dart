// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'talker_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(talker)
final talkerProvider = TalkerProvider._();

final class TalkerProvider extends $FunctionalProvider<Talker, Talker, Talker>
    with $Provider<Talker> {
  TalkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'talkerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$talkerHash();

  @$internal
  @override
  $ProviderElement<Talker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Talker create(Ref ref) {
    return talker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Talker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Talker>(value),
    );
  }
}

String _$talkerHash() => r'ccdc022a6f87e5d735e4be257f1afdbfcce26e54';
