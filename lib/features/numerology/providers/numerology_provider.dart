import 'package:flutter/material.dart';
import '../domain/entities/life_path_number.dart';
import '../services/numerology_service.dart';

/// Numerology state management
class NumerologyProvider extends ChangeNotifier {
  int? _lifePathNumber;
  int? _destinyNumber;
  LifePathNumber? _lifePathData;
  String? _errorMessage;

  int? get lifePathNumber => _lifePathNumber;
  int? get destinyNumber => _destinyNumber;
  LifePathNumber? get lifePathData => _lifePathData;
  String? get errorMessage => _errorMessage;
  bool get hasResults => _lifePathNumber != null;

  void setLocale(String locale) {
    notifyListeners();
  }

  /// Calculate from birthday
  void calculateByBirthday(int year, int month, int day) {
    _errorMessage = null;
    _lifePathNumber = NumerologyService.calculateLifePathNumber(year, month, day);
    _lifePathData = NumerologyService.getLifePathData(_lifePathNumber!);
    notifyListeners();
  }

  /// Calculate destiny number from name
  void calculateDestiny(String fullName) {
    if (fullName.trim().isEmpty) {
      _errorMessage = 'Please enter a valid name';
      notifyListeners();
      return;
    }
    _destinyNumber = NumerologyService.calculateDestinyNumber(fullName);
    notifyListeners();
  }

  void reset() {
    _lifePathNumber = null;
    _destinyNumber = null;
    _lifePathData = null;
    _errorMessage = null;
    notifyListeners();
  }
}
