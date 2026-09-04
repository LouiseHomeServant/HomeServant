import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:homeservant/state/app_state.dart';
import 'package:homeservant/widgets/app_lock_gate.dart';
import 'package:homeservant/widgets/app_lock_screen.dart';

Future<void> _sendLifecycleState(WidgetTester tester, AppLifecycleState state) async {
  final message = const StringCodec().encodeMessage(state.toString());
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage('flutter/lifecycle', message, (_) {});
}

Future<void> _enterPin(WidgetTester tester, String pin) async {
  for (final digit in pin.split('')) {
    await tester.tap(find.text(digit));
    await tester.pump();
  }
}

Future<void> _pumpGate(WidgetTester tester, AppState appState) {
  return tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(home: AppLockGate(child: const Scaffold(body: Text('Home content')))),
    ),
  );
}

void main() {
  setUp(() {
    // AppState.notifyListeners() persists to SharedPreferences on every
    // change; this stubs the plugin so those writes don't hit a real
    // platform channel during tests.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('AppLockGate shows the lock screen immediately on cold start when App Lock was already on', (
    tester,
  ) async {
    // isLoaded mirrors what AppState.load() would set after restoring a
    // previous session where App Lock was already turned on.
    final appState = AppState()..enableAppLock('1234');
    appState.isLoaded = true;

    await _pumpGate(tester, appState);
    await tester.pumpAndSettle();

    expect(find.byType(AppLockScreen), findsOneWidget, reason: 'App Lock was already on when the app mounted');
  });

  testWidgets('AppLockGate unlocks with the correct PIN, then re-locks after being backgrounded and resumed', (
    tester,
  ) async {
    final appState = AppState()..enableAppLock('1234');
    appState.isLoaded = true;

    await _pumpGate(tester, appState);
    await tester.pumpAndSettle();
    expect(find.byType(AppLockScreen), findsOneWidget);

    await _enterPin(tester, '1234');
    await tester.pumpAndSettle();
    expect(find.byType(AppLockScreen), findsNothing, reason: 'the correct PIN should unlock it');

    await _sendLifecycleState(tester, AppLifecycleState.paused);
    await tester.pump();
    await _sendLifecycleState(tester, AppLifecycleState.resumed);
    await tester.pump();

    expect(find.byType(AppLockScreen), findsOneWidget, reason: 'expected the PIN gate to reappear after resuming from background');
  });

  testWidgets('turning App Lock on mid-session does not immediately re-lock the app you are already in', (
    tester,
  ) async {
    // Simulate a normal launch where App Lock was off, already past the
    // cold-start check — then the user turns it on from Settings.
    final appState = AppState();
    appState.isLoaded = true;

    await _pumpGate(tester, appState);
    await tester.pumpAndSettle();
    expect(find.byType(AppLockScreen), findsNothing);

    appState.enableAppLock('1234');
    await tester.pumpAndSettle();

    expect(
      find.byType(AppLockScreen),
      findsNothing,
      reason: 'should only take effect on the next background/resume or restart, not interrupt the current session',
    );

    // But the next background/resume cycle does lock it.
    await _sendLifecycleState(tester, AppLifecycleState.paused);
    await tester.pump();
    await _sendLifecycleState(tester, AppLifecycleState.resumed);
    await tester.pump();

    expect(find.byType(AppLockScreen), findsOneWidget);
  });

  testWidgets('AppLockGate never locks when App Lock is disabled', (tester) async {
    final appState = AppState();
    appState.isLoaded = true;

    await _pumpGate(tester, appState);
    await tester.pumpAndSettle();
    expect(find.byType(AppLockScreen), findsNothing);

    await _sendLifecycleState(tester, AppLifecycleState.paused);
    await tester.pump();
    await _sendLifecycleState(tester, AppLifecycleState.resumed);
    await tester.pump();

    expect(find.byType(AppLockScreen), findsNothing);
  });
}
