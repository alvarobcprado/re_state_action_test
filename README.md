<div style="text-align: center; font-family: times new roman">
<h1><span style="color:#7e71ac"><strong>Re</strong></span>:StateAction Test</h1>
  <a href="https://pub.dev/packages/re_state_action_test"><img src="https://img.shields.io/pub/v/re_state_action_test.svg" alt="Pub.dev Badge"></a>
	<a href="https://github.com/alvarobcprado/re_state_action/actions"><img src="https://github.com/alvarobcprado/re_state_action_test/actions/workflows/test.yml/badge.svg" alt="GitHub Build Badge"></a>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
    <a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="Very Good Analysis Style Badge"></a>
</div>

## About

This package is a wrapper of the default unit test to make it easier to test the [ReStateAction](https://pub.dev/packages/re_state_action) package.

## Usage

To use this package, add `re_state_action_test` as a dev dependency in your pubspec.yaml file.

## Unit Test with reStateTest

`reStateTest` Creates a test case for a `ReState` with the given `description`.
`reStateTest` is a wrapper around conventional unit `test` that handles
assertions for `expectStates` and `expectErrors` emitted in order
by the `ReState`.

`buildReState` is a function that returns a `ReState` instance to be tested.

`setUp` is an optional function that is called before the test case to
prepare the test environment.

`seedStates` is an optional function that returns an iterable of states to
seed the `ReState` with before the test `actReState` is called.

`actReState` is an optional function that is called to perform an action on
the `ReState` under test. Should be used to interact with the `ReState`.

`wait` is an optional duration to wait before asserting the `expectStates`.

`expectStates` is an optional function that returns a matcher that verifies the states that are expected to be emitted by the `ReState` in order.

`expectErrors` is an optional function that returns a matcher that verifies the errors that are expected to be thrown by the `ReState` in order.

`verifyReState` is an optional function that is called to verify the
`ReState` after the test expectations have been asserted.

`tearDown` is an optional function that is called after the test case to
clean up the test environment.

`skip` is an optional boolean that can be used to skip the test case.

`tags` is an optional dynamic that can be used to tag the test case.

Examples:
```dart
reStateTest<CounterReState, int>(
 'should emit states in order',
  buildReState: () => CounterReState(initialState: 0),
  actReState: (reState) => reState.increment(),
  expectStates: () => [0, 1],
);
```

`seedStates` can be used to seed the `ReState` with states before the test

```dart
reStateTest<CounterReState, int>(
  'should emit states in order',
  buildReState: () => CounterReState(initialState: 0),
  seedStates: () => [1, 2],
  actReState: (reState) => reState.increment(),
  expectStates: () => [0, 1, 2, 3],
);
```

## Unit Test with reStateActionTest
`reStateActionTest` Creates a test case for a `ReStateAction` with the given `description`.
`reStateActionTest` is a wrapper around conventional unit `test` that
handles assertions for `expectStates`, `expectActions` and `expectErrors`
emitted in order by the `ReStateAction`.

`buildReStateAction` is a function that returns a `ReState` instance to be
tested.

`setUp` is an optional function that is called before the test case to
prepare the test environment.

`seedStates` is an optional function that returns an iterable of states to
seed the `ReStateAction` with before the test `actReStateAction` is called.

`seedActions` is an optional function that returns an iterable of actions to
seed the `ReStateAction` with before the test `actReStateAction` is called.

`actReStateAction` is an optional function that is called to perform an
action on the `ReStateAction` under test. Should be used to interact with
the `ReStateAction`.

`wait` is an optional duration to wait before asserting the `expectStates`.

`expectStates`  is an optional function that returns a matcher that verifies the states that are expected to be emitted by the `ReStateAction` in order.

`expectActions` is an optional function that returns a matcher that verifies the actions that are expected to be emitted by the `ReStateAction` in order.

`expectErrors` is an optional function that returns a matcher that verifies the errors that are expected to be thrown by the `ReStateAction` in order.

`verifyReStateAction` is an optional function that is called to verify the
`ReStateAction` after the test expectations have been asserted.

`tearDown` is an optional function that is called after the test case to
clean up the test environment.

`skip` is an optional boolean that can be used to skip the test case.

`tags` is an optional dynamic that can be used to tag the test case.

Examples:
```dart
reStateTestAction<CounterReStateAction, int, CounterAction>(
  'should emit states and actions in order',
  buildReStateAction: () => CounterReStateAction(initialState: 0),
  actReStateAction: (reStateAction) => reStateAction.increment(),
  expectStates: () => [0, 1],
  expectActions: () => [ShowSnackBarAction()],
);
```

`seedStates` can be used to seed the `ReState` with states before the test

```dart
reStateTestAction<CounterReStateAction, int, CounterAction>(
  'should emit states and actions in order',
  buildReStateAction: () => CounterReStateAction(initialState: 0),
  seedStates: () => [1, 2],
  seedActions: () => [ShowSnackBarAction()],
  actReStateAction: (reStateAction) => reStateAction.increment(),
  expectStates: () => [0, 1, 2, 3],
  expectActions: () => [ShowSnackBarAction(), ShowSnackBarAction()],
);
```

## Contributing

We welcome contributions to this package. If you would like to contribute, please feel free to open an issue or a pull request.

## License

ReStateAction is licensed under the MIT License. See the [LICENSE](https://github.com/alvarobcprado/re_state_action_test/blob/main/LICENSE) for details.
