import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/util/json_normalize.dart';

/// Oracle card entity
class OracleCard {
  final int id;
  final String nameEn;
  final String nameZh;
  final String nameTl;
  final String messageEn;
  final String messageZh;
  final String messageTl;

  const OracleCard({
    required this.id,
    required this.nameEn,
    required this.nameZh,
    required this.nameTl,
    required this.messageEn,
    required this.messageZh,
    required this.messageTl,
  });

  String localizedName(String locale) {
    switch (locale) {
      case 'zh': return nameZh;
      case 'tl': return nameTl;
      default: return nameEn;
    }
  }

  String localizedMessage(String locale) {
    switch (locale) {
      case 'zh': return messageZh;
      case 'tl': return messageTl;
      default: return messageEn;
    }
  }

  /// Accepts any Map-like input (including Hive's dynamic-keyed read-back);
  /// see docs/bug-log.md entry 004.
  factory OracleCard.fromJson(dynamic raw) {
    final json = normalizeJsonMap(raw);
    return OracleCard(
      id: json['id'] as int? ?? 0,
      nameEn: json['nameEn'] as String? ?? '',
      nameZh: json['nameZh'] as String? ?? '',
      nameTl: json['nameTl'] as String? ?? '',
      messageEn: json['messageEn'] as String? ?? '',
      messageZh: json['messageZh'] as String? ?? '',
      messageTl: json['messageTl'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OracleCard &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nameEn == other.nameEn &&
          nameZh == other.nameZh &&
          nameTl == other.nameTl &&
          messageEn == other.messageEn &&
          messageZh == other.messageZh &&
          messageTl == other.messageTl;

  @override
  int get hashCode => Object.hash(
        id,
        nameEn,
        nameZh,
        nameTl,
        messageEn,
        messageZh,
        messageTl,
      );
}

/// Oracle reading result
class OracleReadingResult {
  final OracleCard card;
  final int position; // 0, 1, 2 for multi-card readings

  const OracleReadingResult({required this.card, required this.position});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OracleReadingResult &&
          runtimeType == other.runtimeType &&
          card == other.card &&
          position == other.position;

  @override
  int get hashCode => Object.hash(card, position);
}

/// Service for oracle card readings
class OracleReadingService {
  List<OracleCard> _allCards = [];
  final Random _random = Random();

  Future<List<OracleCard>> loadCards() async {
    if (_allCards.isNotEmpty) return _allCards;
    final jsonStr = await rootBundle.loadString('features/oracle_cards/data/json/oracle_cards_content.json');
    final List<dynamic> jsonList = json.decode(jsonStr) as List<dynamic>;
    _allCards = jsonList.map((e) => OracleCard.fromJson(e as Map<String, dynamic>)).toList();
    return _allCards;
  }

  int get cardCount => _allCards.length;
  bool get isLoaded => _allCards.isNotEmpty;

  /// Draw a single oracle card
  OracleReadingResult drawSingleCard() {
    if (_allCards.isEmpty) throw StateError('Oracle cards not loaded');
    return OracleReadingResult(
      card: _allCards[_random.nextInt(_allCards.length)],
      position: 0,
    );
  }

  /// Draw multiple cards (for multi-card reading)
  List<OracleReadingResult> drawCards(int count) {
    if (_allCards.isEmpty) throw StateError('Oracle cards not loaded');
    final shuffled = List<OracleCard>.from(_allCards);
    shuffled.shuffle(_random);
    return shuffled.take(count).toList().asMap().entries.map((e) =>
      OracleReadingResult(card: e.value, position: e.key)
    ).toList();
  }
}

/// Position descriptions for multi-card oracle readings
class OraclePosition {
  final String nameEn;
  final String nameZh;
  final String nameTl;

  const OraclePosition({required this.nameEn, required this.nameZh, required this.nameTl});

  String localizedName(String locale) {
    switch (locale) {
      case 'zh': return nameZh;
      case 'tl': return nameTl;
      default: return nameEn;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OraclePosition &&
          runtimeType == other.runtimeType &&
          nameEn == other.nameEn &&
          nameZh == other.nameZh &&
          nameTl == other.nameTl;

  @override
  int get hashCode => Object.hash(nameEn, nameZh, nameTl);

  static const List<OraclePosition> singlePositions = [
    OraclePosition(nameEn: 'Guidance', nameZh: '指引', nameTl: 'Gabay'),
  ];

  static const List<OraclePosition> triplePositions = [
    OraclePosition(nameEn: 'Past', nameZh: '过去', nameTl: 'Nakaraan'),
    OraclePosition(nameEn: 'Present', nameZh: '现在', nameTl: 'Kasalukuyan'),
    OraclePosition(nameEn: 'Future', nameZh: '未来', nameTl: 'Kinabukasan'),
  ];
}
