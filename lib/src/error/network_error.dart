enum NetworkErrorType {
  connectivity,
  timeout,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  serverError,
  unknown,
}

class NetworkError {
  final String message;
  final dynamic exception;
  final NetworkErrorType type;
  final int? statusCode;

  NetworkError({
    required this.message,
    this.exception,
    this.type = NetworkErrorType.unknown,
    this.statusCode,
  });

  factory NetworkError.connectivity() => NetworkError(
        message: 'Internet connection error',
        type: NetworkErrorType.connectivity,
      );

  factory NetworkError.timeout() => NetworkError(
        message: 'Request timeout',
        type: NetworkErrorType.timeout,
      );

  factory NetworkError.fromStatusCode(int statusCode, {String? message}) {
    final type = _getErrorTypeFromStatusCode(statusCode);
    return NetworkError(
      message: message ?? 'Error: $statusCode',
      type: type,
      statusCode: statusCode,
    );
  }

  factory NetworkError.unknown({String? message, dynamic exception}) => NetworkError(
        message: message ?? 'Unknown error occurred',
        exception: exception,
        type: NetworkErrorType.unknown,
      );

  static NetworkErrorType _getErrorTypeFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return NetworkErrorType.badRequest;
      case 401:
        return NetworkErrorType.unauthorized;
      case 403:
        return NetworkErrorType.forbidden;
      case 404:
        return NetworkErrorType.notFound;
      case >= 500 && < 600:
        return NetworkErrorType.serverError;
      default:
        return NetworkErrorType.unknown;
    }
  }

  bool get isConnectivityError => type == NetworkErrorType.connectivity;
  bool get isTimeoutError => type == NetworkErrorType.timeout;
  bool get isServerError => type == NetworkErrorType.serverError;
  bool get isClientError => 
      type == NetworkErrorType.badRequest || 
      type == NetworkErrorType.unauthorized || 
      type == NetworkErrorType.forbidden || 
      type == NetworkErrorType.notFound;
}
