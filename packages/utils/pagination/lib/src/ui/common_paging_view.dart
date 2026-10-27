import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utils_pagination/model.dart';
import 'package:utils_pagination/provider.dart';
import 'package:utils_pagination/src/exception/paging_exception.dart';
import 'package:utils_pagination/src/extension/async_value.dart';

import 'package:visibility_detector/visibility_detector.dart';

class CommonPagingView<
  N extends PagingAsyncNotifier<D, T>,
  D extends PagingData<T>,
  T
>
    extends ConsumerWidget {
  /// A widget for displaying paginated data with asynchronous fetching
  /// capabilities, including pull-to-refresh support.
  ///
  /// Features:
  /// 1. Displays widgets created by [_contentBuilder] with available data.
  /// 2. Shows a CircularProgressIndicator while loading the first page.
  /// 3. Presents an error widget for first page load failures.
  /// 4. Loads the next page when the last item is displayed.
  /// 5. Handles errors with an optional callback [_onError] for non-initial
  ///    loads.
  /// 6. Enables pull-to-refresh for manual data refresh.
  ///
  /// Generics:
  ///   N: Notifier type extending [PagingAsyncNotifier] for data fetching.
  ///   D: Type of paginated data which the notifier handles.
  ///   T: Type of individual items within the paginated data.
  ///
  /// Example:
  /// ```dart
  /// CommonPagingView<MyNotifier, MyPagingData, MyItem>(
  ///   provider: myNotifierProvider,
  ///   contentBuilder: (data, endItem) => ListView.builder(
  ///     itemCount: data.items.length + (endItem != null ? 1 : 0),
  ///     itemBuilder: (context, index) {
  ///       if (index == data.items.length && endItem != null) {
  ///         return endItem;
  ///       }
  ///       return ListTile(title: Text(data.items[index].name));
  ///     },
  ///   ),
  ///   onError: (e) => showErrorDialog(context, e),
  /// )
  /// ```
  const new({
    required this._provider,
    required this._contentBuilder,
    required this._onError,
    super.key,
  });

  /// Specifies the provider for a [PagingAsyncNotifier] implemented class.
  final AsyncNotifierProvider<N, D> _provider;

  /// Specifies a function to build widgets for displaying paginated data.
  /// The function may receive an optional `endItem` widget, which serves as a
  /// marker for the end of the list. If provided and non-null, `endItem` should
  /// be included as the final item. This helps in detecting the list's end or
  /// adding a special widget at that position.
  // ignore: unsafe_variance
  final Widget Function(D data, Widget? endItem) _contentBuilder;

  final void Function(PagingException e) _onError;

  Widget? _endItem(
    D data,
    WidgetRef ref, {
    required bool hasError,
    required bool isLoading,
  }) {
    if (!data.hasMore) {
      return null;
    }

    if (hasError && isLoading) {
      return const _ReloadingItem();
    }

    if (hasError && !isLoading) {
      return _EndItemWhenError(
        onPressed: () => ref.read(_provider.notifier).loadNext(),
      );
    }

    return _EndItem(
      onScrollEnd: () => ref.read(_provider.notifier).loadNext(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      _provider,
      (_, next) {
        if (!next.isLoading && next.hasError) {
          final error = next.error;
          if (error is PagingException) {
            _onError(error);
            return;
          }
        }
      },
    );

    return ref
        .watch(_provider)
        .whenIgnorableError(
          data:
              (
                data, {
                required hasError,
                required isLoading,
              }) {
                return RefreshIndicator(
                  onRefresh: () async => ref.refresh(_provider.future),
                  child: _contentBuilder(
                    // Displays EndItem to detect scroll end
                    // if more data is available and no errors.
                    data,
                    _endItem(
                      data,
                      ref,
                      hasError: hasError,
                      isLoading: isLoading,
                    ),
                  ),
                );
              },
          loading: () {
            // Shows loading indicator during initial page load.
            return const _LoadingItem();
          },
          error: (e, _) {
            // Displays error message for initial load failures.
            return _ErrorItem(
              errorMessage: e.toString(),
              onError: () => ref.read(_provider.notifier).forceRefresh(),
            );
          },
          // Continues showing data on subsequent load errors,
          // without hiding existing content.
          skipErrorOnHasValue: true,
          // Continues showing data while loading the next page.
          // Assigning AsyncLoading to the state is treated as a reload.
          skipLoadingOnHasValue: true,
        );
  }
}

class _ReloadingItem extends StatelessWidget {
  const new();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _EndItem extends StatelessWidget {
  const new({
    required this._onScrollEnd,
  });
  final VoidCallback _onScrollEnd;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: key ?? const Key('EndItem'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) {
          _onScrollEnd();
        }
      },
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _ErrorItem extends StatelessWidget {
  const new({
    required this._errorMessage,
    required this._onError,
  });

  final String _errorMessage;
  final VoidCallback _onError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: _onError,
            icon: const Icon(Icons.refresh),
          ),
          Text(_errorMessage),
        ],
      ),
    );
  }
}

class _LoadingItem extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _EndItemWhenError extends StatelessWidget {
  const new({required this._onPressed});
  final void Function() _onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Flexible(
            flex: 3,
            child: Center(
              child: Icon(Icons.cloud_off),
            ),
          ),
          const Flexible(
            flex: 2,
            child: Center(
              child: Text(
                'Please check your connection and try again.',
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                ),
                onPressed: _onPressed,
                child: const Text('refresh'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
