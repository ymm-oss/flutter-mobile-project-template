sealed class AppException implements Exception {
  const new(this.message);

  final String message;
}

sealed class NetworkException extends AppException {
  const new(super.message);

  factory fromStatusCode(int? statusCode) {
    if (statusCode == null) {
      return const UnknownNetworkException();
    }

    return switch (statusCode) {
      >= 400 && < 500 => ClientNetworkException(
        'Client error occurred($statusCode)',
      ),
      >= 500 && < 600 => ServerNetworkException(
        'Server error occurred($statusCode)',
      ),
      _ => throw ArgumentError(
        'Invalid status code: $statusCode.',
        'statusCode',
      ),
    };
  }
}

class ClientNetworkException extends NetworkException {
  const new(super.message);
}

class ServerNetworkException extends NetworkException {
  const new(super.message);
}

class UnknownNetworkException extends NetworkException {
  const new() : super('Unknown network error occurred');
}

class UnknownException extends AppException {
  const new() : super('Unknown error occurred');
}
