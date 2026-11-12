import 'package:flutter/material.dart';

/// Brand palette sampled from the W3 Developers website.
///
/// Rule of thumb: orange is for actions and highlights, cream is the canvas,
/// ink is for text. Green and red are reserved for answer feedback only.
abstract final class AppColors {
  // Brand
  static const orange = Color(0xFFF78B02);
  static const orangeDeep = Color(0xFFC96F00); // 3D edge under orange surfaces
  static const orangeSoft = Color(0xFFFFE2BC); // icon tiles, soft fills
  static const orangeTint = Color(0xFFFFF6EA); // selected card fill
  static const cream = Color(0xFFFEF0DA); // page background (top)
  static const creamLight = Color(0xFFFFF8EE); // page background (bottom)
  static const ink = Color(0xFF2C2C2C);
  static const inkSoft = Color(0xFF55514C);
  static const muted = Color(0xFF9B948B);
  static const sunshine = Color(0xFFFFC46B); // confetti accent only

  // Warm neutrals for cards and tracks.
  static const surface = Colors.white;
  static const line = Color(0xFFEDDFCB);
  static const lineDeep = Color(0xFFDCCBB3);
  static const locked = Color(0xFFF3E8D8);

  // Feedback
  static const success = Color(0xFF2E9E62);
  static const successDeep = Color(0xFF227A4B);
  static const successSoft = Color(0xFFE2F4EA);
  static const error = Color(0xFFD64545);
  static const errorDeep = Color(0xFFA83434);
  static const errorSoft = Color(0xFFFBE6E3);
}
