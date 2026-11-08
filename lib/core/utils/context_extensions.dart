import 'package:flutter/widgets.dart';

extension TextScaleContext on BuildContext {
  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(16) / 16;

  /// True when the user has enlarged text enough that side-by-side layouts
  /// should stack vertically.
  bool get isLargeText => textScaleFactor > 1.3;
}