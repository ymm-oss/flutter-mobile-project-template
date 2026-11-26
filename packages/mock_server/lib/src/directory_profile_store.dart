import 'dart:io';

import 'package:internal_mock_server/src/profile.dart';
import 'package:path/path.dart' as p;

/// ディレクトリにプロファイルを置く [ProfileStore]。
///
/// - 共有: `<directory>/<名前>.json`。コミットしてチームで使う。読むだけ。
/// - 自分用: `<directory>/local/<名前>.json`。管理画面から保存する。
///   Git の対象から外しておく。
final class DirectoryProfileStore implements ProfileStore {
  const new(this.directory);

  final Directory directory;

  Directory get localDirectory => Directory(p.join(directory.path, 'local'));

  @override
  Future<List<ProfileRef>> list() async => [
    for (final name in await _names(directory)) (name: name, shared: true),
    for (final name in await _names(localDirectory))
      (name: name, shared: false),
  ];

  @override
  Future<String> read(ProfileRef ref) async {
    validateProfileName(ref.name);
    final file = _file(ref);
    try {
      return await file.readAsString();
    } on PathNotFoundException {
      throw ProfileStoreException(
        '${ref.shared ? '共有' : '自分用'}のプロファイル「${ref.name}」がありません。',
      );
    }
  }

  @override
  Future<void> save(String name, String content) async {
    validateProfileName(name);
    await localDirectory.create(recursive: true);
    await _file((name: name, shared: false)).writeAsString(content);
  }

  @override
  Future<void> delete(String name) async {
    validateProfileName(name);
    try {
      await _file((name: name, shared: false)).delete();
    } on PathNotFoundException {
      throw ProfileStoreException('自分用のプロファイル「$name」がありません。');
    }
  }

  File _file(ProfileRef ref) => File(
    p.join((ref.shared ? directory : localDirectory).path, '${ref.name}.json'),
  );

  static Future<List<String>> _names(Directory directory) async {
    if (!directory.existsSync()) {
      return const [];
    }
    final names = await directory
        .list()
        .where(
          (entity) => entity is File && p.extension(entity.path) == '.json',
        )
        .map((entity) => p.basenameWithoutExtension(entity.path))
        .toList();
    return names..sort();
  }
}
