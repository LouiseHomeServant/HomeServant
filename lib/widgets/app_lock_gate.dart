import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import 'app_lock_screen.dart';

/// Wraps the whole app (via `MaterialApp.builder`) and shows [AppLockScreen]
/// over everything whenever the app returns to the foreground after being
/// backgrounded, or on a fresh cold start if App Lock was already on when
/// this launch started (turning it on mid-session doesn't itself re-lock
/// the app you're already in — only the next background/resume or restart
/// does).
///
/// Disabled entirely on web ([kIsWeb]): there's no real backgrounding to
/// guard against in a browser tab, and a PIN gate in front of a page anyone
/// can just refresh past isn't meaningful security.
class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  bool _locked = false;
  bool _wasBackgrounded = false;

  // Set once, the first time AppState.isLoaded turns true (see build()), so
  // the cold-start lock decision reflects the setting as it was *before*
  // this launch — not a value flipped live during the current session (e.g.
  // finishing PIN setup in Settings shouldn't re-lock you out immediately).
  bool _checkedInitialLockState = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final appState = context.read<AppState>();
    if (!appState.appLockEnabled || appState.appLockPin == null) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _wasBackgrounded = true;
    } else if (state == AppLifecycleState.resumed && _wasBackgrounded) {
      _wasBackgrounded = false;
      setState(() => _locked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return widget.child;
    final appState = context.watch<AppState>();
    if (!_checkedInitialLockState && appState.isLoaded) {
      _checkedInitialLockState = true;
      _locked = appState.appLockEnabled;
    }
    final pin = appState.appLockPin;
    final showLock = _locked && appState.appLockEnabled && pin != null;
    return Stack(
      children: [
        widget.child,
        if (showLock) AppLockScreen(expectedPin: pin, onUnlocked: () => setState(() => _locked = false)),
      ],
    );
  }
}
