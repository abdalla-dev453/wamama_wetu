import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/models/mpesa_payment.dart';

class ReconciliationScreen extends ConsumerWidget {
  const ReconciliationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(mpesaPaymentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('M-PESA Reconciliation'), elevation: 0),
      body: payments.when(
        data: (paymentsList) {
          if (paymentsList.isEmpty) {
            return const Center(child: Text('No M-PESA payments yet'));
          }

          final pending = paymentsList.where((p) => p.requiresTreasurerReview).toList();
          final matched = paymentsList.where((p) => p.status == MpesaPaymentStatus.matched).toList();
          final unmatched = paymentsList.where((p) => p.status == MpesaPaymentStatus.unmatched).toList();

          return Column(
            children: [
              _StatusSummary(pending: pending.length, matched: matched.length, unmatched: unmatched.length),
              Expanded(
                child: TabBarView(
                  children: [
                    _PaymentList(payments: pending, title: 'Pending Review', emptyMessage: 'All payments reconciled'),
                    _PaymentList(payments: matched, title: 'Matched', emptyMessage: 'No matched payments'),
                    _PaymentList(payments: unmatched, title: 'Unmatched', emptyMessage: 'No unmatched payments'),
                  ],
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

class _StatusSummary extends StatelessWidget {
  final int pending;
  final int matched;
  final int unmatched;

  const _StatusSummary({required this.pending, required this.matched, required this.unmatched});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _StatCard(label: 'Pending Review', value: pending.toString(), color: Colors.orange)),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(label: 'Matched', value: matched.toString(), color: Colors.green)),
          const SizedBox(width: 8),
          Expanded(child: _StatCard(label: 'Unmatched', value: unmatched.toString(), color: Colors.red)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

class _PaymentList extends StatelessWidget {
  final List<MpesaPayment> payments;
  final String title;
  final String emptyMessage;

  const _PaymentList({required this.payments, required this.title, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final p = payments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _statusColor(p.status).withValues(alpha: 0.2),
              child: Text(p.mpesaReceiptCode.substring(0, 2).toUpperCase(), style: TextStyle(fontWeight: FontWeight.w700, color: _statusColor(p.status))),
            ),
            title: Text('KES ${p.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(p.reference, style: const TextStyle(fontSize: 12)),
                Text('${p.phoneNumber} • ${p.transactionDate.toString().split(' ')[0]}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
              ],
            ),
            trailing: _StatusChip(status: p.status),
            onTap: () {},
          ),
        );
      },
    );
  }
}

Color _statusColor(MpesaPaymentStatus status) {
  switch (status) {
    case MpesaPaymentStatus.received:
      return Colors.blue;
    case MpesaPaymentStatus.validating:
      return Colors.orange;
    case MpesaPaymentStatus.matched:
      return Colors.green;
    case MpesaPaymentStatus.unmatched:
      return Colors.red;
    case MpesaPaymentStatus.allocated:
      return Colors.teal;
    case MpesaPaymentStatus.posted:
      return Colors.green;
    case MpesaPaymentStatus.reversed:
      return Colors.grey;
  }
}

class _StatusChip extends StatelessWidget {
  final MpesaPaymentStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _statusColor(status).withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(status)),
      ),
    );
  }
}