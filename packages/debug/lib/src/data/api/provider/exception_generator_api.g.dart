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
    r'a2d64e48f8235709d090b87159d664408d57295b';

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
