import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueExtension<T> on AsyncValue<T> {
  /// Extends the [when] method to handle async data states more effectively,
  /// especially when maintaining data integrity despite errors.
  ///
  /// Use `skipErrorOnHasValue` to retain and display existing data
  /// even if subsequent fetch attempts result in errors,
  /// ideal for maintaining a seamless user experience.
  ///
  /// Use `skipLoadingOnHasValue` to retain and display existing data
  /// while loading, even if the loading is a reload.
  R whenIgnorableError<R>({
    required R Function(
      T data, {
      required bool hasError,
      required bool isLoading,
    })
    data,
    required R Function(Object error, StackTrace stackTrace) error,
    required R Function() loading,
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    bool skipErrorOnHasValue = false,
    bool skipLoadingOnHasValue = false,
  }) {
    if (skipErrorOnHasValue) {
      if (hasValue && hasError) {
        return data(requireValue, hasError: true, isLoading: isLoading);
      }
    }

    if (skipLoadingOnHasValue) {
      if (hasValue && isLoading) {
        return data(requireValue, hasError: hasError, isLoading: true);
      }
    }

    return when(
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipError: skipError,
      data: (d) => data(d, hasError: hasError, isLoading: isLoading),
      error: error,
      loading: loading,
    );
  }
}
