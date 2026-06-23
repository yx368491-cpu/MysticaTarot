import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/daily_card_service.dart';

/// Daily card state management
class DailyCardProvider extends ChangeNotifier {
  final DailyCardService _service = DailyCardService();
  DailyCardResult? _todayCard;
  bool _isLoading = false;
  bool _isDrawn = false;
  String? _errorMessage;

  DailyCardResult? get todayCard => _todayCard;
  bool get isLoading => _isLoading;
  bool get isDrawn => _isDrawn;
  String? get errorMessage => _errorMessage;

  /// Initialize: check if today's card already exists
  Future<void> init() async {
    final box = Hive.box('daily_card');
    final today = _todayString();
    final cached = box.get(today) as Map<String, dynamic>?;
    if (cached != null) {
      _isDrawn = true;
      // Re-generate card based on cached info
      try {
        _todayCard = await _service.getDailyCard();
      } catch (_) {
        // Silently fall back
      }
    }
    notifyListeners();
  }

  /// Draw today's card
  Future<void> drawDailyCard() async {
    if (_isDrawn) return;

    _isLoading = true;
    notifyListeners();

    try {
      _todayCard = await _service.getDailyCard();
      _isDrawn = true;

      // Cache to Hive so we don't re-draw today
      final box = Hive.box('daily_card');
      await box.put(_todayString(), {'drawn': true, 'date': _todayString()});
    } catch (e) {
      _errorMessage = 'Failed to draw daily card: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check if user has already drawn for today
  bool hasDrawnToday() {
    final box = Hive.box('daily_card');
    return box.get(_todayString()) != null;
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
