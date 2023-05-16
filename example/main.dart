// ignore_for_file: lines_longer_than_80_chars

import 'package:re_state_action/re_state_action.dart';
import 'package:re_state_action_test/re_state_action_test.dart';
import 'package:test/test.dart';

class ExampleReState extends ReState<int> {
  ExampleReState(int initialState) : super(initialState);

  void increment() {
    emitState(state + 1);
  }
}

class BadExampleReStateEvent extends ReStateEvent<int, CounterEvent> {
  BadExampleReStateEvent(int initialState) : super(initialState) {
    on<IncrementEvent>((event) => _increment());
    on<IncrementEvent>((event) => _increment());
  }

  void _increment() {
    emitState(state + 1);
  }
}

abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class ExampleReStateAction extends ReStateAction<int, String> {
  ExampleReStateAction(int initialState) : super(initialState);

  void increment() {
    emitState(state + 1);
  }

  void dispatchAction() {
    emitAction('action');
  }
}

void main() {
  mainReState();
  mainReStateAction();
}

void mainReState() {
  group(
    'reStateTest',
    () {
      reStateTest<ExampleReState, int>(
        'emits the initial state when nothing is added',
        buildReState: () => ExampleReState(0),
        expectStates: () => [0],
      );

      reStateTest<ExampleReState, int>(
        'emits [0, 1] when increment is called',
        buildReState: () => ExampleReState(0),
        actReState: (reState) => reState.increment(),
        expectStates: () => [0, 1],
      );

      reStateTest<ExampleReState, int>(
        'emits [0, 1, 3] when increment is called after seed [1, 2]',
        buildReState: () => ExampleReState(0),
        seedStates: () => [1, 2],
        actReState: (reState) => reState.increment(),
        expectStates: () => [0, 1, 2, 3],
      );

      reStateTest<ExampleReState, int>(
        'throws a StateError when emitState is called after dispose',
        buildReState: () => ExampleReState(0),
        actReState: (reState) => reState
          ..dispose()
          ..increment(),
        expectErrors: () => [isStateError],
      );

      reStateTest<BadExampleReStateEvent, int>(
        'throws a StateError when instantiate an invalid ReStateEvent',
        buildReState: () => BadExampleReStateEvent(0),
        expectErrors: () => [isStateError],
      );
    },
  );
}

void mainReStateAction() {
  group(
    'reStateActionTest',
    () {
      reStateActionTest<ExampleReStateAction, int, String>(
        'emits the initial state when nothing is added',
        buildReStateAction: () => ExampleReStateAction(0),
        expectStates: () => [0],
      );

      reStateActionTest<ExampleReStateAction, int, String>(
        'emits [0, 1] when increment is called',
        buildReStateAction: () => ExampleReStateAction(0),
        actReStateAction: (reState) => reState.increment(),
        expectStates: () => [0, 1],
      );

      reStateActionTest<ExampleReStateAction, int, String>(
        'emits [0, 1, 3] when increment is called after seed [1, 2]',
        buildReStateAction: () => ExampleReStateAction(0),
        seedStates: () => [1, 2],
        actReStateAction: (reState) => reState.increment(),
        expectStates: () => [0, 1, 2, 3],
      );

      reStateActionTest<ExampleReStateAction, int, String>(
        'throws a StateError when emitState is called after dispose',
        buildReStateAction: () => ExampleReStateAction(0),
        actReStateAction: (reState) => reState
          ..dispose()
          ..increment(),
        expectErrors: () => [isStateError],
      );

      reStateActionTest<ExampleReStateAction, int, String>(
        'emits ["action"] when dispatchAction is called',
        buildReStateAction: () => ExampleReStateAction(0),
        actReStateAction: (reState) => reState.dispatchAction(),
        expectActions: () => ['action'],
      );

      reStateActionTest<ExampleReStateAction, int, String>(
        'emits ["action", "action"] when dispatchAction is called after seed action',
        buildReStateAction: () => ExampleReStateAction(0),
        seedActions: () => ['action'],
        actReStateAction: (reState) => reState.dispatchAction(),
        expectActions: () => ['action', 'action'],
      );
    },
  );
}
