import 'package:flutter/widgets.dart';

/// 4-pt spacing scale. Prefer these over raw numbers in layouts.
abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 6.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;

  /// Horizontal padding for full-width page content.
  static const page = EdgeInsets.symmetric(horizontal: xxl);
}

/// Corner radii. Bigger surfaces get bigger radii.
abstract final class AppRadius {
  static const sm = 10.0; // badges, letter tiles
  static const md = 12.0; // icon tiles
  static const lg = 16.0; // small cards, code blocks
  static const card = 18.0; // selectable cards, inputs
  static const xl = 22.0; // panels
  static const sheet = 24.0; // bottom sheets / action area
  static const pill = 999.0;
}

/// Max content width so layouts stay comfortable on tablets.
abstract final class AppLayout {
  static const maxContentWidth = 520.0;
}
