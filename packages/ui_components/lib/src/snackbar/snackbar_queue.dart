import 'package:flutter/widgets.dart';
import 'minimal_snackbar.dart';

class SnackbarQueue extends ChangeNotifier {
  final List<MinimalSnackbar> _queue = [];
  MinimalSnackbar? _current;

  MinimalSnackbar? get current => _current;

  void show(MinimalSnackbar snackbar) {
    _queue.add(snackbar);
    _processQueue();
  }

  void _processQueue() {
    if (_current == null && _queue.isNotEmpty) {
      _current = _queue.removeAt(0);
      notifyListeners();
    }
  }

  void dismiss() {
    _current = null;
    _processQueue();
    notifyListeners();
  }

  void clear() {
    _queue.clear();
    _current = null;
    notifyListeners();
  }
}
