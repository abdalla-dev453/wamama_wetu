import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class HealthScoreScreen extends ConsumerWidget {
  const HealthScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthScore = ref.watch(healthScoreProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Group Health Score'), elevation: 0),
      body: healthScore.when(
        data: (score) {
          final currentScore = score?.score ?? 0;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ScoreCard(score: currentScore, label: score?.scoreLabel ?? 'No data', color: score?.scoreColor ?? Colors.grey),
                const SizedBox(height: 20),
                const Text('Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _MetricRow(label: 'Collection Rate', value: '${(score?.collectionRate ?? 0).toStringAsFixed(0)}%', color: Colors.blue),
                const SizedBox(height: 8),
                _MetricRow(label: 'Arrears Rate', value: '${(score?.arrearsRate ?? 0).toStringAsFixed(0)}%', color: Colors.red),
                const SizedBox(height: 8),
                _MetricRow(label: 'Loan Repayment Rate', value: '${(score?.loanRepaymentRate ?? 0).toStringAsFixed(0)}%', color: Colors.green),
                const SizedBox(height: 8),
                _MetricRow(label: 'Meeting Attendance', value: '${(score?.meetingAttendanceRate ?? 0).toStringAsFixed(0)}%', color: Colors.teal),
                const SizedBox(height: 8),
                _MetricRow(label: 'Unmatched Payments', value: '${score?.unmatchedPaymentsCount ?? 0}', color: Colors.orange),
                const SizedBox(height: 20),
                const Text('Recommended Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ...(score?.recommendedActions ?? []).map((action) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.lightbulb_outline, color: Colors.amber),
                    title: Text(action),
                  ),
                )),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int score;
  final String label;
  final Color color;

  const _ScoreCard({required this.score, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text('$score', style: TextStyle(fontSize: 56, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 8),
          Text('Out of 100', style: TextStyle(fontSize: 14, color: color.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}