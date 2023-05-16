import 'package:meta/meta.dart';

/// Utility function to wrap a function call in a try-catch block.
/// Should not be used directly.
@internal
T? wrapErrors<T>(
  T Function() function,
  List<Object> uncaughtErrors, {
  required bool hasErrorExpectation,
}) {
  try {
    return function();
  } catch (e) {
    if (!hasErrorExpectation) rethrow;
    uncaughtErrors.add(e);
    return null;
  }
}
