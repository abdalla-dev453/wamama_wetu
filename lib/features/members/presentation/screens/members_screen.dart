import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Members'), elevation: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.person_add),
      ),
      body: members.when(
        data: (membersList) {
          if (membersList.isEmpty) {
            return const Center(child: Text('No members yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: membersList.length,
            itemBuilder: (context, index) {
              final member = membersList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(member.fullName[0], style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  title: Text(member.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Member #${member.memberNumber} • ${member.phoneNumber}'),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('KES ${member.totalContributed.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(member.outstandingBalance > 0 ? 'Owes: KES ${member.outstandingBalance.toStringAsFixed(0)}' : 'Paid up', style: TextStyle(fontSize: 11, color: member.outstandingBalance > 0 ? Colors.red : Colors.green)),
                    ],
                  ),
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