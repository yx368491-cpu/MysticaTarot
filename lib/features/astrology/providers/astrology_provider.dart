import 'package:flutter/material.dart';
import '../domain/entities/zodiac_sign.dart';
import '../services/astrology_service.dart';

/// Astrology state management
class AstrologyProvider extends ChangeNotifier {
  final AstrologyService _service = AstrologyService();
  List<ZodiacSign> _allSigns = [];
  ZodiacSign? _selectedSign;
  int _selectedTab = 0; // 0=daily, 1=weekly, 2=monthly
  bool _isLoading = false;
  String? _errorMessage;

  List<ZodiacSign> get allSigns => _allSigns;
  ZodiacSign? get selectedSign => _selectedSign;
  int get selectedTab => _selectedTab;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init({String locale = 'en'}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allSigns = await _service.loadSigns();
    } catch (e) {
      _errorMessage = 'Failed to load zodiac data: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void setLocale(String locale) {
    notifyListeners();
  }

  void selectSign(ZodiacSign sign) {
    _selectedSign = sign;
    notifyListeners();
  }

  void selectTab(int tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  /// Find zodiac sign by birthday
  void selectSignByDate(int month, int day) {
    final sign = AstrologyService.getSignByDate(month, day, _allSigns);
    if (sign != null) {
      _selectedSign = sign;
      notifyListeners();
    }
  }

  String getElementIcon(String element) => AstrologyService.getElementIcon(element);
  String getZodiacIcon(int index) => AstrologyService.getZodiacIcon(index);

  int getSignIndex(ZodiacSign sign) => _allSigns.indexOf(sign);
}
