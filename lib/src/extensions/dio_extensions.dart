import 'package:dio/dio.dart';
import '../models/response_model.dart';
import '../error/error_handler.dart';

extension DioExtensions on Dio {
  Future<ResponseModel<T>> _handleError<T>(
      dynamic e,
      T Function(dynamic)? converter,
      ) async {
    if (e is DioException) {
      final raw = e.response?.data;
      if (raw != null) {
        try {
          final parsed = converter != null ? converter(raw) : raw as T;
          return ResponseModel.success(
            parsed,
            statusCode: e.response?.statusCode,
          );
        } catch (_) {}
      }
    }

    final error = const ErrorHandler().handleError(e);

    return ResponseModel.error(
      error,
      statusCode: (e is DioException) ? e.response?.statusCode : null,
    );
  }

  Future<ResponseModel<T>> safeGet<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        T Function(dynamic)? converter,
      }) async {
    try {
      final response = await get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      final data =
      converter != null ? converter(response.data) : response.data as T;

      return ResponseModel.success(data, statusCode: response.statusCode);
    } catch (e) {
      return _handleError<T>(e, converter);
    }
  }

  Future<ResponseModel<T>> safePost<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        T Function(dynamic)? converter,
      }) async {
    try {
      Options? finalOptions = options;

      if (data is FormData && options != null) {
        final headers = Map<String, dynamic>.from(options.headers ?? {});
        headers.remove('Content-Type');
        headers.remove('content-type');
        finalOptions = options.copyWith(headers: headers);
      } else if (data is FormData && options == null) {
        finalOptions = Options(headers: <String, dynamic>{});
      }

      final response = await post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: finalOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      final responseData =
      converter != null ? converter(response.data) : response.data as T;

      return ResponseModel.success(
        responseData,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _handleError<T>(e, converter);
    }
  }

  Future<ResponseModel<T>> safePut<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        T Function(dynamic)? converter,
      }) async {
    try {
      Options? finalOptions = options;

      if (data is FormData && options != null) {
        final headers = Map<String, dynamic>.from(options.headers ?? {});
        headers.remove('Content-Type');
        headers.remove('content-type');
        finalOptions = options.copyWith(headers: headers);
      } else if (data is FormData && options == null) {
        finalOptions = Options(headers: <String, dynamic>{});
      }

      final response = await put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: finalOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      final responseData =
      converter != null ? converter(response.data) : response.data as T;

      return ResponseModel.success(
        responseData,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _handleError<T>(e, converter);
    }
  }

  Future<ResponseModel<T>> safeDelete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        T Function(dynamic)? converter,
      }) async {
    try {
      final response = await delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      final responseData =
      converter != null ? converter(response.data) : response.data as T;

      return ResponseModel.success(
        responseData,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return _handleError<T>(e, converter);
    }
  }
}
