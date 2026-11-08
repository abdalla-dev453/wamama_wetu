import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.onDeleted,
    this.color,
    this.icon,
  });

  final String label;
  final VoidCallback? onDeleted;
  final Color? color;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteIcon: onDeleted != null ? const Icon(Icons.close, size: 18) : null,
      labelStyle: color != null
          ? TextStyle(color: color, fontWeight: FontWeight.w500)
          : null,
      backgroundColor: color?.withValues(alpha: 0.12),
    );
  }
}