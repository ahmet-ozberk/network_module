import 'package:dio/dio.dart';
import '../log/network_logger.dart';

class LoggingInterceptor extends Interceptor {
  final NetworkLogger logger;

  LoggingInterceptor({required this.logger});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.logRequest(options);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.logError(err);
    handler.next(err);
  }
}

class AuthInterceptor extends Interceptor {
  final String Function()? getToken;
  final String headerKey;

  AuthInterceptor({this.getToken, this.headerKey = 'Authorization'});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (getToken != null) {
      final token = getToken!();
      if (token.isNotEmpty) {
        options.headers[headerKey] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}

class ConnectivityInterceptor extends Interceptor {
  final Future<bool> Function() checkConnectivity;

  ConnectivityInterceptor({required this.checkConnectivity});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await checkConnectivity();
    if (!isConnected) {
      final error = DioException(
        requestOptions: options,
        error: 'No internet connection',
        type: DioExceptionType.connectionError,
      );
      handler.reject(error);
      return;
    }
    handler.next(options);
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<int> retryStatusCodes;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryStatusCodes = const [408, 500, 502, 503, 504],
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    int retries = 0;

    final options = err.requestOptions;
    final shouldRetry = _shouldRetry(err);

    if (shouldRetry && retries < maxRetries) {
      retries++;
      await Future.delayed(retryDelay * retries);

      try {
        final response = await dio.fetch(options..extra['retries'] = retries);
        handler.resolve(response);
        return;
      } catch (e) {
        if (retries >= maxRetries) {
          handler.reject(err);
          return;
        } 
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      return retryStatusCodes.contains(statusCode);
    }

    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }
}
