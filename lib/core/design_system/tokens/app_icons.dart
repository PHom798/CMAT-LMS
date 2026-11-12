import 'package:flutter/material.dart';

/// Icons referenced by name from content files (e.g. `"icon": "quant"`).
/// Content can't hold Flutter IconData, so it names a key and the app maps it
/// here. Unknown keys fall back to a generic book icon.
abstract final class AppIcons {
  static const _byKey = <String, IconData>{
    'verbal': Icons.translate_rounded,
    'quant': Icons.calculate_rounded,
    'logical': Icons.extension_rounded,
    'general': Icons.public_rounded,
  };

  static IconData forKey(String key) => _byKey[key] ?? Icons.menu_book_rounded;
}
