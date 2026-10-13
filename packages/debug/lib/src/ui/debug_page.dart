import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internal_debug/src/data/api/provider/exception_generator_api.dart';
import 'package:internal_util_ui/snack_bar_manager.dart';
import 'package:riverpod_annotation/experimental/scope.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'debug_page.g.dart';

abstract interface class DebugPageNavigator {
  void goNavigationDebugPage(BuildContext context);
  void goTalkerPage(BuildContext context);
}

@Riverpod(dependencies: [])
DebugPageNavigator debugPageNavigator(Ref ref) => throw UnimplementedError();

abstract interface class DebugPagePresenter {
  void enableForceUpdate();
  void enableMaintenanceMode();
}

@Riverpod(dependencies: [])
DebugPagePresenter debugPagePresenter(Ref ref) => throw UnimplementedError();

@riverpod
class EnableAccessibilityTools extends _$EnableAccessibilityTools {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

@Dependencies([debugPageNavigator, debugPagePresenter])
class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<String>>(
      exceptionGeneratorApiProvider,
      (_, value) {
        if (value.hasError) {
          SnackBarManager.showSnackBar(
            'An error occurred: ${value.error}',
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Mode'),
      ),
      body: Center(
        child: Column(
          children: [
            _FixSizedElevatedButton(
              title: 'Show error SnackBar',
              onPressed: () {
                unawaited(
                  ref.read(exceptionGeneratorApiProvider.notifier).request(),
                );
              },
            ),
            _FixSizedElevatedButton(
              title: 'Enable maintenance mode',
              onPressed: () =>
                  ref.read(debugPagePresenterProvider).enableMaintenanceMode(),
            ),
            _FixSizedElevatedButton(
              title: 'Enable force update',
              onPressed: () =>
                  ref.read(debugPagePresenterProvider).enableForceUpdate(),
            ),
            _FixSizedElevatedButton(
              title: 'Toggle accessibility tools',
              onPressed: () {
                ref.read(enableAccessibilityToolsProvider.notifier).toggle();
              },
            ),
            _FixSizedElevatedButton(
              title: 'Go navigation debug page',
              onPressed: () => ref
                  .read(debugPageNavigatorProvider)
                  .goNavigationDebugPage(context),
            ),
            _FixSizedElevatedButton(
              title: 'Go navigation talker page',
              onPressed: () =>
                  ref.read(debugPageNavigatorProvider).goTalkerPage(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _FixSizedElevatedButton extends StatelessWidget {
  const _FixSizedElevatedButton({
    required this._title,
    required this._onPressed,
  });

  final String _title;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        onPressed: _onPressed,
        child: Text(_title),
      ),
    );
  }
}
