import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:github_app/domain/models/github_repository.dart';
import 'package:github_app/ui/pages/github_repository_detail_page.dart';
import 'package:github_app/ui/providers/github_repository_list_notifier.dart';
import 'package:github_app/ui/providers/scroll_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internal_design_ui/components/list_tiles/text_list_tile.dart';
import 'package:utils_pagination/ui.dart';

typedef GitHubRepositoryPagingView =
    CommonPagingView<
      PageBasedGitHubRepositoryNotifier,
      GitHubRepositoryPageState,
      GitHubRepository
    >;

class GitHubRepositoryListPage extends HookConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    ref.listen(scrollProvider, (_, _) async {
      if (!context.mounted) {
        return;
      }

      await scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    return GitHubRepositoryPagingView(
      provider: pageBasedGitHubRepositoryNotifierProvider,
      contentBuilder: (data, endItem) => ListView.builder(
        key: const PageStorageKey('pageBasedView'),
        itemCount: data.items.length + (endItem != null ? 1 : 0),
        controller: scrollController,
        itemBuilder: (context, index) {
          if (endItem != null && index == data.items.length) {
            return endItem;
          }

          return TextListTile(
            onTap: () => _goGitHubRepositoryDetailPage(
              context,
              data.items[index].name,
              data.items[index].description,
            ),
            text: data.items[index].name,
          );
        },
      ),
      onError: (e) => unawaited(
        showDialog<void>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(e.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _goGitHubRepositoryDetailPage(
    BuildContext context,
    String repositoryName,
    String? description,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return GitHubRepositoryDetailPage(
            repositoryName: repositoryName,
            description: description,
          );
        },
      ),
    );
  }
}
