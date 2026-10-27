import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utils_pagination/src/model/paging_data.dart';

/// An abstract notifier for paging logic, handling asynchronous data fetching
/// and state management.
///
/// T: The type of the paginated data structure being managed.
/// U: The type of the items within the paginated data.
abstract class PagingAsyncNotifier<T extends PagingData<U>, U>
    extends AsyncNotifier<T> {
  Future<void> loadNext();

  /// Re-fetches from the first page.
  ///
  /// Shows the loading state when there is no data (e.g. after an initial
  /// load failure). Existing data stays visible while re-fetching.
  void forceRefresh() {
    ref.invalidateSelf(asReload: true);
  }
}

/// Extends [PagingAsyncNotifier] to implement page-based data fetching logic.
///
/// Automatically handles fetching and appending data for subsequent pages.
/// Typically, only [fetch] needs to be overridden to define fetching logic
/// for the next page.
///
/// T: The type of items in the paging data.
/// Usage Example:
/// ```dart
/// class MyPagingNotifier extends PageBasedPagingAsyncNotifier<MyDataType> {
///   MyPagingNotifier() : super(initialPage: 0); // Start fetching from page 0
///
///   @override
///   Future<PageBasedFetchResult<MyDataType>> fetch({
///     required int page,
///   }) async {
///     // Implement fetching logic here
///     return fetchMyDataType(page);
///   }
/// }
/// ```
abstract class PageBasedPagingAsyncNotifier<T>
    extends PagingAsyncNotifier<PageBasedPagingData<T>, T> {
  PageBasedPagingAsyncNotifier({this._initialPage = 1});

  final int _initialPage;

  Future<PageBasedFetchResult<T>> fetch({required int page});

  @override
  FutureOr<PageBasedPagingData<T>> build() async {
    final res = await fetch(page: _initialPage);
    return PageBasedPagingData(
      items: res.items,
      currentPage: _initialPage,
      hasMore: res.hasMore,
    );
  }

  @override
  Future<void> loadNext() async {
    // Skips while loading the next page or refreshing.
    if (state.isLoading) {
      return;
    }

    final value = state.value;
    if (value == null) {
      return;
    }

    if (value.hasMore) {
      // Captures the current Ref to detect a rebuild during the fetch.
      final ref = this.ref;
      state = AsyncLoading<PageBasedPagingData<T>>();

      final result = await AsyncValue.guard(
        () async {
          final next = await fetch(page: value.currentPage + 1);

          return value.copyWith(
            items: [...value.items, ...next.items],
            currentPage: value.currentPage + 1,
            hasMore: next.hasMore,
          );
        },
      );
      // Discards the result if the provider was rebuilt or disposed.
      if (ref.mounted) {
        state = result;
      }
      // Rethrows errors other than exceptions after leaving the loading state
      // so that loadNext can be retried.
      if (result case AsyncError(:final error, :final stackTrace)
          when error is! Exception) {
        Error.throwWithStackTrace(error, stackTrace);
      }
    }
  }
}

class PageBasedFetchResult<T> {
  const PageBasedFetchResult({
    required this.items,
    required this.hasMore,
  });

  final List<T> items;
  final bool hasMore;
}
