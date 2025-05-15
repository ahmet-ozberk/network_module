import '../error/network_error.dart';

enum NetworkStatus {
  initial,
  loading,
  success,
  error,
}

class NetworkState<T> {
  final NetworkStatus status;
  final T? data;
  final NetworkError? error;
  final bool isLoading;

  NetworkState({
    this.status = NetworkStatus.initial,
    this.data,
    this.error,
    this.isLoading = false,
  });

  factory NetworkState.initial() => NetworkState(status: NetworkStatus.initial);
  
  factory NetworkState.loading() => NetworkState(
        status: NetworkStatus.loading,
        isLoading: true,
      );
  
  factory NetworkState.success(T data) => NetworkState(
        status: NetworkStatus.success,
        data: data,
      );
  
  factory NetworkState.error(NetworkError error) => NetworkState(
        status: NetworkStatus.error,
        error: error,
      );
  
  bool get isInitial => status == NetworkStatus.initial;
  bool get isSuccess => status == NetworkStatus.success;
  bool get isError => status == NetworkStatus.error;

  NetworkState<T> copyWith({
    NetworkStatus? status,
    T? data,
    NetworkError? error,
    bool? isLoading,
  }) {
    return NetworkState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
