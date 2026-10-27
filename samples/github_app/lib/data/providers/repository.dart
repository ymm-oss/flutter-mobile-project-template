import 'package:github_app/data/json_type.dart';
import 'package:github_app/data/providers/dio.dart';
import 'package:github_app/domain/models/github_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@riverpod
Future<GitHubRepositoryResult> listOrganizationRepositories(
  Ref ref, {
  int page = 1,
  int perPage = 30,
  String org = 'yumemi-inc',
}) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.safeRequest(
    request: () =>
        dio.get<ListJson>('/orgs/$org/repos?page=$page&per_page=$perPage'),
  );
  final items = response.data?.parseList(GitHubRepository.fromJson) ?? [];
  final hasMore =
      response.headers.map['link']?.first.contains('rel="next"') ?? false;
  return GitHubRepositoryResult(
    items: items,
    hasMore: hasMore,
  );
}

class GitHubRepositoryResult {
  const new({
    required this.items,
    required this.hasMore,
  });

  final List<GitHubRepository> items;
  final bool hasMore;
}
