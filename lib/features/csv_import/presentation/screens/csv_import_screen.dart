import 'package:flutter/material.dart';

class CsvImportScreen extends StatelessWidget {
  const CsvImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CSV Migration'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.import_export, size: 64, color: Colors.grey),
            const SizedBox(height: 24),
            const Text('Upload CSV or Excel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              'Detects and maps: member name, phone, amount, date, contribution type, fine, loan repayment',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_upload),
              label: const Text('Choose File'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Supported columns:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...[
              'member_name, phone, amount, date',
              'contribution_type, fine, loan_repayment',
            ].map((col) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• $col', style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ))),
          ],
        ),
      ),
    );
  }
}