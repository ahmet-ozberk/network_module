import '../models/response_model.dart';
import '../models/network_state.dart';

extension ResponseModelExtensions<T> on ResponseModel<T> {
  NetworkState<T> toNetworkState() {
    if (success && data != null) {
      return NetworkState.success(data as T);
    } else if (!success && error != null) {
      return NetworkState.error(error!);
    } else {
      return NetworkState.initial();
    }
  }

  T get dataOrThrow {
    if (success && data != null) {
      return data as T;
    }
    throw error ?? Exception('Unknown error');
  }

  T? get dataOrNull => data;

  T get dataOrDefault {
    if (success && data != null) {
      return data as T;
    }
    if (T == String) {
      return '' as T;
    } else if (T == int) {
      return 0 as T;
    } else if (T == double) {
      return 0.0 as T;
    } else if (T == bool) {
      return false as T;
    } else if (T == List) {
      return [] as T;
    } else if (T == Map) {
      return {} as T;
    }
    return null as T;
  }
}
