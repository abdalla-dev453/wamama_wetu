import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/models/rotation.dart';

class RotationScreen extends ConsumerWidget {
  const RotationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotations = ref.watch(rotationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rotation Engine'), elevation: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: rotations.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('No rotation entries yet'));
          }

          final current = entries.firstWhere((e) => !e.isPaidOut, orElse: () => entries.first);

          return Column(
            children: [
              _CurrentRecipientCard(currentRecipient: current),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: entry.position == 1 ? Theme.of(context).colorScheme.primary : null,
                          child: Text('#${entry.position}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        title: Text(entry.memberId, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Payout: ${entry.payoutDate.toString().split(' ')[0]}'),
                            Text('Amount: KES ${entry.potAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        trailing: entry.isPaidOut
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.pending, color: Colors.orange),
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

class _CurrentRecipientCard extends StatelessWidget {
  final RotationEntry currentRecipient;

  const _CurrentRecipientCard({required this.currentRecipient});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B7340), Color(0xFF2E8B57)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Current Recipient', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(currentRecipient.memberId, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoItem(label: 'Position', value: '#${currentRecipient.position}'),
              _InfoItem(label: 'Payout Date', value: currentRecipient.payoutDate.toString().split(' ')[0]),
              _InfoItem(label: 'Amount', value: 'KES ${currentRecipient.potAmount.toStringAsFixed(0)}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
      ],
    );
  }
}