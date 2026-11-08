import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyText extends StatelessWidget {
  const MoneyText({
    super.key,
    required this.amount,
    this.style,
    this.currencySymbol = 'KES',
  });

  final double amount;
  final TextStyle? style;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormat.currency(symbol: currencySymbol, decimalDigits: 0).format(amount);
    return Text(formatted, style: style);
  }
}