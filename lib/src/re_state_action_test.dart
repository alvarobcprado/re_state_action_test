import 'dart:async';

import 'package:meta/meta.dart';
import 'package:re_state_action/re_state_action.dart';
import 'package:re_state_action_test/src/utils.dart';
import 'package:test/test.dart' as test;

/// Creates a test case for a `ReStateAction` with the given [description].
/// [reStateActionTest] is a wrapper around conventional unit [test] that
/// handles assertions for [expectStates], [expectActions] and [expectErrors]
/// emitted in order by the `ReStateAction`.
///
/// [buildReStateAction] is a function that returns a `ReState` instance to be
/// tested.
///
/// [setUp] is an optional function that is called before the test case to
/// prepare the test environment.
///
/// [seedStates] is an optional function that returns an iterable of states to
/// seed the `ReStateAction` with before the test [actReStateAction] is called.
///
/// [seedActions] is an optional function that returns an iterable of actions to
/// seed the `ReStateAction` with before the test [actReStateAction] is called.
///
/// [actReStateAction] is an optional function that is called to perform an
/// action on the `ReStateAction` under test. Should be used to interact with
/// the `ReStateAction`.
///
/// [wait] is an optional duration to wait before asserting the [expectStates].
///
/// [expectStates] is an optional function that returns a matcher that verifies
/// the states that are expected to be emitted by the `ReStateAction` in order.
///
/// [expectActions] is an optional function that returns a matcher that
/// verifies the actions that are expected to be emitted by the `ReStateAction`
/// in order.
///
/// [expectErrors] is an optional function that returns a matcher that verifies
/// the errors that are expected to be thrown by the `ReStateAction` in order.
///
/// [verifyReStateAction] is an optional function that is called to verify the
/// `ReStateAction` after the test expectations have been asserted.
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
/// reStateTestAction<CounterReStateAction, int, CounterAction>(
///   'should emit states and actions in order',
///   buildReStateAction: () => CounterReStateAction(initialState: 0),
///   actReStateAction: (reStateAction) => reStateAction.increment(),
///   expectStates: () => [0, 1],
///   expectActions: () => [ShowSnackBarAction()],
/// );
/// ```
///
/// [seedStates] can be used to seed the `ReState` with states before the test
///
/// ```dart
/// reStateTestAction<CounterReStateAction, int, CounterAction>(
///   'should emit states and actions in order',
///   buildReStateAction: () => CounterReStateAction(initialState: 0),
///   seedStates: () => [1, 2],
///   seedActions: () => [ShowSnackBarAction()],
///   actReStateAction: (reStateAction) => reStateAction.increment(),
///   expectStates: () => [0, 1, 2, 3],
///   expectActions: () => [ShowSnackBarAction(), ShowSnackBarAction()],
/// );
/// ```
@isTest
void reStateActionTest<T extends ReStateAction<State, Action>, State, Action>(
  String description, {
  required T Function() buildReStateAction,
  FutureOr<void> Function()? setUp,
  Iterable<State> Function()? seedStates,
  Iterable<Action> Function()? seedActions,
  dynamic Function(T reStateAction)? actReStateAction,
  Duration? wait,
  dynamic Function()? expectStates,
  dynamic Function()? expectActions,
  dynamic Function()? expectErrors,
  dynamic Function(T reStateAction)? verifyReStateAction,
  FutureOr<void> Function()? tearDown,
  bool skip = false,
  dynamic tags,
}) =>
    test.test(
      description,
      () async {
        final states = <State>[];
        final actions = <Action>[];
        final uncaughtErrors = <Object>[];

        final reStateAction = wrapErrors(
          buildReStateAction,
          uncaughtErrors,
          hasErrorExpectation: expectErrors != null,
        );

        if (reStateAction == null) {
          test.expect(uncaughtErrors, test.wrapMatcher(expectErrors!()));
          return;
        }

        reStateAction
          ..listenState(states.add)
          ..listenAction(actions.add);

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
            () => seedStates.call().forEach(reStateAction.emitState),
            uncaughtErrors,
            hasErrorExpectation: expectErrors != null,
          );
        }

        if (seedActions != null) {
          wrapErrors(
            // ignore: invalid_use_of_protected_member
            () => seedActions.call().forEach(reStateAction.emitAction),
            uncaughtErrors,
            hasErrorExpectation: expectErrors != null,
          );
        }

        if (actReStateAction != null) {
          wrapErrors(
            () => actReStateAction(reStateAction),
            uncaughtErrors,
            hasErrorExpectation: expectErrors != null,
          );
        }

        await Future<void>.delayed(wait ?? Duration.zero);

        if (expectStates != null) {
          test.expect(states, test.wrapMatcher(expectStates()));
        }

        if (expectActions != null) {
          test.expect(actions, test.wrapMatcher(expectActions()));
        }

        if (verifyReStateAction != null) verifyReStateAction(reStateAction);

        if (tearDown != null) await tearDown();

        reStateAction
          ..removeStateListener(states.add)
          ..removeActionListener(actions.add)
          ..dispose();

        if (expectErrors != null) {
          test.expect(uncaughtErrors, test.wrapMatcher(expectErrors()));
        }
      },
      skip: skip,
      tags: tags,
    );
