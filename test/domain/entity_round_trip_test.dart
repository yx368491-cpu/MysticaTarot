import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/features/tarot/domain/entities/reading.dart';
import 'package:mystica_tarot/features/tarot/domain/entities/spread.dart';

void main() {
  group('CardResult JSON round-trip', () {
    test('preserves all fields', () {
      const c = CardResult(cardIndex: 7, isReversed: true, position: 2);
      final j = c.toJson();
      expect(j, {'cardIndex': 7, 'isReversed': true, 'position': 2});
      final restored = CardResult.fromJson(j);
      expect(restored.cardIndex, 7);
      expect(restored.isReversed, true);
      expect(restored.position, 2);
      // CardResult lacks `==`, so field-by-field assertion is sufficient.
    });

    test('fromJson tolerates missing optional fields', () {
      final c = CardResult.fromJson({'cardIndex': 3});
      expect(c.cardIndex, 3);
      expect(c.isReversed, false); // default false
      expect(c.position, 0); // default 0
    });
  });

  group('ReadingRecord JSON round-trip', () {
    test('full record with cards round-trips', () {
      final record = ReadingRecord(
        id: 'abc-123',
        timestamp: DateTime.utc(2026, 6, 23, 14, 30),
        type: DivinationType.tarot,
        spreadId: 'three',
        cards: const [
          CardResult(cardIndex: 0, isReversed: false, position: 0),
          CardResult(cardIndex: 1, isReversed: true, position: 1),
        ],
        userInput: null,
        notes: 'first reading',
      );

      final j = record.toJson();
      expect(j['id'], 'abc-123');
      expect(j['type'], 'tarot');
      expect(j['spreadId'], 'three');
      expect(j['notes'], 'first reading');
      expect((j['cards'] as List).length, 2);

      final restored = ReadingRecord.fromJson(j);
      expect(restored.id, 'abc-123');
      expect(restored.timestamp, record.timestamp);
      expect(restored.type, DivinationType.tarot);
      expect(restored.spreadId, 'three');
      expect(restored.cards.length, 2);
      expect(restored.cards[1].isReversed, true);
      expect(restored.notes, 'first reading');
    });

    test('fromJson with missing cards → empty list', () {
      final r = ReadingRecord.fromJson({
        'id': 'x',
        'timestamp': '2026-06-23T00:00:00.000Z',
        'type': 'astrology',
      });
      expect(r.cards, isEmpty);
      expect(r.type, DivinationType.astrology);
    });

    test('fromJson with bad timestamp → fallback to DateTime.now()', () {
      final r = ReadingRecord.fromJson({
        'id': 'x',
        'timestamp': 'not-a-date',
        'type': 'tarot',
      });
      // Just ensure it doesn't crash
      expect(r.id, 'x');
    });
  });

  group('DailyCardRecord JSON round-trip', () {
    test('full round-trip', () {
      final r = DailyCardRecord(
        date: '2026-06-23',
        cardType: 'tarot',
        cardIndex: 21,
        isReversed: false,
        readingText: 'The World — completion',
        timestamp: DateTime.utc(2026, 6, 23, 9, 0),
      );
      final j = r.toJson();
      expect(j['date'], '2026-06-23');
      expect(j['cardType'], 'tarot');
      expect(j['cardIndex'], 21);
      expect(j['readingText'], contains('World'));

      final restored = DailyCardRecord.fromJson(j);
      expect(restored.date, '2026-06-23');
      expect(restored.cardType, 'tarot');
      expect(restored.cardIndex, 21);
      expect(restored.timestamp, r.timestamp);
    });

    test('fromJson with missing fields uses safe defaults', () {
      final r = DailyCardRecord.fromJson(<String, dynamic>{});
      expect(r.date, '');
      expect(r.cardType, 'tarot');
      expect(r.cardIndex, 0);
      expect(r.isReversed, false);
      expect(r.readingText, '');
    });
  });

  group('DivinationType serialization', () {
    test('all 6 types round-trip through apiValue / fromApi', () {
      for (final t in DivinationType.values) {
        final v = t.apiValue;
        final restored = DivinationType.fromApi(v);
        expect(restored, t);
      }
    });

    test('unknown api value defaults to tarot', () {
      expect(DivinationType.fromApi('hahaha'), DivinationType.tarot);
      expect(DivinationType.fromApi(''), DivinationType.tarot);
    });
  });

  group('Spread localization helpers', () {
    Spread spread() => const Spread(
          id: 'three',
          nameEn: 'Three Cards',
          nameZh: '三张牌',
          nameTl: 'Tatlong Cards',
          cardCount: 3,
          descriptionEn: 'Past / Present / Future',
          descriptionZh: '过去 / 现在 / 未来',
          descriptionTl: 'Nakaraan / Kasalukuyan / Kinabukasan',
          positions: [
            SpreadPosition(
              index: 0, nameEn: 'Past', nameZh: '过去', nameTl: 'Nakaraan',
            ),
            SpreadPosition(
              index: 1, nameEn: 'Present', nameZh: '现在', nameTl: 'Kasalukuyan',
            ),
            SpreadPosition(
              index: 2, nameEn: 'Future', nameZh: '未来', nameTl: 'Kinabukasan',
            ),
          ],
        );

    test('localizedName picks per-locale with en fallback', () {
      final s = spread();
      expect(s.localizedName('zh'), '三张牌');
      expect(s.localizedName('tl'), 'Tatlong Cards');
      expect(s.localizedName('en'), 'Three Cards');
      expect(s.localizedName('xx'), 'Three Cards');
    });

    test('localizedDescription picks per-locale with en fallback', () {
      final s = spread();
      expect(s.localizedDescription('zh'), '过去 / 现在 / 未来');
      expect(s.localizedDescription('tl'), 'Nakaraan / Kasalukuyan / Kinabukasan');
    });

    test('positions[i].localizedName respects locale', () {
      final s = spread();
      expect(s.positions[0].localizedName('zh'), '过去');
      expect(s.positions[0].localizedName('tl'), 'Nakaraan');
      expect(s.positions[0].localizedName('en'), 'Past');
    });

    test('position description falls back to empty string when not provided', () {
      const p = SpreadPosition(index: 0, nameEn: 'A', nameZh: '甲', nameTl: 'A');
      expect(p.localizedDescription('en'), '');
      expect(p.localizedDescription('zh'), '');
    });

    test('cardCount matches positions.length', () {
      final s = spread();
      expect(s.cardCount, s.positions.length);
    });
  });
}
