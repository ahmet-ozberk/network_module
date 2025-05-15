import 'dart:developer' as developer;
import 'package:dio/dio.dart';

enum LogLevel { none, basic, headers, body, all }

class NetworkLogger {
  final LogLevel level;
  final String tag;
  final bool useColors;
  final bool showTime;

  const NetworkLogger({
    this.level = LogLevel.all,
    this.tag = 'NetworkLogger',
    this.useColors = true,
    this.showTime = true,
  });

  void logRequest(RequestOptions options) {
    if (level == LogLevel.none) return;

    final method = options.method;
    final uri = options.uri;
    final time = showTime ? '[${DateTime.now().toIso8601String()}] ' : '';

    _log('$time➡️ REQUEST[$method] => $uri', color: _AnsiColor.green);

    if (level == LogLevel.basic) return;

    if (level == LogLevel.headers || level == LogLevel.all) {
      if (options.headers.isEmpty) {
        _log('Headers Req: No headers found', color: _AnsiColor.yellow);
        return;
      }
      _log('Headers Req:', color: _AnsiColor.yellow);
      options.headers.forEach((key, value) {
        _log('  $key: $value', color: _AnsiColor.yellow);
      });
    }

    if (level == LogLevel.body || level == LogLevel.all) {
      if (options.data != null) {
        _log('[Body]', color: _AnsiColor.magenta);
        _log(options.data.toString(), color: _AnsiColor.magenta);
      }
    }
  }

  void logResponse(Response response) {
    if (level == LogLevel.none) return;

    final statusCode = response.statusCode;
    final method = response.requestOptions.method;
    final uri = response.requestOptions.uri;
    final time = showTime ? '[${DateTime.now().toIso8601String()}] ' : '';

    _log(
      '$time⬅️ RESPONSE[$method] $statusCode <= $uri',
      color: _AnsiColor.blue,
    );

    if (level == LogLevel.basic) return;

    if (level == LogLevel.headers || level == LogLevel.all) {
      if (response.headers.isEmpty) {
        _log('Headers Res: No headers found', color: _AnsiColor.yellow);
        return;
      }
      _log('Headers Res:', color: _AnsiColor.yellow);
      response.headers.forEach((name, values) {
        _log('  $name: ${values.join(", ")}', color: _AnsiColor.yellow);
      });
    }

    if (level == LogLevel.body || level == LogLevel.all) {
      _log('[Body]', color: _AnsiColor.magenta);
      _log(response.data, color: _AnsiColor.magenta);
    }
  }

  void logError(DioException error) {
    if (level == LogLevel.none) return;

    final statusCode = error.response?.statusCode;
    final method = error.requestOptions.method;
    final uri = error.requestOptions.uri;
    final time = showTime ? '[${DateTime.now().toIso8601String()}] ' : '';

    _log(
      '$time❌ ERROR[$method] ${statusCode ?? 'N/A'} <= $uri',
      color: _AnsiColor.red,
    );
    _log('${error.message}', color: _AnsiColor.red);

    if (level == LogLevel.basic) return;

    if (error.response != null &&
        (level == LogLevel.body || level == LogLevel.all)) {
      _log('Error Body:', color: _AnsiColor.red);
      _log('${error.response?.data}', color: _AnsiColor.red);
    }
  }

  void _log(String message, {_AnsiColor? color}) {
    if (useColors && color != null) {
      developer.log('${color.code}$message${_AnsiColor.reset.code}', name: tag);
    } else {
      developer.log(message, name: tag);
    }
  }
}

class _AnsiColor {
  final String code;
  const _AnsiColor(this.code);

  static const reset = _AnsiColor('\x1B[0m');
  static const red = _AnsiColor('\x1B[31m');
  static const green = _AnsiColor('\x1B[32m');
  static const yellow = _AnsiColor('\x1B[33m');
  static const blue = _AnsiColor('\x1B[34m');
  static const magenta = _AnsiColor('\x1B[35m');
}
