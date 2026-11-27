import 'dart:io';

import 'package:internal_mock_server/internal_mock_server.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late DirectoryProfileStore store;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('mock_profiles');
    store = DirectoryProfileStore(directory);
  });

  tearDown(() => directory.deleteSync(recursive: true));

  test('ディレクトリがなければ、一覧は空', () async {
    final missing = DirectoryProfileStore(
      Directory(p.join(directory.path, 'missing')),
    );

    expect(await missing.list(), isEmpty);
  });

  test('共有と自分用を、それぞれ名前の順に並べる', () async {
    File(p.join(directory.path, 'b.json')).writeAsStringSync('{}');
    File(p.join(directory.path, 'a.json')).writeAsStringSync('{}');
    File(p.join(directory.path, 'README.md')).writeAsStringSync('');
    await store.save('一覧が空', '{}');

    expect(await store.list(), [
      (name: 'a', shared: true),
      (name: 'b', shared: true),
      (name: '一覧が空', shared: false),
    ]);
  });

  test('自分用は local に保存し、読み直せる', () async {
    await store.save('mine', '{"version": 1}');

    expect(
      File(p.join(directory.path, 'local', 'mine.json')).readAsStringSync(),
      '{"version": 1}',
    );
    expect(await store.read((name: 'mine', shared: false)), '{"version": 1}');
  });

  test('同じ名前の共有のプロファイルがあっても、共有のファイルは書き換えない', () async {
    final shared = File(p.join(directory.path, 'errors.json'))
      ..writeAsStringSync('shared');

    await store.save('errors', 'local');

    expect(shared.readAsStringSync(), 'shared');
    expect(await store.read((name: 'errors', shared: true)), 'shared');
    expect(await store.read((name: 'errors', shared: false)), 'local');
  });

  test('自分用を消す', () async {
    await store.save('mine', '{}');

    await store.delete('mine');

    expect(await store.list(), isEmpty);
  });

  test('ないプロファイルの読み込みと削除は ProfileStoreException を投げる', () async {
    await expectLater(
      store.read((name: 'none', shared: true)),
      throwsA(isA<ProfileStoreException>()),
    );
    await expectLater(
      store.delete('none'),
      throwsA(isA<ProfileStoreException>()),
    );
  });

  test('使えない名前は、読み書きする前に拒む', () async {
    await expectLater(
      store.save('../escape', '{}'),
      throwsA(isA<ProfileStoreException>()),
    );
    expect(File(p.join(directory.path, 'escape.json')).existsSync(), isFalse);
  });
}
