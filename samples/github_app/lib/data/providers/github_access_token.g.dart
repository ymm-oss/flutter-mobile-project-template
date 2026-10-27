// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_access_token.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gitHubAccessToken)
final gitHubAccessTokenProvider = GitHubAccessTokenProvider._();

final class GitHubAccessTokenProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  GitHubAccessTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gitHubAccessTokenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gitHubAccessTokenHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return gitHubAccessToken(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$gitHubAccessTokenHash() => r'258a0c31671267224adf5dad5099337af8bdcb51';
