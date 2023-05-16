import 'package:re_state_action_test/re_state_action_test.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  group(
    'reStateTest',
    () {
      reStateTest<TestState, int>(
        'emits the initial state when nothing is added',
        buildReState: () => TestState(0),
        expectStates: () => [0],
      );

      reStateTest<TestState, int>(
        'emits [0, 1] when increment is called',
        buildReState: () => TestState(0),
        actReState: (reState) => reState.increment(),
        expectStates: () => [0, 1],
      );

      reStateTest<TestState, int>(
        'emits [0, 1, 3] when increment is called after seed [1, 2]',
        buildReState: () => TestState(0),
        seedStates: () => [1, 2],
        actReState: (reState) => reState.increment(),
        expectStates: () => [0, 1, 3],
      );

      reStateTest<TestState, int>(
        'throws a StateError when emitState is called after dispose',
        buildReState: () => TestState(0),
        actReState: (reState) => reState
          ..dispose()
          ..increment(),
        expectErrors: () => [isStateError],
      );

      reStateTest<WrongTestStateEvent, int>(
        'throws a StateError when instantiate a invalid ReStateEvent',
        buildReState: () => WrongTestStateEvent(0),
        expectErrors: () => [isStateError],
      );
    },
  );
}
