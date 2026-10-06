// Placeholder for Riverpod ViewModel to handle dashboard logic
import 'package:flutter/foundation.dart';

class DashboardViewModel extends ChangeNotifier {
  bool _isTracking = false;
  bool get isTracking => _isTracking;

  void toggleTracking() {
    _isTracking = !_isTracking;
    notifyListeners();
  }
}
