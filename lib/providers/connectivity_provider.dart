import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { isConnected, isDisconnected, notDetermined }

final connectivityProvider = StreamProvider<ConnectivityStatus>((ref) {
  return Connectivity().onConnectivityChanged.map((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      return ConnectivityStatus.isDisconnected;
    } else {
      return ConnectivityStatus.isConnected;
    }
  });
});
