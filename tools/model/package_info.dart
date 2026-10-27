enum Kind {
  transitive,
  dev,
  direct;

  new();

  factory fromString(String value) {
    for (final kind in Kind.values) {
      if (value == kind.name) {
        return kind;
      }
    }

    throw ArgumentError('Kind does not have $value');
  }
}

extension ExtString on String {
  String substringIgnores({List<String> ignores = const ['-', '+']}) {
    for (final pattern in ignores) {
      final index = indexOf(pattern);
      if (index != -1) {
        return substring(0, index);
      }
    }

    return this;
  }
}

class PackageInfo {
  const new({required this.packages});

  factory fromJson(Map<String, dynamic> data) => PackageInfo(
    packages: (data['packages'] as List<dynamic>)
        .map((e) => Package.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  final List<Package> packages;

  Map<String, dynamic> toJson() => {
    'packages': packages.map((e) => e.toJson()).toList(),
  };
}

class Package {
  const new({
    required this.package,
    required this.kind,
    required this.isDiscontinued,
    required this.isCurrentRetracted,
    required this.isCurrentAffectedByAdvisory,
    required this.current,
    required this.upgradable,
    required this.resolvable,
    required this.latest,
  });

  factory fromJson(Map<String, dynamic> data) => Package(
    package: data['package'] as String,
    kind: Kind.fromString(data['kind'] as String),
    isDiscontinued: data['isDiscontinued'] as bool,
    isCurrentRetracted: data['isCurrentRetracted'] as bool,
    isCurrentAffectedByAdvisory: data['isCurrentAffectedByAdvisory'] as bool,
    current: data['current'] == null
        ? null
        : Version.fromJson(data['current'] as Map<String, dynamic>),
    upgradable: Version.fromJson(data['upgradable'] as Map<String, dynamic>),
    resolvable: Version.fromJson(data['resolvable'] as Map<String, dynamic>),
    latest: Version.fromJson(data['latest'] as Map<String, dynamic>),
  );

  final String package;
  final Kind kind;
  final bool isDiscontinued;
  final bool isCurrentRetracted;
  final bool isCurrentAffectedByAdvisory;
  final Version? current;
  final Version upgradable;
  final Version resolvable;
  final Version latest;

  Map<String, dynamic> toJson() => {
    'package': package,
    'kind': kind,
    'isDiscontinued': isDiscontinued,
    'isCurrentRetracted': isCurrentRetracted,
    'isCurrentAffectedByAdvisory': isCurrentAffectedByAdvisory,
    'current': current?.toJson(),
    'upgradable': upgradable.toJson(),
    'resolvable': resolvable.toJson(),
    'latest': latest.toJson(),
  };
}

class Version implements Comparable<Version> {
  const new({required this.version});

  factory fromJson(Map<String, dynamic> data) => Version(
    version: data['version'] as String,
  );

  final String version;

  Map<String, dynamic> toJson() => {
    'version': version,
  };

  @override
  int compareTo(Version other) {
    final currentVersion = version.substringIgnores().split('.');

    final resolvableVersion = other.version.substringIgnores().split('.');
    if (resolvableVersion.length != 3) {
      throw ArgumentError('${other.version} is not forma: x.x.x');
    }

    for (var index = 0; index < 3; index++) {
      final currentNum = int.parse(currentVersion[index]);
      final resolvableNum = int.parse(resolvableVersion[index]);

      final compare = currentNum.compareTo(resolvableNum);
      if (compare == 0) {
        continue;
      }

      return compare;
    }

    return 0;
  }
}
