import 'package:dio/dio.dart';
import 'network_error.dart';

class ErrorHandler {
  const ErrorHandler();

  NetworkError handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else {
      return NetworkError.unknown(
        message: error.toString(),
        exception: error,
      );
    }
  }

  NetworkError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkError.timeout();
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          String? message = error.response?.data?['message'] as String?;
          if (message == null && error.response?.data is Map) {
            message = error.response?.data.toString();
          }
          return NetworkError.fromStatusCode(
            statusCode,
            message: message ?? error.message,
          );
        }
        return NetworkError.unknown(
          message: error.message,
          exception: error,
        );
      
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return NetworkError.connectivity();
      
      default:
        return NetworkError.unknown(
          message: error.message,
          exception: error,
        );
    }
  }
}
