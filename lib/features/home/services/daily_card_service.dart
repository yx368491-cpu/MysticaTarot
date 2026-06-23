import 'dart:math';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../tarot/domain/entities/tarot_card.dart';
import '../../tarot/data/datasources/tarot_card_content.dart';
import '../../oracle_cards/services/oracle_reading_service.dart';

/// Daily card result
class DailyCardResult {
  final String date; // YYYY-MM-DD
  final String cardType; // 'tarot' or 'oracle'
  final TarotCard? tarotCard;
  final OracleCard? oracleCard;
  final bool isReversed;
  final String message;

  const DailyCardResult({
    required this.date,
    required this.cardType,
    this.tarotCard,
    this.oracleCard,
    this.isReversed = false,
    required this.message,
  });
}

/// Service for daily card generation using date-based seed
class DailyCardService {
  List<TarotCard>? _tarotCards;
  List<OracleCard>? _oracleCards;

  /// Get today's card using date as seed for deterministic result
  Future<DailyCardResult> getDailyCard({String cardType = 'tarot'}) async {
    final now = DateTime.now();
    final date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final random = Random(seed);

    if (cardType == 'oracle') {
      _oracleCards ??= await _loadOracleCards();
      final card = _oracleCards![random.nextInt(_oracleCards!.length)];
      return DailyCardResult(
        date: date,
        cardType: 'oracle',
        oracleCard: card,
        message: card.messageEn,
      );
    }

    // Default: tarot card
    _tarotCards ??= await TarotCardContent.loadAll();
    final card = _tarotCards![random.nextInt(_tarotCards!.length)];
    final isReversed = random.nextBool();

    return DailyCardResult(
      date: date,
      cardType: 'tarot',
      tarotCard: card,
      isReversed: isReversed,
      message: isReversed ? card.meaningReversedEn : card.meaningUprightEn,
    );
  }

  Future<List<OracleCard>> _loadOracleCards() async {
    final jsonStr = await rootBundle.loadString('features/oracle_cards/data/json/oracle_cards_content.json');
    final List<dynamic> jsonList = json.decode(jsonStr) as List<dynamic>;
    return jsonList.map((e) => OracleCard.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Generate a daily message based on card
  static String generateDailyMessage(TarotCard card, bool isReversed, String locale) {
    if (isReversed) {
      return card.localizedReversedMeaning(locale);
    }
    return card.localizedUprightMeaning(locale);
  }
}
