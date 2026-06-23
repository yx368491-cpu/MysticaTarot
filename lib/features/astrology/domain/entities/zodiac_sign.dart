/// Zodiac sign entity with multi-language content
class ZodiacSign {
  final String nameEn;
  final String nameZh;
  final String nameTl;
  final String dates;
  final String element;
  final String elementZh;
  final String ruler;
  final String rulerZh;
  final String luckyColor;
  final String luckyColorZh;
  final int luckyNumber;
  final String personalityEn;
  final String personalityZh;
  final String personalityTl;
  final String dailyEn;
  final String dailyZh;
  final String dailyTl;
  final String weeklyEn;
  final String weeklyZh;
  final String weeklyTl;
  final String monthlyEn;
  final String monthlyZh;
  final String monthlyTl;

  const ZodiacSign({
    required this.nameEn,
    required this.nameZh,
    required this.nameTl,
    required this.dates,
    required this.element,
    required this.elementZh,
    required this.ruler,
    required this.rulerZh,
    required this.luckyColor,
    required this.luckyColorZh,
    required this.luckyNumber,
    required this.personalityEn,
    required this.personalityZh,
    required this.personalityTl,
    required this.dailyEn,
    required this.dailyZh,
    required this.dailyTl,
    required this.weeklyEn,
    required this.weeklyZh,
    required this.weeklyTl,
    required this.monthlyEn,
    required this.monthlyZh,
    required this.monthlyTl,
  });

  String localizedName(String locale) {
    switch (locale) {
      case 'zh': return nameZh;
      case 'tl': return nameTl;
      default: return nameEn;
    }
  }

  String localizedElement(String locale) {
    switch (locale) {
      case 'zh': return elementZh;
      default: return element;
    }
  }

  String localizedPersonality(String locale) {
    switch (locale) {
      case 'zh': return personalityZh;
      case 'tl': return personalityTl;
      default: return personalityEn;
    }
  }

  String localizedDaily(String locale) {
    switch (locale) {
      case 'zh': return dailyZh;
      case 'tl': return dailyTl;
      default: return dailyEn;
    }
  }

  String localizedWeekly(String locale) {
    switch (locale) {
      case 'zh': return weeklyZh;
      case 'tl': return weeklyTl;
      default: return weeklyEn;
    }
  }

  String localizedMonthly(String locale) {
    switch (locale) {
      case 'zh': return monthlyZh;
      case 'tl': return monthlyTl;
      default: return monthlyEn;
    }
  }

  factory ZodiacSign.fromJson(Map<String, dynamic> json) {
    return ZodiacSign(
      nameEn: json['nameEn'] as String? ?? '',
      nameZh: json['nameZh'] as String? ?? '',
      nameTl: json['nameTl'] as String? ?? '',
      dates: json['dates'] as String? ?? '',
      element: json['element'] as String? ?? '',
      elementZh: json['elementZh'] as String? ?? '',
      ruler: json['ruler'] as String? ?? '',
      rulerZh: json['rulerZh'] as String? ?? '',
      luckyColor: json['luckyColor'] as String? ?? '',
      luckyColorZh: json['luckyColorZh'] as String? ?? '',
      luckyNumber: json['luckyNumber'] as int? ?? 0,
      personalityEn: json['personalityEn'] as String? ?? '',
      personalityZh: json['personalityZh'] as String? ?? '',
      personalityTl: json['personalityTl'] as String? ?? '',
      dailyEn: json['dailyEn'] as String? ?? '',
      dailyZh: json['dailyZh'] as String? ?? '',
      dailyTl: json['dailyTl'] as String? ?? '',
      weeklyEn: json['weeklyEn'] as String? ?? '',
      weeklyZh: json['weeklyZh'] as String? ?? '',
      weeklyTl: json['weeklyTl'] as String? ?? '',
      monthlyEn: json['monthlyEn'] as String? ?? '',
      monthlyZh: json['monthlyZh'] as String? ?? '',
      monthlyTl: json['monthlyTl'] as String? ?? '',
    );
  }
}
