import 'dart:async';

import 'package:meta/meta.dart';
import 'package:re_state_action/re_state_action.dart';
import 'package:re_state_action_test/src/utils.dart';
import 'package:test/test.dart' as test;

/// Creates a test case for a `ReState` with the given [description].
/// [reStateTest] is a wrapper around conventional unit [test] that handles
/// assertions for [expectStates] and [expectErrors] emitted in order
/// by the `ReState`.
///
/// [buildReState] is a function that returns a `ReState` instance to be tested.
///
/// [setUp] is an optional function that is called before the test case to
/// prepare the test environment.
///
/// [seedStates] is an optional function that returns an iterable of states to
/// seed the `ReState` with before the test [actReState] is called.
///
/// [actReState] is an optional function that is called to perform an action on
/// the `ReState` under test. Should be used to interact with the `ReState`.
///
/// [wait] is an optional duration to wait before asserting the [expectStates].
///
/// [expectStates] is an optional function that returns a matcher that verifies
/// the states that are expected to be emitted by the `ReState` in order.
///
/// [expectErrors] is an optional function that returns a matcher that verifies
/// the errors that are expected to be thrown by the `ReState` in order.
///
/// [verifyReState] is an optional function that is called to verify the
/// `ReState` after the test expectations have been asserted.
///
/// [tearDown] is an optional function that is called after the test case to
/// clean up the test environment.
///
/// [skip] is an optional boolean that can be used to skip the test case.
///
/// [tags] is an optional dynamic that can be used to tag the test case.
///
/// Examples:
///
/// ```dart
/// reStateTest<CounterReState, int>(
///  'should emit states in order',
///   buildReState: () => CounterReState(initialState: 0),
///   actReState: (reState) => reState.increment(),
///   expectStates: () => [0, 1],
/// );
/// ```
///
/// [seedStates] can be used to seed the `ReState` with states before the test
///
/// ```dart
/// reStateTest<CounterReState, int>(
///   'should emit states in order',
///   buildReState: () => CounterReState(initialState: 0),
///   seedStates: () => [1, 2],
///   actReState: (reState) => reState.increment(),
///   expectStates: () => [0, 1, 2, 3],
/// );
/// ```
@isTest
void reStateTest<T extends ReState<State>, State>(
  String description, {
  required T Function() buildReState,
  FutureOr<void> Function()? setUp,
  Iterable<State> Function()? seedStates,
  dynamic Function(T reState)? actReState,
  Duration? wait,
  dynamic Function()? expectStates,
  dynamic Function()? expectErrors,
  dynamic Function(T reState)? verifyReState,
  FutureOr<void> Function()? tearDown,
  bool skip = false,
  dynamic tags,
}) {
  test.test(
    description,
    () async {
      final states = <State>[];
      final uncaughtErrors = <Object>[];

      final reState = wrapErrors(
        buildReState,
        uncaughtErrors,
        hasErrorExpectation: expectErrors != null,
      );

      if (reState == null) {
        test.expect(uncaughtErrors, test.wrapMatcher(expectErrors!()));
        return;
      }

      reState.listenState(states.add);

      if (setUp != null) {
        wrapErrors(
          setUp,
          uncaughtErrors,
          hasErrorExpectation: expectErrors != null,
        );
      }

      if (seedStates != null) {
        wrapErrors(
          // ignore: invalid_use_of_protected_member
          () => seedStates.call().forEach(reState.emitState),
          uncaughtErrors,
          hasErrorExpectation: expectErrors != null,
        );
      }

      if (actReState != null) {
        wrapErrors(
          () => actReState(reState),
          uncaughtErrors,
          hasErrorExpectation: expectErrors != null,
        );
      }

      await Future<void>.delayed(wait ?? Duration.zero);

      if (expectStates != null) {
        test.expect(states, test.wrapMatcher(expectStates()));
      }

      if (verifyReState != null) verifyReState(reState);

      if (tearDown != null) await tearDown();

      reState
        ..removeStateListener(states.add)
        ..dispose();

      if (expectErrors != null) {
        test.expect(uncaughtErrors, test.wrapMatcher(expectErrors()));
      }
    },
    skip: skip,
    tags: tags,
  );
}
