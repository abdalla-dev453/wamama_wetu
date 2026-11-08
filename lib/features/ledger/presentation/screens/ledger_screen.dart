import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class LedgerScreen extends ConsumerWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contributions = ref.watch(contributionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ledger'), elevation: 0),
      body: contributions.when(
        data: (contributionsList) {
          if (contributionsList.isEmpty) {
            return const Center(child: Text('No contributions yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contributionsList.length,
            itemBuilder: (context, index) {
              final c = contributionsList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(Icons.arrow_downward, color: Theme.of(context).colorScheme.primary),
                  title: Text(c.memberId, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(c.date.toString().split(' ')[0]),
                  trailing: Text('KES ${c.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}