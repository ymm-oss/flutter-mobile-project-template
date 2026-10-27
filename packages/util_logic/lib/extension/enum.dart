extension EnumByName<T extends Enum> on Iterable<T> {
  // byNameで取得できなかった場合はnullを返す版
  T? byNameOrNull(String name) {
    for (final MapEntry(:key, :value) in asNameMap().entries) {
      if (key == name) {
        return value;
      }
    }

    return null;
  }
}
