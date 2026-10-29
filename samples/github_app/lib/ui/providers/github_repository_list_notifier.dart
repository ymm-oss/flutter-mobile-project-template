import 'package:github_app/data/providers/repository.dart';
import 'package:github_app/domain/models/exception.dart';
import 'package:github_app/domain/models/github_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:utils_pagination/exception.dart';
import 'package:utils_pagination/model.dart';
import 'package:utils_pagination/provider.dart';

final AsyncNotifierProvider<
  PageBasedGitHubRepositoryNotifier,
  GitHubRepositoryPageState
>
pageBasedGitHubRepositoryNotifierProvider =
    AsyncNotifierProvider.autoDispose<
      PageBasedGitHubRepositoryNotifier,
      GitHubRepositoryPageState
    >(
      PageBasedGitHubRepositoryNotifier.new,
    );

typedef GitHubRepositoryPageState = PageBasedPagingData<GitHubRepository>;

class PageBasedGitHubRepositoryNotifier
    extends PageBasedPagingAsyncNotifier<GitHubRepository> {
  @override
  Future<PageBasedFetchResult<GitHubRepository>> fetch({
    required int page,
  }) async {
    try {
      final res = await ref.read(
        listOrganizationRepositoriesProvider(page: page).future,
      );
      if (ref.mounted) {
        ref.keepAlive();
      }
      return PageBasedFetchResult(
        items: res.items,
        hasMore: res.hasMore,
      );
    } on AppException catch (e) {
      switch (e) {
        case ClientNetworkException():
          throw PagingClientNetworkException(e.message);
        case ServerNetworkException():
          throw PagingServerNetworkException(e.message);
        case UnknownNetworkException():
          throw const PagingUnknownNetworkException();
        case UnknownException():
          throw const PagingUnknownException();
      }
    }
  }

  @override
  void forceRefresh() {
    ref.invalidate(listOrganizationRepositoriesProvider);
    super.forceRefresh();
  }
}
