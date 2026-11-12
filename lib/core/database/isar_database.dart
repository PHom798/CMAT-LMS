import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Opens the single local database for the whole app.
///
/// Core stays feature-agnostic: features register their own schemas from the
/// composition root (`app/app_dependencies.dart`), so adding a feature never
/// requires editing this file.
abstract final class IsarDatabase {
  static const _name = 'w3_lms';

  static Future<Isar> open(List<CollectionSchema<dynamic>> schemas) async {
    final directory = await getApplicationDocumentsDirectory();
    return Isar.open(
      schemas,
      directory: directory.path,
      name: _name,
      inspector: kDebugMode,
    );
  }
}
