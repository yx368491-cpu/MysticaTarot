import 'package:flutter/material.dart';
import '../domain/entities/tarot_card.dart';
import '../domain/entities/spread.dart';
import '../domain/entities/reading.dart';
import '../data/datasources/tarot_card_content.dart';
import '../services/tarot_reading_service.dart';
import '../services/spread_service.dart';

/// Tarot reading state management
class TarotProvider extends ChangeNotifier {
  List<TarotCard> _allCards = [];
  List<Spread> _spreads = [];
  Spread? _selectedSpread;
  List<CardResult> _drawnCards = [];
  List<bool> _revealedCards = [];
  bool _isLoading = true;
  bool _isShuffling = false;
  String? _errorMessage;
  String _locale = 'en';

  // Getters
  List<TarotCard> get allCards => _allCards;
  String get locale => _locale;
  List<Spread> get spreads => _spreads;
  Spread? get selectedSpread => _selectedSpread;
  List<CardResult> get drawnCards => _drawnCards;
  List<bool> get revealedCards => _revealedCards;
  bool get isLoading => _isLoading;
  bool get isShuffling => _isShuffling;
  String? get errorMessage => _errorMessage;
  bool get hasDrawnCards => _drawnCards.isNotEmpty;

  /// Initialize: load cards and spreads.
  ///
  /// Note: TarotProvider is created WITHOUT an initial locale (defaults to 'en').
  /// SettingsProvider (when present via ChangeNotifierProxyProvider) drives
  /// the locale via [setLocale]. This keeps TarotProvider free of any
  /// hard dependency on SettingsProvider.
  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Always set spreads — static const, never depends on async card loading.
    _spreads = SpreadService.allSpreads;

    try {
      _allCards = await TarotCardContent.loadAll();
    } catch (e) {
      _errorMessage = 'Failed to load tarot data: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Set locale for interpretations. Called by SettingsProvider proxy when
  /// the app's UI language changes; idempotent if the locale is unchanged.
  void setLocale(String locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  /// Select a spread for reading
  void selectSpread(Spread spread) {
    _selectedSpread = spread;
    _drawnCards = [];
    _revealedCards = [];
    notifyListeners();
  }

  /// Start the reading: shuffle, cut, and draw cards
  Future<void> startReading() async {
    if (_selectedSpread == null) return;

    _isShuffling = true;
    _drawnCards = [];
    _revealedCards = List.filled(_selectedSpread!.cardCount, false);
    notifyListeners();

    // Simulate shuffling delay for animation
    await Future.delayed(const Duration(seconds: 3));

    final service = TarotReadingService(_allCards);
    _drawnCards = service.drawCards(_selectedSpread!.cardCount);

    _isShuffling = false;
    notifyListeners();
  }

  /// Reveal a card at given index
  void revealCard(int index) {
    if (index < 0 || index >= _revealedCards.length) return;
    if (_revealedCards[index]) return;
    _revealedCards[index] = true;
    notifyListeners();
  }

  /// Reveal all remaining cards
  void revealAllCards() {
    for (int i = 0; i < _revealedCards.length; i++) {
      _revealedCards[i] = true;
    }
    notifyListeners();
  }

  /// Check if all cards are revealed
  bool get allRevealed =>
      _revealedCards.isNotEmpty && _revealedCards.every((r) => r);

  /// Get card by its index in the drawn list
  TarotCard? getCardByResult(CardResult result) {
    try {
      return _allCards.firstWhere((c) => c.id == result.cardIndex);
    } catch (_) {
      return null;
    }
  }

  /// Get interpretation for drawn card at position
  CardInterpretation? getInterpretation(int position) {
    if (position >= _drawnCards.length) return null;
    final result = _drawnCards[position];
    final card = getCardByResult(result);
    if (card == null) return null;

    final service = TarotReadingService(_allCards);
    return service.interpretCard(card, result.isReversed, _locale);
  }

  /// Reset the current reading
  void reset() {
    _selectedSpread = null;
    _drawnCards = [];
    _revealedCards = [];
    _isShuffling = false;
    notifyListeners();
  }

  /// Get position name for a card in the spread
  String getPositionName(int index) {
    if (_selectedSpread == null || index >= _selectedSpread!.positions.length) {
      return 'Position ${index + 1}';
    }
    return _selectedSpread!.positions[index].localizedName(_locale);
  }

  /// Get position description
  String getPositionDescription(int index) {
    if (_selectedSpread == null || index >= _selectedSpread!.positions.length) {
      return '';
    }
    return _selectedSpread!.positions[index].localizedDescription(_locale);
  }
}
