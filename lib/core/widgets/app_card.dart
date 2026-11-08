import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    return Card(
      color: color,
      child: onTap != null
          ? ListTile(onTap: onTap, contentPadding: EdgeInsets.zero, title: content)
          : content,
    );
  }
}