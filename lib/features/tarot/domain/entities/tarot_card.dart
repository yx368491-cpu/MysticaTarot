/// Tarot card entity representing a single card in the deck
class TarotCard {
  final int id;
  final String type; // 'major' or 'minor'
  final int number;
  final String nameEn;
  final String nameZh;
  final String nameTl;
  final String? suit;
  final String? suitZh;
  final String? suitTl;
  final String? element;
  final String? elementZh;
  final List<String> keywordsEn;
  final List<String> keywordsZh;
  final List<String> keywordsTl;
  final String meaningUprightEn;
  final String meaningUprightZh;
  final String meaningUprightTl;
  final String meaningReversedEn;
  final String meaningReversedZh;
  final String meaningReversedTl;
  final String loveEn;
  final String loveZh;
  final String loveTl;
  final String careerEn;
  final String careerZh;
  final String careerTl;
  final String adviceEn;
  final String adviceZh;
  final String adviceTl;

  const TarotCard({
    required this.id,
    required this.type,
    required this.number,
    required this.nameEn,
    required this.nameZh,
    required this.nameTl,
    this.suit,
    this.suitZh,
    this.suitTl,
    this.element,
    this.elementZh,
    required this.keywordsEn,
    required this.keywordsZh,
    required this.keywordsTl,
    required this.meaningUprightEn,
    required this.meaningUprightZh,
    required this.meaningUprightTl,
    required this.meaningReversedEn,
    required this.meaningReversedZh,
    required this.meaningReversedTl,
    required this.loveEn,
    required this.loveZh,
    required this.loveTl,
    required this.careerEn,
    required this.careerZh,
    required this.careerTl,
    required this.adviceEn,
    required this.adviceZh,
    required this.adviceTl,
  });

  /// Get image asset path
  String get imagePath {
    final subdir = type == 'major' ? 'major' : 'minor';
    final fileName = nameEn.replaceAll(' ', '_').replaceAll(',', '');
    return 'assets/images/cards/$subdir/$fileName.png';
  }

  /// Get card name in given locale
  String localizedName(String locale) {
    switch (locale) {
      case 'zh': return nameZh;
      case 'tl': return nameTl;
      default: return nameEn;
    }
  }

  /// Get keywords in given locale
  List<String> localizedKeywords(String locale) {
    switch (locale) {
      case 'zh': return keywordsZh;
      case 'tl': return keywordsTl;
      default: return keywordsEn;
    }
  }

  /// Get upright meaning in given locale
  String localizedUprightMeaning(String locale) {
    switch (locale) {
      case 'zh': return meaningUprightZh;
      case 'tl': return meaningUprightTl;
      default: return meaningUprightEn;
    }
  }

  /// Get reversed meaning in given locale
  String localizedReversedMeaning(String locale) {
    switch (locale) {
      case 'zh': return meaningReversedZh;
      case 'tl': return meaningReversedTl;
      default: return meaningReversedEn;
    }
  }

  /// Get love reading in given locale
  String localizedLove(String locale) {
    switch (locale) {
      case 'zh': return loveZh;
      case 'tl': return loveTl;
      default: return loveEn;
    }
  }

  /// Get career reading in given locale
  String localizedCareer(String locale) {
    switch (locale) {
      case 'zh': return careerZh;
      case 'tl': return careerTl;
      default: return careerEn;
    }
  }

  /// Get advice in given locale
  String localizedAdvice(String locale) {
    switch (locale) {
      case 'zh': return adviceZh;
      case 'tl': return adviceTl;
      default: return adviceEn;
    }
  }

  /// Create from JSON map
  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      id: json['id'] as int,
      type: json['type'] as String? ?? 'major',
      number: json['number'] as int? ?? 0,
      nameEn: json['nameEn'] as String? ?? '',
      nameZh: json['nameZh'] as String? ?? '',
      nameTl: json['nameTl'] as String? ?? '',
      suit: json['suit'] as String?,
      suitZh: json['suitZh'] as String?,
      suitTl: json['suitTl'] as String?,
      element: json['element'] as String?,
      elementZh: json['elementZh'] as String?,
      keywordsEn: (json['keywordsEn'] as List<dynamic>?)?.cast<String>() ?? [],
      keywordsZh: (json['keywordsZh'] as List<dynamic>?)?.cast<String>() ?? [],
      keywordsTl: (json['keywordsTl'] as List<dynamic>?)?.cast<String>() ?? [],
      meaningUprightEn: json['meaningUprightEn'] as String? ?? '',
      meaningUprightZh: json['meaningUprightZh'] as String? ?? '',
      meaningUprightTl: json['meaningUprightTl'] as String? ?? '',
      meaningReversedEn: json['meaningReversedEn'] as String? ?? '',
      meaningReversedZh: json['meaningReversedZh'] as String? ?? '',
      meaningReversedTl: json['meaningReversedTl'] as String? ?? '',
      loveEn: json['loveEn'] as String? ?? '',
      loveZh: json['loveZh'] as String? ?? '',
      loveTl: json['loveTl'] as String? ?? '',
      careerEn: json['careerEn'] as String? ?? '',
      careerZh: json['careerZh'] as String? ?? '',
      careerTl: json['careerTl'] as String? ?? '',
      adviceEn: json['adviceEn'] as String? ?? '',
      adviceZh: json['adviceZh'] as String? ?? '',
      adviceTl: json['adviceTl'] as String? ?? '',
    );
  }
}
