import 'package:flutter/material.dart';

class MemberStatementScreen extends StatelessWidget {
  const MemberStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Statement'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Member Statement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  _Row(label: 'Total Contributed', value: 'KES 45,000'),
                  _Row(label: 'Total Received', value: 'KES 12,000'),
                  _Row(label: 'Loan Balance', value: 'KES 0'),
                  _Row(label: 'Fines', value: 'KES 0'),
                  _Row(label: 'Rotation Position', value: '#3 of 12'),
                  _Row(label: 'Next Payout', value: 'Dec 15, 2026'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.document_scanner),
            title: const Text('Download Statement'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Request Correction'),
            subtitle: const Text('Report an error in your records'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}