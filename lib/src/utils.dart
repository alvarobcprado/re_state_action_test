import 'dart:async';

import 'package:flutter_test/flutter_test.dart' as test;
import 'package:meta/meta.dart';
import 'package:re_state_action/re_state_action.dart';

@isTest
void reStateTest<T extends ReState<State>, State>(
  String description, {
  required T Function() buildReState,
  FutureOr<void> Function()? setUp,
  Iterable<State> Function()? seedStates,
  dynamic Function(T reState)? actReState,
  Duration? wait,
  dynamic Function(T reState, List<State> states)? expect,
  dynamic Function(List<Object> unhandledErrors)? expectErrors,
  dynamic Function(T reState)? verify,
  FutureOr<void> Function()? tearDown,
  bool skip = false,
  dynamic tags,
}) {
  test.test(
    description,
    () async {
      final states = <State>[];
      final uncaughtErrors = <Object>[];
      final reState = _wrapErrors(
        buildReState,
        uncaughtErrors,
        expectErrors != null,
      )!
        ..listenState(states.add);

      if (setUp != null) {
        _wrapErrors(
          setUp,
          uncaughtErrors,
          expectErrors != null,
        );
      }
      if (seedStates != null) {
        _wrapErrors(
          // ignore: invalid_use_of_protected_member
          () => seedStates.call().forEach(reState.emitState),
          uncaughtErrors,
          expectErrors != null,
        );
      }

      if (actReState != null) {
        _wrapErrors(
          () => actReState(reState),
          uncaughtErrors,
          expectErrors != null,
        );
      }

      await Future<void>.delayed(wait ?? Duration.zero);

      if (expect != null) expect(reState, states);
      if (verify != null) verify(reState);
      if (tearDown != null) await tearDown();
      reState
        ..removeStateListener(states.add)
        ..dispose();

      if (expectErrors != null) {
        expectErrors(uncaughtErrors);
      }
    },
    skip: skip,
    tags: tags,
  );
}

@isTest
void reStateActionTest<T extends ReStateAction<State, Action>, State, Action>(
  String description, {
  required T Function() buildReStateAction,
  FutureOr<void> Function()? setUp,
  Iterable<State> Function()? seedStates,
  Iterable<Action> Function()? seedActions,
  dynamic Function(T reState)? actReStateAction,
  Duration? wait,
  dynamic Function(T reState, List<State> states, List<Action> actions)? expect,
  dynamic Function(List<Object> unhandledErrors)? expectErrors,
  dynamic Function(T reState)? verify,
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

        final reStateAction = _wrapErrors(
          buildReStateAction,
          uncaughtErrors,
          expectErrors != null,
        )!
          ..listenState(states.add)
          ..listenAction(actions.add);

        if (setUp != null) {
          _wrapErrors(
            setUp,
            uncaughtErrors,
            expectErrors != null,
          );
        }

        if (seedStates != null) {
          _wrapErrors(
            // ignore: invalid_use_of_protected_member
            () => seedStates.call().forEach(reStateAction.emitState),

            uncaughtErrors,
            expectErrors != null,
          );
        }

        if (seedActions != null) {
          _wrapErrors(
            // ignore: invalid_use_of_protected_member
            () => seedActions.call().forEach(reStateAction.emitAction),
            uncaughtErrors,
            expectErrors != null,
          );
        }

        if (actReStateAction != null) {
          _wrapErrors(
            () => actReStateAction(reStateAction),
            uncaughtErrors,
            expectErrors != null,
          );
        }

        await Future<void>.delayed(wait ?? Duration.zero);

        if (expect != null) expect(reStateAction, states, actions);
        if (verify != null) verify(reStateAction);
        if (tearDown != null) await tearDown();
        reStateAction
          ..removeStateListener(states.add)
          ..removeActionListener(actions.add)
          ..dispose();

        if (expectErrors != null) {
          expectErrors(uncaughtErrors);
        }
      },
      skip: skip,
      tags: tags,
    );

T? _wrapErrors<T>(
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
