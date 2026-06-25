import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Onboarding state management
///
/// Tracks whether the user has completed the onboarding flow.
/// Persists to Hive 'settings' box under key 'onboardingCompleted'.
class OnboardingProvider extends ChangeNotifier {
  static const String _storageKey = 'onboardingCompleted';

  bool _isCompleted = false;
  bool _isLoaded = false;

  bool get isCompleted => _isCompleted;
  bool get isLoaded => _isLoaded;

  /// Load onboarding state from Hive. Called once during app startup.
  Future<void> init() async {
    final box = Hive.box('settings');
    _isCompleted = box.get(_storageKey, defaultValue: false) as bool;
    _isLoaded = true;
    notifyListeners();
  }

  /// Mark onboarding as completed (persisted to Hive).
  Future<void> markCompleted() async {
    if (_isCompleted) return;
    _isCompleted = true;
    final box = Hive.box('settings');
    await box.put(_storageKey, true);
    notifyListeners();
  }

  /// Reset onboarding state (for debug/testing or "Show onboarding again" option).
  Future<void> reset() async {
    _isCompleted = false;
    final box = Hive.box('settings');
    await box.put(_storageKey, false);
    notifyListeners();
  }
}
