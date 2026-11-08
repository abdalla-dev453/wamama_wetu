import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/group.dart';
import '../../../../core/models/member.dart';
import '../../../../core/models/contribution.dart';
import '../../../../core/models/mpesa_payment.dart';
import '../../../../core/models/group_health_score.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider);
    final healthScore = ref.watch(healthScoreProvider);
    final mpesaPayments = ref.watch(mpesaPaymentsProvider);
    final currentGroupId = ref.watch(currentGroupIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chamify'),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: groups.when(
        data: (groupsList) {
          if (groupsList.isEmpty) {
            return _EmptyState();
          }

          final group = currentGroupId != null
              ? groupsList.firstWhere((g) => g.id == currentGroupId, orElse: () => groupsList.first)
              : groupsList.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BalanceHero(group: group),
                const SizedBox(height: 20),
                _QuickActionRow(),
                const SizedBox(height: 20),
                _HealthScoreWidget(healthScore: healthScore.value),
                const SizedBox(height: 20),
                _NeedsAttentionWidget(mpesaPayments: mpesaPayments.value ?? []),
                const SizedBox(height: 20),
                _RecentActivityWidget(contributions: const [], members: const []),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('No chamas yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Create your first chama to get started', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Create Chama'),
          ),
        ],
      ),
    );
  }
}

class _BalanceHero extends StatelessWidget {
  final Group group;

  const _BalanceHero({required this.group});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Total group savings', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'KES ${group.currentPotBalance.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _StatItem(label: 'Members', value: '${group.memberCount}')),
              Expanded(child: _StatItem(label: 'Contributed', value: 'KES ${group.totalContributions.toStringAsFixed(0)}')),
              Expanded(child: _StatItem(label: 'Paid Out', value: 'KES ${group.totalPayouts.toStringAsFixed(0)}')),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
      ],
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.group_add_outlined,
            label: 'New Group',
            color: cs.primary,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.add_circle_outline,
            label: 'Contribute',
            color: cs.secondary,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.receipt_outlined,
            label: 'M-Pesa Reconcile',
            color: AppColors.mpesaGreen,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthScoreWidget extends StatelessWidget {
  final GroupHealthScore? healthScore;

  const _HealthScoreWidget({this.healthScore});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final score = healthScore?.score ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: healthScore?.scoreColor.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$score',
                  style: TextStyle(
                    color: healthScore?.scoreColor ?? Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Group Health', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(healthScore?.scoreLabel ?? 'No data', style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeedsAttentionWidget extends StatelessWidget {
  final List<MpesaPayment> mpesaPayments;

  const _NeedsAttentionWidget({required this.mpesaPayments});

  @override
  Widget build(BuildContext context) {
    final unmatched = mpesaPayments.where((p) => p.status == MpesaPaymentStatus.unmatched).length;
    final pending = mpesaPayments.where((p) => p.requiresTreasurerReview).length;

    if (unmatched == 0 && pending == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.orange.withValues(alpha: 0.1),
      child: ListTile(
        leading: const Icon(Icons.warning_amber_outlined, color: Colors.orange),
        title: Text('Needs Attention', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$unmatched unmatched payments, $pending pending review'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class _RecentActivityWidget extends StatelessWidget {
  final List<Contribution> contributions;
  final List<Member> members;

  const _RecentActivityWidget({required this.contributions, required this.members});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            const Text('No recent activity', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}