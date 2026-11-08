import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool _hasNetwork(List<ConnectivityResult> results) =>
    results.any((r) => r != ConnectivityResult.none);

/// Emits whether the phone has a network interface up.
/// Note: this does not prove the backend is reachable; the sync engine
/// reports real request failures separately via the sync queue.
final connectivityStatusProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  yield _hasNetwork(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(_hasNetwork);
});

/// Synchronous view for widgets. Assumes online until told otherwise so the
/// banner does not flash on startup. Override in tests.
final isOnlineProvider = Provider<bool>(
  (ref) => ref.watch(connectivityStatusProvider).valueOrNull ?? true,
);