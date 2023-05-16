// ignore_for_file: lines_longer_than_80_chars

import 'package:re_state_action_test/re_state_action_test.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  group(
    'reStateActionTest',
    () {
      reStateActionTest<TestStateAction, int, String>(
        'emits the initial state when nothing is added',
        buildReStateAction: () => TestStateAction(0),
        expectStates: () => [0],
      );

      reStateActionTest<TestStateAction, int, String>(
        'emits [0, 1] when increment is called',
        buildReStateAction: () => TestStateAction(0),
        actReStateAction: (reState) => reState.increment(),
        expectStates: () => [0, 1],
      );

      reStateActionTest<TestStateAction, int, String>(
        'emits [0, 1, 3] when increment is called after seed [1, 2]',
        buildReStateAction: () => TestStateAction(0),
        seedStates: () => [1, 2],
        actReStateAction: (reState) => reState.increment(),
        expectStates: () => [0, 1, 2, 3],
      );

      reStateActionTest<TestStateAction, int, String>(
        'throws a StateError when emitState is called after dispose',
        buildReStateAction: () => TestStateAction(0),
        actReStateAction: (reState) => reState
          ..dispose()
          ..increment(),
        expectErrors: () => [isStateError],
      );

      reStateActionTest<TestStateAction, int, String>(
        'emits ["action"] when dispatchAction is called',
        buildReStateAction: () => TestStateAction(0),
        actReStateAction: (reState) => reState.dispatchAction(),
        expectActions: () => ['action'],
      );

      reStateActionTest<TestStateAction, int, String>(
        'emits ["action", "action"] when dispatchAction is called after seed action',
        buildReStateAction: () => TestStateAction(0),
        seedActions: () => ['action'],
        actReStateAction: (reState) => reState.dispatchAction(),
        expectActions: () => ['action', 'action'],
      );
    },
  );
}
