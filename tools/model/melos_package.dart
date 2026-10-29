/// Melos で管理されているパッケージの情報を表すクラス
///
/// ```json
/// {
///   "name": "feature_settings",
///   "version": "1.0.0",
///   "private": true,
///   "location": "/Users/xxxxx/xxxxx/features/settings",
///   "type": 1
/// }
/// ```
final class MelosPackage {
  new({
    required this.name,
    required this.version,
    required this.private,
    required this.location,
    required this.type,
  });

  factory fromJson(Map<String, dynamic> json) => MelosPackage(
    name: json['name'] as String,
    version: json['version'] as String,
    private: json['private'] as bool,
    location: json['location'] as String,
    type: json['type'] as int,
  );

  final String name;
  final String version;
  final bool private;
  final String location;
  final int type;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'private': private,
      'location': location,
      'type': type,
    };
  }

  @override
  String toString() {
    return '''MelosPackage(name: $name, version: $version, private: $private, location: $location, type: $type)''';
  }
}
