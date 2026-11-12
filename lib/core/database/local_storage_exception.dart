import 'package:isar_community/isar.dart';

/// Thrown by local data sources. Repositories and controllers catch this type
/// instead of database-specific errors, so the rest of the app never imports
/// Isar.
class LocalStorageException implements Exception {
  const LocalStorageException(this.operation, [this.cause]);

  final String operation;
  final Object? cause;

  @override
  String toString() => 'LocalStorageException($operation): $cause';
}

/// Runs a database [action] and converts Isar errors into
/// [LocalStorageException] while keeping the original stack trace.
Future<T> guardStorage<T>(String operation, Future<T> Function() action) async {
  try {
    return await action();
  } on IsarError catch (error, stackTrace) {
    Error.throwWithStackTrace(LocalStorageException(operation, error), stackTrace);
  }
}
