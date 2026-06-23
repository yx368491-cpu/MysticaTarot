import 'dart:math';
import '../domain/entities/tarot_card.dart';
import '../domain/entities/reading.dart';

/// Service for tarot reading logic (shuffling, drawing, interpretation)
class TarotReadingService {
  final List<TarotCard> _cards;
  final Random _random;

  TarotReadingService(this._cards, {int? seed}) : _random = Random(seed ?? DateTime.now().millisecondsSinceEpoch);

  /// Get all cards
  List<TarotCard> get allCards => _cards;

  /// Shuffle cards - returns a randomly shuffled list
  List<TarotCard> shuffleCards() {
    final shuffled = List<TarotCard>.from(_cards);
    shuffled.shuffle(_random);
    return shuffled;
  }

  /// Draw cards for a spread, shuffling first
  /// Returns list of CardResult with determined reversed status
  List<CardResult> drawCards(int count) {
    final shuffled = shuffleCards();
    final results = <CardResult>[];
    for (int i = 0; i < count && i < shuffled.length; i++) {
      results.add(CardResult(
        cardIndex: shuffled[i].id,
        isReversed: _random.nextBool(),
        position: i,
      ));
    }
    return results;
  }

  /// Draw cards deterministically using a seed (for daily card)
  List<CardResult> drawCardsSeeded(int count, int seed) {
    final seededRandom = Random(seed);
    final shuffled = List<TarotCard>.from(_cards);
    shuffled.shuffle(seededRandom);
    final results = <CardResult>[];
    for (int i = 0; i < count && i < shuffled.length; i++) {
      results.add(CardResult(
        cardIndex: shuffled[i].id,
        isReversed: seededRandom.nextBool(),
        position: i,
      ));
    }
    return results;
  }

  /// Simulate a cut of the deck (split into two piles)
  List<TarotCard> cutDeck(List<TarotCard> deck, {int? cutPosition}) {
    final pos = cutPosition ?? _random.nextInt(deck.length ~/ 3) + deck.length ~/ 3;
    final top = deck.sublist(0, pos);
    final bottom = deck.sublist(pos);
    return [...bottom, ...top];
  }

  /// Get complete interpretation for a card in given locale
  CardInterpretation interpretCard(TarotCard card, bool isReversed, String locale) {
    return CardInterpretation(
      card: card,
      isReversed: isReversed,
      name: card.localizedName(locale),
      keywords: card.localizedKeywords(locale),
      meaning: isReversed ? card.localizedReversedMeaning(locale) : card.localizedUprightMeaning(locale),
      love: card.localizedLove(locale),
      career: card.localizedCareer(locale),
      advice: card.localizedAdvice(locale),
    );
  }
}

/// Full interpretation result for a single card
class CardInterpretation {
  final TarotCard card;
  final bool isReversed;
  final String name;
  final List<String> keywords;
  final String meaning;
  final String love;
  final String career;
  final String advice;

  const CardInterpretation({
    required this.card,
    required this.isReversed,
    required this.name,
    required this.keywords,
    required this.meaning,
    required this.love,
    required this.career,
    required this.advice,
  });
}
