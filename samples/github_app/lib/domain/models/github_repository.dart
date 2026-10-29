import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_repository.freezed.dart';
part 'github_repository.g.dart';

@freezed
abstract class GitHubRepository with _$GitHubRepository {
  const factory({
    required String name,
    required String? description,
  }) = _GitHubRepository;

  factory fromJson(Map<String, dynamic> json) =>
      _$GitHubRepositoryFromJson(json);
}
