// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(listOrganizationRepositories)
final listOrganizationRepositoriesProvider =
    ListOrganizationRepositoriesFamily._();

final class ListOrganizationRepositoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<GitHubRepositoryResult>,
          GitHubRepositoryResult,
          FutureOr<GitHubRepositoryResult>
        >
    with
        $FutureModifier<GitHubRepositoryResult>,
        $FutureProvider<GitHubRepositoryResult> {
  ListOrganizationRepositoriesProvider._({
    required ListOrganizationRepositoriesFamily super.from,
    required ({int page, int perPage, String org}) super.argument,
  }) : super(
         retry: null,
         name: r'listOrganizationRepositoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listOrganizationRepositoriesHash();

  @override
  String toString() {
    return r'listOrganizationRepositoriesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GitHubRepositoryResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GitHubRepositoryResult> create(Ref ref) {
    final argument = this.argument as ({int page, int perPage, String org});
    return listOrganizationRepositories(
      ref,
      page: argument.page,
      perPage: argument.perPage,
      org: argument.org,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ListOrganizationRepositoriesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listOrganizationRepositoriesHash() =>
    r'e563eea8496b6e4cfd966f0ea714319e646cf3d1';

final class ListOrganizationRepositoriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<GitHubRepositoryResult>,
          ({int page, int perPage, String org})
        > {
  ListOrganizationRepositoriesFamily._()
    : super(
        retry: null,
        name: r'listOrganizationRepositoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ListOrganizationRepositoriesProvider call({
    int page = 1,
    int perPage = 30,
    String org = 'yumemi-inc',
  }) => ListOrganizationRepositoriesProvider._(
    argument: (page: page, perPage: perPage, org: org),
    from: this,
  );

  @override
  String toString() => r'listOrganizationRepositoriesProvider';
}
