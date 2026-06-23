import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/features/numerology/services/numerology_service.dart';

void main() {
  group('NumerologyService.calculateLifePathNumber', () {
    test('calculates single digit correctly', () {
      // 1990-1-1: _reduceToDigit(1990)=19, _reduceToDigit(1)=1, _reduceToDigit(1)=1
      // sum=21, _reduceToDigit(21)=3
      expect(NumerologyService.calculateLifePathNumber(1990, 1, 1), 3);
    });

    test('common birthday produces correct life path number', () {
      // 1990-7-15: _reduceToDigit(1990)=19, _reduceToDigit(7)=7, _reduceToDigit(15)=6
      // sum=32, _reduceToDigit(32)=5
      expect(NumerologyService.calculateLifePathNumber(1990, 7, 15), 5);
    });

    test('master number 11 is preserved', () {
      // 1995-3-29: _reduceToDigit(1995)=24, _reduceToDigit(3)=3, _reduceToDigit(29)=11
      // sum=38, _reduceToDigit(38)=11 → master number preserved
      expect(NumerologyService.calculateLifePathNumber(1995, 3, 29), 11);
    });

    test('master number 22 is not reachable via current algorithm', () {
      // 2003-8-9: _reduceToDigit(2003)=5, _reduceToDigit(8)=8, _reduceToDigit(9)=9
      // sum=22, _reduceToDigit(22)=4 (not 22)
      // The algorithm only preserves 11 since _reduceToDigit(sum) can produce 11
      // but not 22 or 33 from the single-pass sum reduction
      expect(NumerologyService.calculateLifePathNumber(2003, 8, 9), 4);
    });

    test('reduces to single digit for most dates', () {
      final result = NumerologyService.calculateLifePathNumber(1987, 5, 12);
      expect(result, inInclusiveRange(1, 9));
    });
  });

  group('NumerologyService.calculateDestinyNumber', () {
    test('calculates simple name correctly', () {
      // A=1, B=2, C=3 => 6
      expect(NumerologyService.calculateDestinyNumber('ABC'), 6);
    });

    test('strips non-alphabetic characters', () {
      expect(
        NumerologyService.calculateDestinyNumber('He11o!'),
        NumerologyService.calculateDestinyNumber('Heo'),
      );
    });

    test('is case insensitive', () {
      expect(
        NumerologyService.calculateDestinyNumber('abc'),
        NumerologyService.calculateDestinyNumber('ABC'),
      );
    });

    test('master number 11 is preserved when letter sum equals 29', () {
      // A=1, Z=26, B=2 => 1+26+2 = 29, _reduceToDigit(29) = 11
      expect(NumerologyService.calculateDestinyNumber('AZB'), 11);
    });

    test('reduces to single digit for non-master numbers', () {
      expect(NumerologyService.calculateDestinyNumber('A'), 1); // A=1
      expect(NumerologyService.calculateDestinyNumber('Z'), 8); // Z=26 → 8
    });

    test('empty string returns 0', () {
      expect(NumerologyService.calculateDestinyNumber(''), 0);
    });
  });

  group('NumerologyService.getLifePathData', () {
    test('returns correct data for number 1', () {
      final data = NumerologyService.getLifePathData(1);
      expect(data.number, 1);
      expect(data.nameEn, 'The Leader');
      expect(data.nameZh, '领导者');
      expect(data.nameTl, 'Ang Pinuno');
    });

    test('returns correct data for master number 11', () {
      final data = NumerologyService.getLifePathData(11);
      expect(data.number, 11);
      expect(data.isMasterNumber, true);
      expect(data.nameEn, 'The Intuitive');
    });

    test('returns first entry as fallback for invalid number', () {
      final data = NumerologyService.getLifePathData(99);
      expect(data.number, 1);
    });

    test('localized methods return correct values', () {
      final data = NumerologyService.getLifePathData(1);
      expect(data.localizedName('en'), 'The Leader');
      expect(data.localizedName('zh'), '领导者');
      expect(data.localizedName('tl'), 'Ang Pinuno');
      expect(data.localizedMeaning('en'), contains('natural-born leader'));
    });
  });
}
