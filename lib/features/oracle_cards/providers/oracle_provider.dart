import 'package:flutter/material.dart';
import '../services/oracle_reading_service.dart';

/// Oracle card state management
class OracleProvider extends ChangeNotifier {
  final OracleReadingService _service = OracleReadingService();
  List<OracleReadingResult> _results = [];
  bool _isLoading = true;
  bool _isDrawing = false;
  int _cardMode = 1; // 1 or 3 cards
  String? _errorMessage;

  List<OracleReadingResult> get results => _results;
  bool get isLoading => _isLoading;
  bool get isDrawing => _isDrawing;
  int get cardMode => _cardMode;
  String? get errorMessage => _errorMessage;
  bool get hasResults => _results.isNotEmpty;

  Future<void> init({String locale = 'en'}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _service.loadCards();
    } catch (e) {
      _errorMessage = 'Failed to load oracle cards: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  void setCardMode(int mode) {
    _cardMode = mode;
    notifyListeners();
  }

  /// Draw oracle cards with animation delay
  Future<void> drawCards() async {
    _isDrawing = true;
    _results = [];
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    if (_cardMode == 1) {
      _results = [_service.drawSingleCard()];
    } else {
      _results = _service.drawCards(3);
    }
    _isDrawing = false;
    notifyListeners();
  }

  String getPositionName(int index, String locale) {
    if (_cardMode == 1) {
      return OraclePosition.singlePositions[0].localizedName(locale);
    }
    const positions = OraclePosition.triplePositions;
    if (index < positions.length) {
      return positions[index].localizedName(locale);
    }
    return 'Position ${index + 1}';
  }

  void reset() {
    _results = [];
    _isDrawing = false;
    notifyListeners();
  }
}
