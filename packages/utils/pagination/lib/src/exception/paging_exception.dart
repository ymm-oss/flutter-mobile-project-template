sealed class PagingException implements Exception {
  const new(this.message);

  final String message;
}

sealed class PagingNetworkException extends PagingException {
  const new(super.message);
}

final class PagingClientNetworkException extends PagingNetworkException {
  const new(super.message);
}

final class PagingServerNetworkException extends PagingNetworkException {
  const new(super.message);
}

final class PagingUnknownNetworkException extends PagingNetworkException {
  const new() : super('Unknown network error occurred');
}

final class PagingUnknownException extends PagingException {
  const new() : super('Unknown error occurred');
}
