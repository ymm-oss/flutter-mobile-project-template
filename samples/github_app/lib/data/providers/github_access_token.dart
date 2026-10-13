// 環境変数を使用するファイルのため警告を無視
// ignore_for_file: do_not_use_environment

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'github_access_token.g.dart';

const _gitHubAccessTokenKey = 'GITHUB_ACCESS_TOKEN';

@riverpod
String? gitHubAccessToken(Ref ref) {
  return const bool.hasEnvironment(_gitHubAccessTokenKey)
      ? const String.fromEnvironment(_gitHubAccessTokenKey)
      : null;
}
