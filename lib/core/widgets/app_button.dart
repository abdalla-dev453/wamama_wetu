import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.variant = AppButtonVariant.filled,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool fullWidth;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = switch (variant) {
      AppButtonVariant.filled => FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
        ),
      AppButtonVariant.outlined => OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
        ),
      AppButtonVariant.text => TextButton.styleFrom(
          foregroundColor: cs.primary,
        ),
    };

    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              Text(label),
            ],
          );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: switch (variant) {
          AppButtonVariant.filled => FilledButton(onPressed: onPressed, style: style, child: child),
          AppButtonVariant.outlined => OutlinedButton(onPressed: onPressed, style: style, child: child),
          AppButtonVariant.text => TextButton(onPressed: onPressed, style: style, child: child),
        },
      );
    }

    return switch (variant) {
      AppButtonVariant.filled => FilledButton(onPressed: onPressed, style: style, child: child),
      AppButtonVariant.outlined => OutlinedButton(onPressed: onPressed, style: style, child: child),
      AppButtonVariant.text => TextButton(onPressed: onPressed, style: style, child: child),
    };
  }
}

enum AppButtonVariant { filled, outlined, text }