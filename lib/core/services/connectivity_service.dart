import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

/// Service to monitor network connectivity status
class ConnectivityService {
  final Connectivity _connectivity;
  final _logger = Logger();
  
  StreamController<bool>? _connectivityController;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityService(this._connectivity);

  /// Stream of connectivity changes (true = connected, false = disconnected)
  Stream<bool> get onConnectivityChanged {
    _connectivityController ??= StreamController<bool>.broadcast();
    return _connectivityController!.stream;
  }

  /// Check current connectivity status
  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      final connected = result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
      
      _logger.d('Current connectivity: $connected');
      return connected;
    } catch (e) {
      _logger.e('Error checking connectivity: $e');
      return false;
    }
  }

  /// Start monitoring connectivity changes
  void startMonitoring() {
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        final connected = result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet;
        
        _logger.i('Connectivity changed: $connected');
        _connectivityController?.add(connected);
      },
      onError: (error) {
        _logger.e('Connectivity monitoring error: $error');
        _connectivityController?.add(false);
      },
    );
  }

  /// Stop monitoring connectivity changes
  void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _connectivityController?.close();
    _connectivityController = null;
  }
}