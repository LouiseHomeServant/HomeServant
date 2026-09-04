import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'pin_keypad.dart';

const _pinLength = 4;

/// Two-step "enter, then confirm" PIN setup. Returns the chosen PIN, or
/// null if the sheet was dismissed before completing.
Future<String?> showSetAppLockPinSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (context) => const _SetPinSheet(),
  );
}

/// Asks for the existing PIN (used when turning App Lock off). Returns
/// true only if the entered PIN matched.
Future<bool> showVerifyAppLockPinSheet(BuildContext context, {required String expectedPin, required String title}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (context) => _VerifyPinSheet(expectedPin: expectedPin, title: title),
  );
  return result ?? false;
}

class _SetPinSheet extends StatefulWidget {
  const _SetPinSheet();

  @override
  State<_SetPinSheet> createState() => _SetPinSheetState();
}

class _SetPinSheetState extends State<_SetPinSheet> {
  String _firstPin = '';
  String _entry = '';
  bool _confirming = false;
  String? _error;

  void _onDigit(String digit) {
    if (_entry.length >= _pinLength) return;
    setState(() {
      _entry += digit;
      _error = null;
    });
    if (_entry.length == _pinLength) _onComplete();
  }

  void _onBackspace() {
    if (_entry.isEmpty) return;
    setState(() => _entry = _entry.substring(0, _entry.length - 1));
  }

  void _onComplete() {
    if (!_confirming) {
      final first = _entry;
      setState(() {
        _firstPin = first;
        _entry = '';
        _confirming = true;
      });
      return;
    }
    if (_entry == _firstPin) {
      Navigator.of(context).pop(_firstPin);
    } else {
      setState(() {
        _error = "PINs didn't match — try again";
        _firstPin = '';
        _entry = '';
        _confirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        // Bottom sheets span the full viewport width by default — on a wide
        // browser window or tablet that stretches the keypad's width-driven
        // row height (see PinKeypad's childAspectRatio) tall enough to push
        // it off-screen, so this caps it to a phone-like width.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _confirming ? 'Confirm your PIN' : 'Set a 4-digit PIN',
                  style: AppTextStyles.heading(color: AppColors.navy, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  "You'll be asked for this whenever Home Servant reopens.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(color: AppColors.hintGrey, size: 13),
                ),
                const SizedBox(height: 20),
                PinDots(length: _pinLength, filled: _entry.length),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: AppTextStyles.body(color: Colors.redAccent, size: 13)),
                ],
                const SizedBox(height: 12),
                PinKeypad(onDigit: _onDigit, onBackspace: _onBackspace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerifyPinSheet extends StatefulWidget {
  const _VerifyPinSheet({required this.expectedPin, required this.title});

  final String expectedPin;
  final String title;

  @override
  State<_VerifyPinSheet> createState() => _VerifyPinSheetState();
}

class _VerifyPinSheetState extends State<_VerifyPinSheet> {
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
        Navigator.of(context).pop(true);
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
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title, textAlign: TextAlign.center, style: AppTextStyles.heading(color: AppColors.navy, size: 18)),
                const SizedBox(height: 20),
                PinDots(length: _pinLength, filled: _entry.length),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: AppTextStyles.body(color: Colors.redAccent, size: 13)),
                ],
                const SizedBox(height: 12),
                PinKeypad(onDigit: _onDigit, onBackspace: _onBackspace),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel', style: AppTextStyles.body(color: AppColors.hintGrey, weight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
