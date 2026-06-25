import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../../core/util/json_normalize.dart';

/// Fortune slip entity
class FortuneSlip {
  final int id;
  final String grade; // daiji, chukichi, shokichi, kichi, suekichi, kyo
  final String gradeEn;
  final String gradeZh;
  final String gradeTl;
  final String textEn;
  final String textZh;
  final String textTl;

  const FortuneSlip({
    required this.id,
    required this.grade,
    required this.gradeEn,
    required this.gradeZh,
    required this.gradeTl,
    required this.textEn,
    required this.textZh,
    required this.textTl,
  });

  String localizedGrade(String locale) {
    switch (locale) {
      case 'zh': return gradeZh;
      case 'tl': return gradeTl;
      default: return gradeEn;
    }
  }

  String localizedText(String locale) {
    switch (locale) {
      case 'zh': return textZh;
      case 'tl': return textTl;
      default: return textEn;
    }
  }

  /// Get rank value for sorting (0=best, 5=worst)
  int get rank {
    switch (grade) {
      case 'daiji': return 0;
      case 'chukichi': return 1;
      case 'kichi': return 2;
      case 'shokichi': return 3;
      case 'suekichi': return 4;
      case 'kyo': return 5;
      default: return 3;
    }
  }

  /// Accepts any Map-like input (including Hive's dynamic-keyed read-back);
  /// see docs/bug-log.md entry 004.
  factory FortuneSlip.fromJson(dynamic raw) {
    final json = normalizeJsonMap(raw);
    return FortuneSlip(
      id: json['id'] as int? ?? 0,
      grade: json['grade'] as String? ?? '',
      gradeEn: json['gradeEn'] as String? ?? '',
      gradeZh: json['gradeZh'] as String? ?? '',
      gradeTl: json['gradeTl'] as String? ?? '',
      textEn: json['textEn'] as String? ?? '',
      textZh: json['textZh'] as String? ?? '',
      textTl: json['textTl'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FortuneSlip &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          grade == other.grade &&
          gradeEn == other.gradeEn &&
          gradeZh == other.gradeZh &&
          gradeTl == other.gradeTl &&
          textEn == other.textEn &&
          textZh == other.textZh &&
          textTl == other.textTl;

  @override
  int get hashCode =>
      Object.hash(id, grade, gradeEn, gradeZh, gradeTl, textEn, textZh, textTl);
}

/// Static entrypoint for `compute()` so the JSON decode + mapping happens
/// in a background isolate. P3 perf — see `docs/phase7-startup-checklist.md`.
List<FortuneSlip> parseFortuneSlips(String jsonStr) {
  final List<dynamic> jsonList = json.decode(jsonStr) as List<dynamic>;
  return jsonList.map((e) => FortuneSlip.fromJson(e)).toList(growable: false);
}

/// Service for fortune slip functionality
class FortuneSlipService {
  List<FortuneSlip> _allSlips = [];
  final Random _random = Random();

  bool get isLoaded => _allSlips.isNotEmpty;

  /// Load fortune slips from JSON (parse runs off the main isolate).
  Future<List<FortuneSlip>> loadSlips() async {
    if (_allSlips.isNotEmpty) return _allSlips;
    final jsonStr = await rootBundle.loadString(
        'lib/features/fortune_slip/data/json/fortune_slips.json');
    _allSlips = await compute(parseFortuneSlips, jsonStr);
    return _allSlips;
  }

  /// Draw a random fortune slip
  FortuneSlip drawSlip() {
    if (_allSlips.isEmpty) {
      throw StateError('Fortune slips not loaded');
    }
    return _allSlips[_random.nextInt(_allSlips.length)];
  }

  /// Get the grade color
  static String getGradeEmoji(String grade) {
    switch (grade) {
      case 'daiji': return '🎉';
      case 'chukichi': return '🌟';
      case 'kichi': return '✨';
      case 'shokichi': return '💫';
      case 'suekichi': return '🌱';
      case 'kyo': return '🍂';
      default: return '🔮';
    }
  }
}
