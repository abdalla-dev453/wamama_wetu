import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Counts from the offline queue, shown by the OfflineBanner.
@immutable
class SyncQueueSummary {
  const SyncQueueSummary({
    this.pending = 0,
    this.failed = 0,
    this.conflict = 0,
    this.isSyncing = false,
  });

  final int pending;
  final int failed;
  final int conflict;
  final bool isSyncing;
}

/// STUB: always empty until the Drift-backed offline queue is built.
/// The real implementation will watch the queue table and replace this.
final syncQueueSummaryProvider =
    Provider<SyncQueueSummary>((ref) => const SyncQueueSummary());