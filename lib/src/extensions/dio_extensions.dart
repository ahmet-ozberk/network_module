import 'package:dio/dio.dart';
import '../models/response_model.dart';
import '../error/error_handler.dart';

extension DioExtensions on Dio {
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

      final data = converter != null 
          ? converter(response.data) 
          : response.data as T;

      return ResponseModel.success(
        data,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final error = const ErrorHandler().handleError(e);
      return ResponseModel.error(
        error,
        statusCode: (e is DioException) ? e.response?.statusCode : null,
      );
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
      final response = await post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      final responseData = converter != null 
          ? converter(response.data) 
          : response.data as T;

      return ResponseModel.success(
        responseData,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final error = const ErrorHandler().handleError(e);
      return ResponseModel.error(
        error,
        statusCode: (e is DioException) ? e.response?.statusCode : null,
      );
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
      final response = await put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      final responseData = converter != null 
          ? converter(response.data) 
          : response.data as T;

      return ResponseModel.success(
        responseData,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final error = const ErrorHandler().handleError(e);
      return ResponseModel.error(
        error,
        statusCode: (e is DioException) ? e.response?.statusCode : null,
      );
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

      final responseData = converter != null 
          ? converter(response.data) 
          : response.data as T;

      return ResponseModel.success(
        responseData,
        statusCode: response.statusCode,
      );
    } catch (e) {
      final error = const ErrorHandler().handleError(e);
      return ResponseModel.error(
        error,
        statusCode: (e is DioException) ? e.response?.statusCode : null,
      );
    }
  }
}
