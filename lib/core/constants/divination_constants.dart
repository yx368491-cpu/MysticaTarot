/// Divination Method Constants
class DivinationConstants {
  DivinationConstants._();

  /// Divination types
  static const String typeTarot = 'tarot';
  static const String typeAstrology = 'astrology';
  static const String typeNumerology = 'numerology';
  static const String typeFortuneSlip = 'fortune_slip';
  static const String typeOracle = 'oracle';
  static const String typeDailyCard = 'daily_card';

  /// Spread types
  static const String spreadSingle = 'single';
  static const String spreadThree = 'three';
  static const String spreadCelticCross = 'celtic_cross';
  static const String spreadRelationship = 'relationship';
  static const String spreadWish = 'wish';
  static const String spreadFourSeasons = 'four_seasons';

  /// Spread card counts
  static const Map<String, int> spreadCardCounts = {
    spreadSingle: 1,
    spreadThree: 3,
    spreadCelticCross: 10,
    spreadRelationship: 6,
    spreadWish: 4,
    spreadFourSeasons: 4,
  };

  /// Astrology
  static const List<String> zodiacSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

  /// Numerology master numbers
  static const List<int> masterNumbers = [11, 22, 33];
  static const int maxLifePathNumber = 9;

  /// Fortune slip grades
  static const List<String> fortuneGrades = [
    'daiji',     // 大吉 - Great blessing
    'chukichi',  // 中吉 - Medium blessing
    'shokichi',  // 小吉 - Small blessing
    'kichi',     // 吉 - Blessing
    'suekichi',  // 末吉 - Future blessing
    'kyo',       // 凶 - Curse
  ];
}
