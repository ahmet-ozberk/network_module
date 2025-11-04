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
      Options? finalOptions = options;
      if (data is FormData && options != null) {
        final headers = Map<String, dynamic>.from(options.headers ?? {});
        headers.remove('Content-Type');
        headers.remove('content-type');
        
        finalOptions = Options(
          method: options.method,
          sendTimeout: options.sendTimeout,
          receiveTimeout: options.receiveTimeout,
          extra: options.extra,
          headers: headers,
          responseType: options.responseType,
          contentType: options.contentType,
          validateStatus: options.validateStatus,
          receiveDataWhenStatusError: options.receiveDataWhenStatusError,
          followRedirects: options.followRedirects,
          maxRedirects: options.maxRedirects,
          persistentConnection: options.persistentConnection,
          requestEncoder: options.requestEncoder,
          responseDecoder: options.responseDecoder,
          listFormat: options.listFormat,
        );
      } else if (data is FormData && options == null) {
        finalOptions = Options(
          headers: <String, dynamic>{},
        );
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
      Options? finalOptions = options;
      if (data is FormData && options != null) {
        final headers = Map<String, dynamic>.from(options.headers ?? {});
        headers.remove('Content-Type');
        headers.remove('content-type');
        
        finalOptions = Options(
          method: options.method,
          sendTimeout: options.sendTimeout,
          receiveTimeout: options.receiveTimeout,
          extra: options.extra,
          headers: headers,
          responseType: options.responseType,
          contentType: options.contentType,
          validateStatus: options.validateStatus,
          receiveDataWhenStatusError: options.receiveDataWhenStatusError,
          followRedirects: options.followRedirects,
          maxRedirects: options.maxRedirects,
          persistentConnection: options.persistentConnection,
          requestEncoder: options.requestEncoder,
          responseDecoder: options.responseDecoder,
          listFormat: options.listFormat,
        );
      } else if (data is FormData && options == null) {
        finalOptions = Options(
          headers: <String, dynamic>{},
        );
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
