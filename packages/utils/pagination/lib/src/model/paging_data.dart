import 'package:freezed_annotation/freezed_annotation.dart';

part 'paging_data.freezed.dart';

/// Interface for a dataset capable of pagination.
/// Contains a list of items in [items] and a flag [hasMore]
/// indicating if more pages are available.
abstract interface class PagingData<T> {
  List<T> get items;
  bool get hasMore;
}

/// Represents accumulated paginated data up to the current page.
///
/// This class encapsulates a list of items from page one to the current page,
/// along with metadata about the paging status such as the current page number
/// and whether more pages are available.
@freezed
abstract class PageBasedPagingData<T>
    with _$PageBasedPagingData<T>
    implements PagingData<T> {
  const factory({
    required List<T> items,
    required int currentPage,
    required bool hasMore,
  }) = _PageBasedPagingData<T>;
  const new _();
}
