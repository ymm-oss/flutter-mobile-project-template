import 'package:dio/dio.dart';
import 'package:github_app/data/providers/github_access_token.dart';
import 'package:github_app/domain/models/exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio.g.dart';

@riverpod
Dio dio(Ref ref) {
  final gitHubAccessToken = ref.watch(gitHubAccessTokenProvider);

  final options = BaseOptions(
    baseUrl: 'https://api.github.com',
    headers: {
      if (gitHubAccessToken != null)
        'Authorization': 'token $gitHubAccessToken',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );
  final dio = Dio(options);

  dio.interceptors.add(LogInterceptor());
  return dio;
}

extension DioExtension on Dio {
  /// Usage case:
  ///   When you want to handle [DioException] and　convert it　to [AppException]
  ///
  /// ```dart
  /// Future<void> fetchUser() async {
  ///   state = const AsyncValue.loading();
  ///   try {
  ///     final result = await dio.safeRequest<User>(
  ///       request: () => dio.get('/users/1'),
  ///     );
  ///     state = AsyncValue.data(data);
  ///   } on AppException catch (e, stackTrace) {
  ///     ref.read(appExceptionNotifierProvider.notifier).notify(e);
  ///     state = AsyncValue.error(e, stackTrace);
  ///   );
  /// }
  /// ```
  Future<T> safeRequest<T>({
    required Future<T> Function() request,
  }) => _wrapDioException<T>(request);

  /// Handle [DioException] and convert it to [AppException]
  Future<T> _wrapDioException<T>(
    Future<T> Function() request,
  ) async {
    try {
      final result = await request();
      return result;
    } on DioException catch (e) {
      final networkException = _convertDioExceptionToNetworkException(e);
      throw networkException;
    }
  }

  AppException _convertDioExceptionToNetworkException(DioException e) {
    return NetworkException.fromStatusCode(e.response?.statusCode);
  }
}
