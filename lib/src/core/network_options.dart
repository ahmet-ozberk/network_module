import 'package:dio/dio.dart';
import '../log/network_logger.dart';

class NetworkOptions {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, dynamic> headers;
  final ResponseType responseType;
  final ValidateStatus? validateStatus;
  final bool followRedirects;
  final String Function()? tokenProvider;
  final LogLevel logLevel;

  const NetworkOptions({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.headers = const {},
    this.responseType = ResponseType.json,
    this.validateStatus,
    this.followRedirects = true,
    this.tokenProvider,
    this.logLevel = LogLevel.all,
  });

  BaseOptions toDioOptions() {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      headers: headers,
      responseType: responseType,
      validateStatus: validateStatus,
      followRedirects: followRedirects,
    );
  }

  NetworkOptions copyWith({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
    ValidateStatus? validateStatus,
    bool? followRedirects,
    String Function()? tokenProvider,
    LogLevel? logLevel,
  }) {
    return NetworkOptions(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      headers: headers ?? this.headers,
      responseType: responseType ?? this.responseType,
      validateStatus: validateStatus ?? this.validateStatus,
      followRedirects: followRedirects ?? this.followRedirects,
      tokenProvider: tokenProvider ?? this.tokenProvider,
      logLevel: logLevel ?? this.logLevel,
    );
  }
}
