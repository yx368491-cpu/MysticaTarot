import 'package:flutter/material.dart';
import '../services/fortune_slip_service.dart';

/// Fortune slip state management
class FortuneSlipProvider extends ChangeNotifier {
  final FortuneSlipService _service = FortuneSlipService();
  FortuneSlip? _currentSlip;
  bool _isShaking = false;
  bool _isLoaded = false;
  String? _errorMessage;

  FortuneSlip? get currentSlip => _currentSlip;
  bool get isShaking => _isShaking;
  bool get isLoaded => _isLoaded;
  String? get errorMessage => _errorMessage;

  Future<void> init({String locale = 'en'}) async {
    _errorMessage = null;
    try {
      await _service.loadSlips();
      _isLoaded = true;
    } catch (e) {
      _errorMessage = 'Failed to load fortune slips: $e';
    }
    notifyListeners();
  }

  void setLocale(String locale) {
    notifyListeners();
  }

  /// Draw a fortune slip with shake animation
  Future<void> drawSlip() async {
    _isShaking = true;
    _currentSlip = null;
    notifyListeners();

    // Shake animation delay
    await Future.delayed(const Duration(milliseconds: 1500));

    _currentSlip = _service.drawSlip();
    _isShaking = false;
    notifyListeners();
  }

  void reset() {
    _currentSlip = null;
    _isShaking = false;
    notifyListeners();
  }
}
