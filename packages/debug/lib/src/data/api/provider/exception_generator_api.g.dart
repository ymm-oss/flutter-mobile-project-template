// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore, deprecated_member_use

part of 'exception_generator_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExceptionGeneratorApi)
final exceptionGeneratorApiProvider = ExceptionGeneratorApiProvider._();

final class ExceptionGeneratorApiProvider
    extends $AsyncNotifierProvider<ExceptionGeneratorApi, String> {
  ExceptionGeneratorApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exceptionGeneratorApiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exceptionGeneratorApiHash();

  @$internal
  @override
  ExceptionGeneratorApi create() => ExceptionGeneratorApi();
}

String _$exceptionGeneratorApiHash() =>
    r'09f70b6f480042b414a4a6969429d48f071ac670';

abstract class _$ExceptionGeneratorApi extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
