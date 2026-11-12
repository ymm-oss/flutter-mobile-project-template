import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NavigationDebugPage extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text('Debug Page'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RouteDropdownMenu(),
            ),
          ),
        ],
      ),
    );
  }
}

final class RouteDropdownMenu extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final configuration = router.configuration;
    final routeBases = configuration.routes;
    final dropdownMenuEntries = useMemoized(
      () {
        final paths = routeBases.goRoutes
            .map(configuration.locationForRoute)
            .nonNulls;
        return paths
            .map(
              (path) {
                // デバッグ関連のルートは除外する
                if (path.contains('debug')) {
                  return null;
                }
                return DropdownMenuEntry<String>(
                  value: path,
                  label: path,
                );
              },
            )
            .nonNulls
            .toList();
      },
      routeBases,
    );
    final pathEditController = useTextEditingController();

    // DropdownMenu を親の横幅に合わせる
    return Column(
      children: [
        DropdownMenu(
          dropdownMenuEntries: dropdownMenuEntries,
          expandedInsets: EdgeInsets.zero,
          onSelected: (selectedPath) {
            if (selectedPath == null) {
              return;
            }
            pathEditController.text = selectedPath;
          },
        ),
        const SizedBox.square(dimension: 16),
        TextField(
          controller: pathEditController,
          decoration: const InputDecoration(
            label: Text('Path'),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.go,
          maxLines: 2,
          onSubmitted: router.go,
        ),
        const SizedBox.square(dimension: 16),
        ElevatedButton(
          onPressed: () => router.go(pathEditController.text),
          child: const Text('Go'),
        ),
      ],
    );
  }
}

extension _GoRoutes on List<RouteBase> {
  Iterable<GoRoute> get goRoutes sync* {
    for (final routeBase in this) {
      if (routeBase is GoRoute) {
        yield routeBase;
      }
      yield* routeBase.routes.goRoutes;
    }
  }
}
