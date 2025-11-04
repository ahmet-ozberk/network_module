import 'package:dio/dio.dart';
import 'core/network_client.dart';
import 'core/network_options.dart';
import 'log/network_logger.dart';
import 'utils/connectivity_checker.dart';

class NetworkModule {
  static NetworkModule? _instance;
  final NetworkClient _client;

  NetworkModule._({required NetworkClient client}) : _client = client;

  static NetworkModule get instance {
    if (_instance == null) {
      throw Exception(
        'NetworkModule has not been initialized. Call NetworkModule.initialize() first.',
      );
    }
    return _instance!;
  }

  static NetworkModule initialize({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    Map<String, dynamic> headers = const {},
    Future<String?>? Function()? tokenProvider,
    LogLevel logLevel = LogLevel.all,
    ConnectivityChecker? connectivityChecker,
    NetworkLogger? logger,
    bool isLoggerEnable = true,
  }) {
    final options = NetworkOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      headers: headers,
      tokenProvider: tokenProvider,
      logLevel: logLevel,
    );

    final client = NetworkClient(
      options: options,
      connectivityChecker: connectivityChecker,
      logger: logger,
      isLoggerEnable: isLoggerEnable,
    );

    _instance = NetworkModule._(client: client);
    return _instance!;
  }

  Dio get dio => _client.dio;
  NetworkClient get client => _client;

  void addInterceptor(Interceptor interceptor) {
    _client.addInterceptor(interceptor);
  }

  void removeInterceptor(Interceptor interceptor) {
    _client.removeInterceptor(interceptor);
  }

  void clearInterceptors() {
    _client.clearInterceptors();
  }
}
