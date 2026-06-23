import 'package:flutter/foundation.dart';

/// Result of a single card in a reading
class CardResult {
  final int cardIndex; // Card ID in TarotCard
  final bool isReversed; // Whether card is reversed
  final int position; // Position in the spread

  const CardResult({
    required this.cardIndex,
    required this.isReversed,
    required this.position,
  });

  Map<String, dynamic> toJson() => {
    'cardIndex': cardIndex,
    'isReversed': isReversed,
    'position': position,
  };

  factory CardResult.fromJson(Map<String, dynamic> json) => CardResult(
    cardIndex: json['cardIndex'] as int,
    isReversed: json['isReversed'] as bool? ?? false,
    position: json['position'] as int? ?? 0,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardResult &&
          runtimeType == other.runtimeType &&
          cardIndex == other.cardIndex &&
          isReversed == other.isReversed &&
          position == other.position;

  @override
  int get hashCode => Object.hash(cardIndex, isReversed, position);
}

/// Divination type enum
enum DivinationType {
  tarot,
  astrology,
  numerology,
  fortuneSlip,
  oracle,
  dailyCard;

  String get apiValue {
    switch (this) {
      case DivinationType.tarot: return 'tarot';
      case DivinationType.astrology: return 'astrology';
      case DivinationType.numerology: return 'numerology';
      case DivinationType.fortuneSlip: return 'fortune_slip';
      case DivinationType.oracle: return 'oracle';
      case DivinationType.dailyCard: return 'daily_card';
    }
  }

  static DivinationType fromApi(String value) {
    switch (value) {
      case 'astrology': return DivinationType.astrology;
      case 'numerology': return DivinationType.numerology;
      case 'fortune_slip': return DivinationType.fortuneSlip;
      case 'oracle': return DivinationType.oracle;
      case 'daily_card': return DivinationType.dailyCard;
      default: return DivinationType.tarot;
    }
  }
}

/// Complete reading record
class ReadingRecord {
  final String id; // UUID
  final DateTime timestamp;
  final DivinationType type;
  final String? spreadId; // Spread ID (tarot only)
  final List<CardResult> cards; // Drawn cards
  final String? userInput; // User input (name/birthday etc)
  final String? notes; // User notes

  const ReadingRecord({
    required this.id,
    required this.timestamp,
    required this.type,
    this.spreadId,
    required this.cards,
    this.userInput,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type.apiValue,
    'spreadId': spreadId,
    'cards': cards.map((c) => c.toJson()).toList(),
    'userInput': userInput,
    'notes': notes,
  };

  factory ReadingRecord.fromJson(Map<String, dynamic> json) {
    final cardList = (json['cards'] as List<dynamic>?)
        ?.map((c) => CardResult.fromJson(c as Map<String, dynamic>))
        .toList() ?? [];
    return ReadingRecord(
      id: json['id'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      type: DivinationType.fromApi(json['type'] as String? ?? 'tarot'),
      spreadId: json['spreadId'] as String?,
      cards: cardList,
      userInput: json['userInput'] as String?,
      notes: json['notes'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingRecord &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timestamp == other.timestamp &&
          type == other.type &&
          spreadId == other.spreadId &&
          listEquals(cards, other.cards) &&
          userInput == other.userInput &&
          notes == other.notes;

  @override
  int get hashCode => Object.hash(
        id,
        timestamp,
        type,
        spreadId,
        Object.hashAll(cards),
        userInput,
        notes,
      );
}

/// Daily card record
class DailyCardRecord {
  final String date; // YYYY-MM-DD
  final String cardType; // tarot / oracle
  final int cardIndex;
  final bool isReversed;
  final String readingText;
  final DateTime timestamp;

  const DailyCardRecord({
    required this.date,
    required this.cardType,
    required this.cardIndex,
    required this.isReversed,
    required this.readingText,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'cardType': cardType,
    'cardIndex': cardIndex,
    'isReversed': isReversed,
    'readingText': readingText,
    'timestamp': timestamp.toIso8601String(),
  };

  factory DailyCardRecord.fromJson(Map<String, dynamic> json) => DailyCardRecord(
    date: json['date'] as String? ?? '',
    cardType: json['cardType'] as String? ?? 'tarot',
    cardIndex: json['cardIndex'] as int? ?? 0,
    isReversed: json['isReversed'] as bool? ?? false,
    readingText: json['readingText'] as String? ?? '',
    timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyCardRecord &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          cardType == other.cardType &&
          cardIndex == other.cardIndex &&
          isReversed == other.isReversed &&
          readingText == other.readingText &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(
        date,
        cardType,
        cardIndex,
        isReversed,
        readingText,
        timestamp,
      );
}
