import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class CollectionDayScreen extends ConsumerWidget {
  const CollectionDayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Today's Collection"), elevation: 0),
      body: members.when(
        data: (membersList) {
          final totalExpected = membersList.fold<double>(0, (sum, m) => sum + m.outstandingBalance);
          final paidCount = membersList.where((m) => m.outstandingBalance == 0).length;
          final partialCount = membersList.where((m) => m.outstandingBalance > 0 && m.outstandingBalance < 1000).length;
          final unpaidCount = membersList.where((m) => m.outstandingBalance >= 1000).length;

          return Column(
            children: [
              _CollectionSummary(
                expected: totalExpected,
                collected: totalExpected * 0.6,
                outstanding: totalExpected * 0.4,
                paid: paidCount,
                partial: partialCount,
                unpaid: unpaidCount,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: membersList.length,
                  itemBuilder: (context, index) {
                    final member = membersList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(member.fullName[0]),
                        ),
                        title: Text(member.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('Member #${member.memberNumber}'),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('KES ${member.outstandingBalance.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            _StatusBadge(status: member.outstandingBalance == 0 ? 'Paid' : 'Pending'),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _CollectionSummary extends StatelessWidget {
  final double expected;
  final double collected;
  final double outstanding;
  final int paid;
  final int partial;
  final int unpaid;

  const _CollectionSummary({
    required this.expected,
    required this.collected,
    required this.outstanding,
    required this.paid,
    required this.partial,
    required this.unpaid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text("Today's Collection", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _Metric(label: 'Expected', value: 'KES ${expected.toStringAsFixed(0)}', color: Colors.blue)),
              Expanded(child: _Metric(label: 'Collected', value: 'KES ${collected.toStringAsFixed(0)}', color: Colors.green)),
              Expanded(child: _Metric(label: 'Outstanding', value: 'KES ${outstanding.toStringAsFixed(0)}', color: Colors.red)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _Metric(label: 'Paid', value: '$paid', color: Colors.green)),
              Expanded(child: _Metric(label: 'Partial', value: '$partial', color: Colors.orange)),
              Expanded(child: _Metric(label: 'Unpaid', value: '$unpaid', color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Metric({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8))),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'Paid' ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}