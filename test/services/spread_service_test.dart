import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/features/tarot/services/spread_service.dart';

void main() {
  group('SpreadService', () {
    test('allSpreads contains 6 spreads', () {
      expect(SpreadService.allSpreads.length, 6);
    });

    test('getSpreadById returns correct spread', () {
      final spread = SpreadService.getSpreadById('three');
      expect(spread, isNotNull);
      expect(spread!.nameEn, 'Three Cards');
      expect(spread.cardCount, 3);
      expect(spread.positions.length, 3);
    });

    test('getSpreadById returns null for unknown id', () {
      final spread = SpreadService.getSpreadById('nonexistent');
      expect(spread, isNull);
    });

    test('single spread has 1 position', () {
      final spread = SpreadService.getSpreadById('single');
      expect(spread!.cardCount, 1);
      expect(spread.positions.length, 1);
      expect(spread.positions[0].nameEn, 'Guidance');
    });

    test('celtic cross spread has 10 positions', () {
      final spread = SpreadService.getSpreadById('celtic_cross');
      expect(spread!.cardCount, 10);
      expect(spread.positions.length, 10);
      expect(spread.positions[0].nameEn, 'Center');
      expect(spread.positions[9].nameEn, 'Final Outcome');
    });

    test('relationship spread has 6 positions', () {
      final spread = SpreadService.getSpreadById('relationship');
      expect(spread!.cardCount, 6);
      expect(spread.positions.length, 6);
      expect(spread.positions[0].nameEn, 'You');
      expect(spread.positions[5].nameEn, 'Outcome');
    });

    test('wish spread has 4 positions', () {
      final spread = SpreadService.getSpreadById('wish');
      expect(spread!.cardCount, 4);
      expect(spread.positions.length, 4);
      expect(spread.positions[0].nameEn, 'Wish');
      expect(spread.positions[3].nameEn, 'Result');
    });

    test('four seasons spread has 4 positions', () {
      final spread = SpreadService.getSpreadById('four_seasons');
      expect(spread!.cardCount, 4);
      expect(spread.positions.length, 4);
      expect(spread.positions[0].nameEn, 'Spring');
      expect(spread.positions[3].nameEn, 'Winter');
    });

    test('all spread ids are unique', () {
      final ids = SpreadService.allSpreads.map((s) => s.id).toSet();
      expect(ids.length, SpreadService.allSpreads.length);
    });

    test('all spreads have matching cardCount and positions length', () {
      for (final spread in SpreadService.allSpreads) {
        expect(spread.cardCount, spread.positions.length,
            reason: 'Spread ${spread.id} cardCount does not match positions length');
      }
    });

    test('spread localization works', () {
      final spread = SpreadService.getSpreadById('three')!;
      expect(spread.localizedName('zh'), '三张牌');
      expect(spread.localizedName('tl'), 'Tatlong Cards');
      expect(spread.localizedName('en'), 'Three Cards');

      expect(spread.positions[0].localizedName('zh'), '过去');
      expect(spread.positions[0].localizedName('tl'), 'Nakaraan');
    });
  });
}
