import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'pin_keypad.dart';

const _pinLength = 4;

/// Full-screen PIN gate shown over the whole app when App Lock is enabled
/// and the app returns from the background. Cannot be dismissed except by
/// entering the correct PIN.
class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key, required this.expectedPin, required this.onUnlocked});

  final String expectedPin;
  final VoidCallback onUnlocked;

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String _entry = '';
  String? _error;

  void _onDigit(String digit) {
    if (_entry.length >= _pinLength) return;
    setState(() {
      _entry += digit;
      _error = null;
    });
    if (_entry.length == _pinLength) {
      if (_entry == widget.expectedPin) {
        widget.onUnlocked();
      } else {
        setState(() {
          _error = 'Incorrect PIN';
          _entry = '';
        });
      }
    }
  }

  void _onBackspace() {
    if (_entry.isEmpty) return;
    setState(() => _entry = _entry.substring(0, _entry.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: AppColors.navy,
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              // Without this, the keypad's width-driven row height (see
              // PinKeypad's childAspectRatio) blows up on any viewport wider
              // than a phone — a browser window or tablet — tall enough to
              // push the keypad below the screen, silently making the lock
              // gate unusable even though it "shows" fine.
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 40),
                    const SizedBox(height: 16),
                    Text('Enter your PIN', style: AppTextStyles.heading(color: Colors.white, size: 20)),
                    const SizedBox(height: 20),
                    PinDots(length: _pinLength, filled: _entry.length, color: Colors.white),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: AppTextStyles.body(color: Colors.redAccent.shade100, size: 13)),
                    ],
                    const SizedBox(height: 16),
                    PinKeypad(onDigit: _onDigit, onBackspace: _onBackspace, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
