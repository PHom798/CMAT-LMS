import 'package:flutter/animation.dart';

/// Shared motion tokens so every transition feels like the same product.
abstract final class AppMotion {
  static const fast = Duration(milliseconds: 180);
  static const medium = Duration(milliseconds: 320);
  static const slow = Duration(milliseconds: 520);
  static const emphasized = Curves.easeOutCubic;
}
