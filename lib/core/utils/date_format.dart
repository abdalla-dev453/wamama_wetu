import 'package:intl/intl.dart';

/// Shared date/time formats, always shown in the phone's local time (EAT).
abstract final class AppDateFormat {
  static final DateFormat _dateTime = DateFormat('d MMM, h:mm a');
  static final DateFormat _longDate = DateFormat('EEE, d MMM yyyy');

  /// `5 Nov, 6:20 AM`
  static String dateTime(DateTime d) => _dateTime.format(d.toLocal());

  /// `Sun, 15 Nov 2026`
  static String longDate(DateTime d) => _longDate.format(d.toLocal());
}