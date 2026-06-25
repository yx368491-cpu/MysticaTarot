import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/features/astrology/domain/entities/zodiac_sign.dart';
import 'package:mystica_tarot/features/astrology/services/astrology_service.dart';

/// Synthetic ZodiacSign for testing — mirrors the real constructor exactly.
ZodiacSign signFactory(int idx) => ZodiacSign(
      nameEn: 'Sign $idx',
      nameZh: '星座$idx',
      nameTl: 'Sign $idx TL',
      dates: 'dates-$idx',
      element: 'fire',
      elementZh: '火',
      ruler: 'mars',
      rulerZh: '火星',
      luckyColor: 'red',
      luckyColorZh: '红色',
      luckyNumber: idx,
      personalityEn: 'personality $idx',
      personalityZh: '性格 $idx',
      personalityTl: 'pagkatao $idx',
      dailyEn: 'daily $idx',
      dailyZh: '每日 $idx',
      dailyTl: 'araw-araw $idx',
      weeklyEn: 'weekly $idx',
      weeklyZh: '每周 $idx',
      weeklyTl: 'lingguhan $idx',
      monthlyEn: 'monthly $idx',
      monthlyZh: '每月 $idx',
      monthlyTl: 'buwanan $idx',
    );

void main() {
  group('AstrologyService.getSignByDate', () {
    final signs = List.generate(12, signFactory);

    test('Aries: March 21 → April 19', () {
      expect(AstrologyService.getSignByDate(3, 21, signs), isNotNull);
      expect(AstrologyService.getSignByDate(3, 21, signs)!.localizedName('en'),
          'Sign 0');
      expect(AstrologyService.getSignByDate(4, 19, signs)!.localizedName('en'),
          'Sign 0');
    });
    test('Taurus: April 20 → May 20', () {
      expect(AstrologyService.getSignByDate(4, 20, signs)!.localizedName('en'),
          'Sign 1');
      expect(AstrologyService.getSignByDate(5, 20, signs)!.localizedName('en'),
          'Sign 1');
    });
    test('Gemini: May 21 → June 20', () {
      expect(AstrologyService.getSignByDate(5, 21, signs)!.localizedName('en'),
          'Sign 2');
      expect(AstrologyService.getSignByDate(6, 20, signs)!.localizedName('en'),
          'Sign 2');
    });
    test('Cancer: June 21 → July 22', () {
      expect(AstrologyService.getSignByDate(6, 21, signs)!.localizedName('en'),
          'Sign 3');
      expect(AstrologyService.getSignByDate(7, 22, signs)!.localizedName('en'),
          'Sign 3');
    });
    test('Leo: July 23 → August 22', () {
      expect(AstrologyService.getSignByDate(7, 23, signs)!.localizedName('en'),
          'Sign 4');
      expect(AstrologyService.getSignByDate(8, 22, signs)!.localizedName('en'),
          'Sign 4');
    });
    test('Virgo: August 23 → September 22', () {
      expect(AstrologyService.getSignByDate(8, 23, signs)!.localizedName('en'),
          'Sign 5');
      expect(AstrologyService.getSignByDate(9, 22, signs)!.localizedName('en'),
          'Sign 5');
    });
    test('Libra: September 23 → October 22', () {
      expect(AstrologyService.getSignByDate(9, 23, signs)!.localizedName('en'),
          'Sign 6');
      expect(AstrologyService.getSignByDate(10, 22, signs)!.localizedName('en'),
          'Sign 6');
    });
    test('Scorpio: October 23 → November 21', () {
      expect(AstrologyService.getSignByDate(10, 23, signs)!.localizedName('en'),
          'Sign 7');
      expect(AstrologyService.getSignByDate(11, 21, signs)!.localizedName('en'),
          'Sign 7');
    });
    test('Sagittarius: November 22 → December 21', () {
      expect(AstrologyService.getSignByDate(11, 22, signs)!.localizedName('en'),
          'Sign 8');
      expect(AstrologyService.getSignByDate(12, 21, signs)!.localizedName('en'),
          'Sign 8');
    });
    test('Capricorn: December 22 → January 19', () {
      expect(AstrologyService.getSignByDate(12, 22, signs)!.localizedName('en'),
          'Sign 9');
      expect(AstrologyService.getSignByDate(1, 19, signs)!.localizedName('en'),
          'Sign 9');
    });
    test('Aquarius: January 20 → February 18', () {
      expect(AstrologyService.getSignByDate(1, 20, signs)!.localizedName('en'),
          'Sign 10');
      expect(AstrologyService.getSignByDate(2, 18, signs)!.localizedName('en'),
          'Sign 10');
    });
    test('Pisces: February 19 → March 20 (default case)', () {
      expect(AstrologyService.getSignByDate(2, 19, signs)!.localizedName('en'),
          'Sign 11');
      expect(AstrologyService.getSignByDate(3, 20, signs)!.localizedName('en'),
          'Sign 11');
    });
    test('empty list → null', () {
      expect(AstrologyService.getSignByDate(3, 21, []), isNull);
    });
  });

  group('AstrologyService.getZodiacIcon', () {
    test('returns 12 zodiac glyphs for indices 0..11', () {
      const expected = ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'];
      for (var i = 0; i < 12; i++) {
        expect(AstrologyService.getZodiacIcon(i), expected[i]);
      }
    });
    test('clamps index >= 12 via modulo', () {
      expect(AstrologyService.getZodiacIcon(12), '♈');
      expect(AstrologyService.getZodiacIcon(13), '♉');
      expect(AstrologyService.getZodiacIcon(24), '♈');
    });
  });

  group('AstrologyService.getElementIcon', () {
    test('returns element emoji for known elements', () {
      expect(AstrologyService.getElementIcon('fire'), '🔥');
      expect(AstrologyService.getElementIcon('earth'), '🌍');
      expect(AstrologyService.getElementIcon('air'), '💨');
      expect(AstrologyService.getElementIcon('water'), '💧');
    });
    test('falls back for unknown element', () {
      expect(AstrologyService.getElementIcon('void'), '✨');
      expect(AstrologyService.getElementIcon(''), '✨');
    });
    test('case-insensitive', () {
      expect(AstrologyService.getElementIcon('FIRE'), '🔥');
      expect(AstrologyService.getElementIcon('Earth'), '🌍');
    });
  });

  group('AstrologyService.parseSigns — compute() entrypoint (Phase8 P3)', () {
    test('parses a synthetic 1-element JSON string into a list of signs', () {
      const json =
          '[{"nameEn":"Aries","nameZh":"白羊座","nameTl":"Aries","dates":"Mar21-Apr19","element":"fire","elementZh":"火","ruler":"mars","rulerZh":"火星","luckyColor":"red","luckyColorZh":"红色","luckyNumber":7,"personalityEn":"p","personalityZh":"p","personalityTl":"p","dailyEn":"d","dailyZh":"d","dailyTl":"d","weeklyEn":"w","weeklyZh":"w","weeklyTl":"w","monthlyEn":"m","monthlyZh":"m","monthlyTl":"m"}]';
      final signs = AstrologyService.parseSigns(json);
      expect(signs, hasLength(1));
      expect(signs.first.localizedName('en'), 'Aries');
      expect(signs.first.localizedName('zh'), '白羊座');
    });
    test('returns empty list on empty JSON array', () {
      expect(AstrologyService.parseSigns('[]'), isEmpty);
    });
    test('survives malformed JSON via fromJson tolerance', () {
      // fromJson has safe defaults for every field, so an object with
      // missing keys parses to a sign with empty strings and 0 luckyNumber.
      final signs = AstrologyService.parseSigns('[{}]');
      expect(signs, hasLength(1));
      expect(signs.first.luckyNumber, 0);
      expect(signs.first.localizedName('en'), '');
    });
  });

  group('ZodiacSign.localized helpers', () {
    test('localizedDaily picks per-locale field', () {
      final s = signFactory(5);
      expect(s.localizedDaily('zh'), '每日 5');
      expect(s.localizedDaily('tl'), 'araw-araw 5');
      expect(s.localizedDaily('en'), 'daily 5');
      expect(s.localizedDaily('xx'), 'daily 5'); // default fallback
    });
    test('localizedWeekly picks per-locale field', () {
      final s = signFactory(7);
      expect(s.localizedWeekly('zh'), '每周 7');
      expect(s.localizedWeekly('tl'), 'lingguhan 7');
    });
    test('localizedMonthly picks per-locale field', () {
      final s = signFactory(9);
      expect(s.localizedMonthly('zh'), '每月 9');
      expect(s.localizedMonthly('tl'), 'buwanan 9');
    });
    test('localizedElement uses zh for zh, else english field', () {
      final s = signFactory(0);
      expect(s.localizedElement('zh'), '火');
      expect(s.localizedElement('en'), 'fire');
      expect(s.localizedElement('tl'), 'fire'); // tl falls back to en
    });
  });
}
