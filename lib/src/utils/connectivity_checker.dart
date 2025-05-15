import 'dart:io';

class ConnectivityChecker {
  final List<String> _hostList;
  final Duration timeout;

  ConnectivityChecker({
    List<String> hostList = const ['8.8.8.8', '8.8.4.4', 'google.com'],
    this.timeout = const Duration(seconds: 3),
  }) : _hostList = hostList;

  Future<bool> hasConnection() async {
    try {
      for (final host in _hostList) {
        final result = await InternetAddress.lookup(host)
            .timeout(timeout);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}