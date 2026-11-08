import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/models/audit_entry.dart';

class AuditScreen extends ConsumerWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditEntries = ref.watch(auditEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Audit Trail'), elevation: 0),
      body: auditEntries.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('No audit entries yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: const Icon(Icons.security, color: Colors.blue),
                  ),
                  title: Text(entry.action.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Actor: ${entry.actorId.substring(0, 8)}...'),
                      Text(entry.timestamp.toString().split('.')[0], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      if (entry.reason != null) Text('Reason: ${entry.reason}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                  trailing: entry.approverId != null
                      ? const Icon(Icons.verified, color: Colors.green)
                      : const Icon(Icons.pending, color: Colors.orange),
                  onTap: () {},
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