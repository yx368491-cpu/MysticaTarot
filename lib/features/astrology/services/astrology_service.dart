import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../domain/entities/zodiac_sign.dart';

/// Service for astrology / zodiac functionality
class AstrologyService {
  List<ZodiacSign>? _allSigns;

  /// Background-isolate entrypoint referenced by [loadSigns] through
  /// `compute(parseSigns, jsonStr)`.
  ///
  /// Intentionally NOT underscore-prefixed: `compute()` requires a
  /// reference to a top-level or static callable that is reachable from a
  /// fresh isolate, and we also want unit tests to invoke it directly
  /// without juggling `compute()`. Do NOT rename to private — both the
  /// isolate boundary and the test surface will break silently.
  ///
  /// P3 perf: triggers per `docs/phase7-startup-checklist.md` (move JSON
  /// decode off the main isolate when the parse exceeds frame budget).
  static List<ZodiacSign> parseSigns(String jsonStr) {
    final List<dynamic> jsonList = json.decode(jsonStr) as List<dynamic>;
    return jsonList
        .map((e) => ZodiacSign.fromJson(e))
        .toList(growable: false);
  }

  /// Load zodiac data from JSON asset (parse runs off the main isolate).
  Future<List<ZodiacSign>> loadSigns() async {
    if (_allSigns != null) return _allSigns!;
    final jsonStr = await rootBundle.loadString(
        'lib/features/astrology/data/json/zodiac_content.json');
    _allSigns = await compute(parseSigns, jsonStr);
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
