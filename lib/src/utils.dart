import 'package:meta/meta.dart';

@internal
T? wrapErrors<T>(
  T Function() function,
  List<Object> uncaughtErrors,
  bool hasErrorExpectation,
) {
  try {
    return function();
  } catch (e) {
    if (!hasErrorExpectation) rethrow;
    uncaughtErrors.add(e);
    return null;
  }
}
