/// Tarot Card Constants
class CardConstants {
  CardConstants._();

  /// Card counts
  static const int totalCards = 78;
  static const int majorArcanaCount = 22;
  static const int minorArcanaCount = 56;
  static const int cardsPerSuit = 14;

  /// Major Arcana IDs: 0-21
  static const int majorStartId = 0;
  static const int majorEndId = 21;

  /// Minor Arcana IDs: 22-77
  static const int minorStartId = 22;
  static const int minorEndId = 77;

  /// Card types
  static const String typeMajor = 'major';
  static const String typeMinor = 'minor';

  /// Suits
  static const String suitWands = 'wands';
  static const String suitCups = 'cups';
  static const String suitSwords = 'swords';
  static const String suitPentacles = 'pentacles';

  /// Suit display names
  static const Map<String, Map<String, String>> suitNames = {
    'en': {
      suitWands: 'Wands',
      suitCups: 'Cups',
      suitSwords: 'Swords',
      suitPentacles: 'Pentacles',
    },
    'zh': {
      suitWands: '权杖',
      suitCups: '圣杯',
      suitSwords: '宝剑',
      suitPentacles: '星币',
    },
    'tl': {
      suitWands: 'Wands',
      suitCups: 'Cups',
      suitSwords: 'Swords',
      suitPentacles: 'Pentacles',
    },
  };

  /// Card positions
  static const String positionUpright = 'upright';
  static const String positionReversed = 'reversed';

  /// Card back styles
  static const List<String> cardBackStyles = [
    'default',
    'stars',
    'moon',
    'vines',
    'crystal',
  ];

  /// Major Arcana names (English)
  static const List<String> majorArcanaNames = [
    'The Fool',
    'The Magician',
    'The High Priestess',
    'The Empress',
    'The Emperor',
    'The Hierophant',
    'The Lovers',
    'The Chariot',
    'Strength',
    'The Hermit',
    'Wheel of Fortune',
    'Justice',
    'The Hanged Man',
    'Death',
    'Temperance',
    'The Devil',
    'The Tower',
    'The Star',
    'The Moon',
    'The Sun',
    'Judgement',
    'The World',
  ];
}
