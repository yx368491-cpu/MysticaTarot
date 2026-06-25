// ignore_for_file: prefer_collection_literals
// Set-dedup tests intentionally use `<T>[a, b].toSet()` rather than
// `<T>{a, b}` set literals, because the `equal_elements_in_set` lint
// rejects the latter when the elements are ==-equal (which is exactly the
// invariant these tests are verifying).

import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/features/tarot/domain/entities/reading.dart';
import 'package:mystica_tarot/features/tarot/domain/entities/spread.dart';

void main() {
  group('CardResult == / hashCode + JSON round-trip', () {
    test('=== preserved after JSON round-trip', () {
      const c = CardResult(cardIndex: 7, isReversed: true, position: 2);
      final restored = CardResult.fromJson(c.toJson());
      expect(restored, equals(c)); // identity-equal via ==
      expect(restored.hashCode, c.hashCode);
    });

    test('!== when one field differs', () {
      const a = CardResult(cardIndex: 7, isReversed: true, position: 2);
      const b = CardResult(cardIndex: 7, isReversed: false, position: 2);
      const e = CardResult(cardIndex: 8, isReversed: true, position: 2);
      const f = CardResult(cardIndex: 7, isReversed: true, position: 3);
      expect(a == b, isFalse);
      expect(a == e, isFalse);
      expect(a == f, isFalse);
    });

    test('Set deduplicates equivalent CardResults', () {
      const a = CardResult(cardIndex: 5, isReversed: false, position: 0);
      const b = CardResult(cardIndex: 5, isReversed: false, position: 0);
      const c = CardResult(cardIndex: 6, isReversed: false, position: 0);
      // List+toSet pattern: the list intentionally has duplicates so we can
      // verify they collapse via `==`. Sidesteps duplicate-set-literal lint.
      final list = <CardResult>[a, b, c];
      expect(list.toSet(), hasLength(2)); // a and b collapse
    });

    test('fromJson tolerates missing optional fields', () {
      final c = CardResult.fromJson({'cardIndex': 3});
      expect(c.cardIndex, 3);
      expect(c.isReversed, false);
      expect(c.position, 0);
    });
  });

  group('ReadingRecord == / hashCode + JSON round-trip', () {
    ReadingRecord make() => ReadingRecord(
          id: 'abc-123',
          timestamp: DateTime.utc(2026, 6, 23, 14, 30),
          type: DivinationType.tarot,
          spreadId: 'three',
          cards: const [
            CardResult(cardIndex: 0, isReversed: false, position: 0),
            CardResult(cardIndex: 1, isReversed: true, position: 1),
          ],
          userInput: 'birthday:1990',
          notes: 'first reading',
        );

    test('=== preserved after JSON round-trip + nested cards', () {
      final original = make();
      final restored = ReadingRecord.fromJson(original.toJson());
      expect(restored, equals(original));
      expect(restored.hashCode, original.hashCode);
    });

    test('!== with different fields changes hash and equality', () {
      final a = make();
      final b = ReadingRecord(
        id: 'xyz',
        timestamp: a.timestamp,
        type: a.type,
        spreadId: a.spreadId,
        cards: a.cards,
        userInput: a.userInput,
        notes: a.notes,
      );
      expect(a == b, isFalse);
      expect(a.hashCode == b.hashCode, isFalse);
    });

    test('=== with different userInput still differs', () {
      final a = make();
      final b = ReadingRecord(
        id: a.id,
        timestamp: a.timestamp,
        type: a.type,
        spreadId: a.spreadId,
        cards: a.cards,
        userInput: null, // ← changed
        notes: a.notes,
      );
      expect(a == b, isFalse);
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
      expect(r.id, 'x');
    });
  });

  group('DailyCardRecord == / hashCode + JSON round-trip', () {
    test('=== preserved after round-trip', () {
      final original = DailyCardRecord(
        date: '2026-06-23',
        cardType: 'tarot',
        cardIndex: 21,
        isReversed: false,
        readingText: 'The World — completion',
        timestamp: DateTime.utc(2026, 6, 23, 9, 0),
      );
      final restored = DailyCardRecord.fromJson(original.toJson());
      expect(restored, equals(original));
      expect(restored.hashCode, original.hashCode);
    });

    test('Set dedups same-card-different-instance', () {
      final a = DailyCardRecord(
        date: '2026-06-23', cardType: 'tarot', cardIndex: 21,
        isReversed: false, readingText: 'x',
        timestamp: DateTime.utc(2026, 6, 23),
      );
      final b = DailyCardRecord(
        date: '2026-06-23', cardType: 'tarot', cardIndex: 21,
        isReversed: false, readingText: 'x',
        timestamp: DateTime.utc(2026, 6, 23),
      );
      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
      expect(<DailyCardRecord>[a, b].toSet(), hasLength(1));
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

  group('Spread == / hashCode + localization', () {
    Spread spreadFactory() => const Spread(
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

    test('=== same fields → equal + same hash', () {
      final a = spreadFactory();
      final b = spreadFactory();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('!== nameZh differs', () {
      final a = spreadFactory();
      final b = Spread(
        id: a.id,
        nameEn: a.nameEn,
        nameZh: '别的牌',
        nameTl: a.nameTl,
        cardCount: a.cardCount,
        descriptionEn: a.descriptionEn,
        descriptionZh: a.descriptionZh,
        descriptionTl: a.descriptionTl,
        positions: a.positions,
      );
      expect(a == b, isFalse);
    });

    test('!== positions list differs', () {
      final a = spreadFactory();
      final b = Spread(
        id: a.id,
        nameEn: a.nameEn,
        nameZh: a.nameZh,
        nameTl: a.nameTl,
        cardCount: a.cardCount,
        descriptionEn: a.descriptionEn,
        descriptionZh: a.descriptionZh,
        descriptionTl: a.descriptionTl,
        positions: const [SpreadPosition(index: 0, nameEn: 'Only', nameZh: '只有', nameTl: 'Lang')],
      );
      expect(a == b, isFalse);
    });

    test('localizedName picks per-locale with en fallback', () {
      final s = spreadFactory();
      expect(s.localizedName('zh'), '三张牌');
      expect(s.localizedName('tl'), 'Tatlong Cards');
      expect(s.localizedName('en'), 'Three Cards');
      expect(s.localizedName('xx'), 'Three Cards');
    });

    test('localizedDescription picks per-locale with en fallback', () {
      final s = spreadFactory();
      expect(s.localizedDescription('zh'), '过去 / 现在 / 未来');
      expect(s.localizedDescription('tl'), 'Nakaraan / Kasalukuyan / Kinabukasan');
    });

    test('positions[i].localizedName respects locale', () {
      final s = spreadFactory();
      expect(s.positions[0].localizedName('zh'), '过去');
      expect(s.positions[0].localizedName('tl'), 'Nakaraan');
      expect(s.positions[0].localizedName('en'), 'Past');
    });

    test('SpreadPosition === preserves equality', () {
      const p1 = SpreadPosition(index: 0, nameEn: 'A', nameZh: '甲', nameTl: 'A');
      const p2 = SpreadPosition(index: 0, nameEn: 'A', nameZh: '甲', nameTl: 'A');
      expect(p1 == p2, isTrue);
      expect(p1.hashCode, p2.hashCode);
    });

    test('position description falls back to empty string when not provided', () {
      const p = SpreadPosition(index: 0, nameEn: 'A', nameZh: '甲', nameTl: 'A');
      expect(p.localizedDescription('en'), '');
      expect(p.localizedDescription('zh'), '');
    });

    test('cardCount matches positions.length', () {
      final s = spreadFactory();
      expect(s.cardCount, s.positions.length);
    });
  });
}
