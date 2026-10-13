import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utils_pagination/src/extension/async_value.dart';
import 'package:utils_pagination/src/model/paging_data.dart';

/// An abstract notifier for paging logic, handling asynchronous data fetching
/// and state management.
///
/// T: The type of the paginated data structure being managed.
/// U: The type of the items within the paginated data.
abstract class PagingAsyncNotifier<T extends PagingData<U>, U>
    extends AsyncNotifier<T> {
  Future<void> loadNext();

  void forceRefresh() {
    state = AsyncLoading<T>();
    ref.invalidateSelf();
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
    final value = state.value;
    if (value == null) {
      return;
    }

    if (value.hasMore) {
      state = AsyncLoading<PageBasedPagingData<T>>();

      state = await state.guardPreservingPreviousOnError(
        () async {
          final next = await fetch(page: value.currentPage + 1);

          return value.copyWith(
            items: [...value.items, ...next.items],
            currentPage: value.currentPage + 1,
            hasMore: next.hasMore,
          );
        },
      );
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
