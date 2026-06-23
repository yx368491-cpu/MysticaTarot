import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/tarot_card.dart';

/// Data source that loads tarot card content from JSON assets
class TarotCardContent {
  static List<TarotCard>? _cachedCards;

  /// Load and cache all tarot cards from JSON assets
  static Future<List<TarotCard>> loadAll() async {
    if (_cachedCards != null) return _cachedCards!;

    final majorJson = await rootBundle.loadString(
      'features/tarot/data/json/major_arcana.json',
    );
    final minorJson = await rootBundle.loadString(
      'features/tarot/data/json/minor_arcana.json',
    );

    final majorList = json.decode(majorJson) as List<dynamic>;
    final minorList = json.decode(minorJson) as List<dynamic>;

    final cards = <TarotCard>[];
    for (final item in [...majorList, ...minorList]) {
      cards.add(TarotCard.fromJson(item as Map<String, dynamic>));
    }

    _cachedCards = cards;
    return cards;
  }

  /// Clear the cache
  static void clearCache() {
    _cachedCards = null;
  }

  /// Get a card by its ID
  static Future<TarotCard?> getById(int id) async {
    final cards = await loadAll();
    try {
      return cards.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
