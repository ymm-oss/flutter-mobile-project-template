import 'package:simple_logger/simple_logger.dart';

class LoggerManager {
  new _();

  static final instance = LoggerManager._();

  late final SimpleLogger _logger;
  var _isInitialized = false;

  void initialize({bool isDebugMode = false}) {
    if (_isInitialized) {
      return;
    }

    _logger = SimpleLogger()
      ..setLevel(
        Level.FINEST,
        includeCallerInfo: isDebugMode,
      );
    _isInitialized = true;
  }

  SimpleLogger get logger {
    if (!_isInitialized) {
      throw StateError(
        '''Logger not initialized. Call LoggerManager.instance.initialize() first.''',
      );
    }
    return _logger;
  }
}

SimpleLogger get logger => LoggerManager.instance.logger;
