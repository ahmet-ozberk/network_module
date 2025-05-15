import '../error/network_error.dart';

class ResponseModel<T> {
  final bool success;
  final T? data;
  final NetworkError? error;
  final int? statusCode;

  ResponseModel({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ResponseModel.success(T data, {int? statusCode}) {
    return ResponseModel<T>(
      success: true,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ResponseModel.error(NetworkError error, {int? statusCode}) {
    return ResponseModel<T>(
      success: false,
      error: error,
      statusCode: statusCode ?? error.statusCode,
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;

  R when<R>({
    required R Function(T data) success,
    required R Function(NetworkError error) error,
  }) {
    if (this.success && data != null) {
      return success(data as T);
    } else {
      return error(this.error ?? NetworkError.unknown());
    }
  }
}
