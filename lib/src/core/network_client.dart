import 'package:dio/dio.dart';
import '../log/network_logger.dart';
import 'network_options.dart';
import 'network_interceptors.dart';
import '../utils/connectivity_checker.dart';

class NetworkClient {
  final Dio _dio;
  final NetworkOptions options;
  final ConnectivityChecker connectivityChecker;
  final NetworkLogger logger;
  final bool isLoggerEnable;

  NetworkClient({
    required this.options,
    ConnectivityChecker? connectivityChecker,
    NetworkLogger? logger,
    required this.isLoggerEnable,
  })  : _dio = Dio(options.toDioOptions()),
        connectivityChecker = connectivityChecker ?? ConnectivityChecker(),
        logger = logger ?? NetworkLogger(level: options.logLevel) {
    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {

    if (!isLoggerEnable) return;

    _dio.interceptors.add(LoggingInterceptor(logger: logger));

    if (options.tokenProvider != null) {
      _dio.interceptors.add(
        AuthInterceptor(getToken: options.tokenProvider),
      );
    }

    _dio.interceptors.add(
      ConnectivityInterceptor(
        checkConnectivity: connectivityChecker.hasConnection,
      ),
    );

    _dio.interceptors.add(
      RetryInterceptor(dio: _dio),
    );
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  void clearInterceptors() {
    _dio.interceptors.clear();
    _setupInterceptors();
  }
}
