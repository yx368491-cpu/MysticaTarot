import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/entities/zodiac_sign.dart';

/// Service for astrology / zodiac functionality
class AstrologyService {
  List<ZodiacSign>? _allSigns;

  /// Load zodiac data from JSON asset
  Future<List<ZodiacSign>> loadSigns() async {
    if (_allSigns != null) return _allSigns!;
    final jsonStr = await rootBundle.loadString('features/astrology/data/json/zodiac_content.json');
    final List<dynamic> jsonList = json.decode(jsonStr) as List<dynamic>;
    _allSigns = jsonList.map((e) => ZodiacSign.fromJson(e as Map<String, dynamic>)).toList();
    return _allSigns!;
  }

  /// Get zodiac sign by index (0=Aries, 11=Pisces)
  ZodiacSign? getSignByIndex(int index) {
    if (_allSigns == null || index < 0 || index >= _allSigns!.length) return null;
    return _allSigns![index];
  }

  /// Determine zodiac sign from birth date
  static ZodiacSign? getSignByDate(int month, int day, List<ZodiacSign> signs) {
    if (signs.isEmpty) return null;
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return signs[0]; // Aries
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return signs[1]; // Taurus
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return signs[2]; // Gemini
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return signs[3]; // Cancer
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return signs[4]; // Leo
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return signs[5]; // Virgo
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return signs[6]; // Libra
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return signs[7]; // Scorpio
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return signs[8]; // Sagittarius
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return signs[9]; // Capricorn
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return signs[10]; // Aquarius
    return signs[11]; // Pisces
  }

  /// Get icon name for zodiac sign
  static String getZodiacIcon(int index) {
    const icons = [
      '♈', '♉', '♊', '♋', '♌', '♍',
      '♎', '♏', '♐', '♑', '♒', '♓',
    ];
    return icons[index % icons.length];
  }

  /// Get element icon
  static String getElementIcon(String element) {
    switch (element.toLowerCase()) {
      case 'fire': return '🔥';
      case 'earth': return '🌍';
      case 'air': return '💨';
      case 'water': return '💧';
      default: return '✨';
    }
  }
}
