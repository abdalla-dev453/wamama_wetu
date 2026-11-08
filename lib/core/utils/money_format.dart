/// Formatting for Kenyan shilling amounts held as **integer minor units**
/// (cents). Money is never a `double` anywhere in ChamaLedger: floating-point
/// error is unacceptable in a ledger.
abstract final class MoneyFormat {
  static const String defaultCurrency = 'KES';

  /// `150050` -> `1,500.50`. Negative values keep a leading minus sign.
  /// When [showCents] is false and the amount is whole shillings, the
  /// decimals are dropped (`150000` -> `1,500`).
  static String amount(int minor, {bool showCents = true}) {
    final negative = minor < 0;
    final abs = minor.abs();
    final whole = abs ~/ 100;
    final cents = abs % 100;
    final grouped = _group(whole);
    final hideCents = !showCents && cents == 0;
    final body = hideCents
        ? grouped
        : '$grouped.${cents.toString().padLeft(2, '0')}';
    return negative ? '-$body' : body;
  }

  /// `650000` -> `KES 6,500`.
  static String kes(int minor, {bool showCents = false}) =>
      '$defaultCurrency ${amount(minor, showCents: showCents)}';

  static String _group(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  /// Spoken form for screen readers: "1,500 Kenya shillings".
  static String spoken(int minor,
      {String currency = defaultCurrency, bool showCents = true}) {
    final name = currency == 'KES' ? 'Kenya shillings' : currency;
    return '${amount(minor, showCents: showCents)} $name';
  }
}