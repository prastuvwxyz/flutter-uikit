import 'package:flutter/foundation.dart';

/// Simple controller to hold OTP value and notify listeners.
class OTPController extends ChangeNotifier {
  OTPController({String? text}) : _text = text ?? '';

  String _text;

  String get text => _text;

  set text(String value) {
    if (_text == value) return;
    _text = value;
    notifyListeners();
  }

  void clear() {
    if (_text.isEmpty) return;
    _text = '';
    notifyListeners();
  }
}
