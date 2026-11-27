import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

/// このパッケージの `assets/` の下のファイル（`admin/index.html` など）を読む関数。
///
/// 読み方を差し替えられるよう、関数として渡す。
typedef AssetResolver = Future<Uint8List> Function(String path);

/// このパッケージの `assets/` を dart:io で読む [AssetResolver] を作る。
///
/// `dart run` と `dart test` で使う。
Future<AssetResolver> packageAssetResolver() async {
  final library = await Isolate.resolvePackageUri(
    Uri.parse('package:internal_mock_server/'),
  );
  if (library == null) {
    throw StateError('package:internal_mock_server の場所が分かりません。');
  }
  final assets = p.join(p.dirname(p.fromUri(library)), 'assets');
  Future<Uint8List> read(String path) =>
      File(p.join(assets, path)).readAsBytes();
  return read;
}
