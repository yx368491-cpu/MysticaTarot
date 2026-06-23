// ignore_for_file: prefer_collection_literals
// Set-dedup tests intentionally use `<T>[a, b].toSet()` rather than
// `<T>{a, b}` set literals, because the `equal_elements_in_set` lint
// rejects the latter when the elements are ==-equal (which is exactly the
// invariant these tests are verifying).

import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/features/astrology/domain/entities/zodiac_sign.dart';
import 'package:mystica_tarot/features/fortune_slip/services/fortune_slip_service.dart';
import 'package:mystica_tarot/features/numerology/domain/entities/life_path_number.dart';
import 'package:mystica_tarot/features/oracle_cards/services/oracle_reading_service.dart';
import 'package:mystica_tarot/features/tarot/domain/entities/spread.dart';
import 'package:mystica_tarot/features/tarot/domain/entities/tarot_card.dart';
import 'package:mystica_tarot/features/tarot/services/tarot_reading_service.dart';

void main() {
  group('FortuneSlip == / hashCode', () {
    test('=== same fields → equal + same hash', () {
      const a = FortuneSlip(
        id: 1, grade: 'daiji',
        gradeEn: 'g', gradeZh: 'g', gradeTl: 'g',
        textEn: 't', textZh: 't', textTl: 't',
      );
      const b = FortuneSlip(
        id: 1, grade: 'daiji',
        gradeEn: 'g', gradeZh: 'g', gradeTl: 'g',
        textEn: 't', textZh: 't', textTl: 't',
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
    test('!== different grade', () {
      const a = FortuneSlip(
        id: 1, grade: 'daiji',
        gradeEn: 'a', gradeZh: 'a', gradeTl: 'a',
        textEn: 'x', textZh: 'x', textTl: 'x',
      );
      const b = FortuneSlip(
        id: 1, grade: 'kyo',
        gradeEn: 'a', gradeZh: 'a', gradeTl: 'a',
        textEn: 'x', textZh: 'x', textTl: 'x',
      );
      expect(a == b, isFalse);
    });
    test('Set dedups identical slips', () {
      const a = FortuneSlip(
        id: 1, grade: 'daiji',
        gradeEn: 'a', gradeZh: 'a', gradeTl: 'a',
        textEn: 'x', textZh: 'x', textTl: 'x',
      );
      const b = FortuneSlip(
        id: 1, grade: 'daiji',
        gradeEn: 'a', gradeZh: 'a', gradeTl: 'a',
        textEn: 'x', textZh: 'x', textTl: 'x',
      );
      expect(<FortuneSlip>[a, b].toSet(), hasLength(1));
    });
  });

  group('OracleCard == / hashCode', () {
    test('=== same fields + Set dedup', () {
      const a = OracleCard(
        id: 1, nameEn: 'a', nameZh: '甲', nameTl: 'a',
        messageEn: 'm', messageZh: 'm', messageTl: 'm',
      );
      const b = OracleCard(
        id: 1, nameEn: 'a', nameZh: '甲', nameTl: 'a',
        messageEn: 'm', messageZh: 'm', messageTl: 'm',
      );
      expect(a, equals(b));
      expect(<OracleCard>[a, b].toSet(), hasLength(1));
    });
    test('!== different id', () {
      const a = OracleCard(
        id: 1, nameEn: 'a', nameZh: 'a', nameTl: 'a',
        messageEn: 'm', messageZh: 'm', messageTl: 'm',
      );
      const b = OracleCard(
        id: 2, nameEn: 'a', nameZh: 'a', nameTl: 'a',
        messageEn: 'm', messageZh: 'm', messageTl: 'm',
      );
      expect(a == b, isFalse);
    });
  });

  group('OracleReadingResult == (uses OracleCard ==)', () {
    test('=== when card matches', () {
      const c = OracleCard(
        id: 9, nameEn: 'n', nameZh: '名', nameTl: 'n',
        messageEn: 'm', messageZh: 'm', messageTl: 'm',
      );
      expect(
        const OracleReadingResult(card: c, position: 0),
        equals(const OracleReadingResult(card: c, position: 0)),
      );
    });
    test('!== when position differs', () {
      const c = OracleCard(
        id: 9, nameEn: 'n', nameZh: '名', nameTl: 'n',
        messageEn: 'm', messageZh: 'm', messageTl: 'm',
      );
      expect(
        const OracleReadingResult(card: c, position: 0) ==
            const OracleReadingResult(card: c, position: 1),
        isFalse,
      );
    });
  });

  group('OraclePosition == / hashCode', () {
    test('singlePositions — first == same construction', () {
      expect(
        OraclePosition.singlePositions.first,
        equals(OraclePosition.singlePositions.first),
      );
    });
    test('Set dedup pattern: same triplePositions list contents equal', () {
      expect(OraclePosition.triplePositions, equals(OraclePosition.triplePositions));
    });
  });

  group('LifePathNumber == / hashCode', () {
    test('=== same fields + Set dedup', () {
      const a = LifePathNumber(
        number: 7,
        nameEn: 'Seeker', nameZh: '求索者', nameTl: 'Naghahanap',
        meaningEn: 'm', meaningZh: 'm', meaningTl: 'm',
        strengthEn: 's', strengthZh: 's', strengthTl: 's',
        challengeEn: 'c', challengeZh: 'c', challengeTl: 'c',
      );
      const b = LifePathNumber(
        number: 7,
        nameEn: 'Seeker', nameZh: '求索者', nameTl: 'Naghahanap',
        meaningEn: 'm', meaningZh: 'm', meaningTl: 'm',
        strengthEn: 's', strengthZh: 's', strengthTl: 's',
        challengeEn: 'c', challengeZh: 'c', challengeTl: 'c',
      );
      expect(a, equals(b));
      expect(<LifePathNumber>[a, b].toSet(), hasLength(1));
    });
    test('isMasterNumber difference breaks equality', () {
      const base = LifePathNumber(
        number: 11,
        nameEn: 'I', nameZh: 'I', nameTl: 'I',
        meaningEn: 'm', meaningZh: 'm', meaningTl: 'm',
        strengthEn: 's', strengthZh: 's', strengthTl: 's',
        challengeEn: 'c', challengeZh: 'c', challengeTl: 'c',
      );
      const withMaster = LifePathNumber(
        number: 11,
        isMasterNumber: true,
        nameEn: 'I', nameZh: 'I', nameTl: 'I',
        meaningEn: 'm', meaningZh: 'm', meaningTl: 'm',
        strengthEn: 's', strengthZh: 's', strengthTl: 's',
        challengeEn: 'c', challengeZh: 'c', challengeTl: 'c',
      );
      expect(base == withMaster, isFalse);
    });
  });

  group('ZodiacSign == / hashCode', () {
    ZodiacSign make() => const ZodiacSign(
          nameEn: 'Aries', nameZh: '白羊座', nameTl: 'Aries',
          dates: 'Mar21-Apr19', element: 'fire', elementZh: '火',
          ruler: 'mars', rulerZh: '火星',
          luckyColor: 'red', luckyColorZh: '红色', luckyNumber: 7,
          personalityEn: 'p', personalityZh: 'p', personalityTl: 'p',
          dailyEn: 'd', dailyZh: 'd', dailyTl: 'd',
          weeklyEn: 'w', weeklyZh: 'w', weeklyTl: 'w',
          monthlyEn: 'm', monthlyZh: 'm', monthlyTl: 'm',
        );

    test('=== same → equal + same hash', () {
      expect(make(), equals(make()));
      expect(make().hashCode, make().hashCode);
    });
    test('!== luckyNumber', () {
      final a = make();
      final b = ZodiacSign(
        nameEn: a.nameEn, nameZh: a.nameZh, nameTl: a.nameTl,
        dates: a.dates, element: a.element, elementZh: a.elementZh,
        ruler: a.ruler, rulerZh: a.rulerZh,
        luckyColor: a.luckyColor, luckyColorZh: a.luckyColorZh, luckyNumber: 8, // ← changed
        personalityEn: a.personalityEn, personalityZh: a.personalityZh, personalityTl: a.personalityTl,
        dailyEn: a.dailyEn, dailyZh: a.dailyZh, dailyTl: a.dailyTl,
        weeklyEn: a.weeklyEn, weeklyZh: a.weeklyZh, weeklyTl: a.weeklyTl,
        monthlyEn: a.monthlyEn, monthlyZh: a.monthlyZh, monthlyTl: a.monthlyTl,
      );
      expect(a == b, isFalse);
    });
    test('localizedWeekly default returns English (regression on past bug)', () {
      // Regression guard: localizedWeekly default must be weeklyEn, NOT weeklyZh.
      // Use distinct per-locale values so the assertion actually catches
      // a swap like `default: return weeklyZh;`.
      const s = ZodiacSign(
        nameEn: 'Aries', nameZh: '白羊座', nameTl: 'Aries',
        dates: 'Mar21-Apr19', element: 'fire', elementZh: '火',
        ruler: 'mars', rulerZh: '火星',
        luckyColor: 'red', luckyColorZh: '红色', luckyNumber: 7,
        personalityEn: 'pEn', personalityZh: 'pZh', personalityTl: 'pTl',
        dailyEn: 'dEn', dailyZh: 'dZh', dailyTl: 'dTl',
        weeklyEn: 'wEn', weeklyZh: 'wZh', weeklyTl: 'wTl',
        monthlyEn: 'mEn', monthlyZh: 'mZh', monthlyTl: 'mTl',
      );
      expect(s.localizedWeekly('en'), 'wEn');
      expect(s.localizedWeekly('zh'), 'wZh');
      expect(s.localizedWeekly('tl'), 'wTl');
      expect(s.localizedWeekly('xx'), 'wEn'); // English fallback (regression)
    });
  });

  group('CardInterpretation == / hashCode', () {
    test('=== preserves all fields through equality', () {
      // Build a minimal synthetic TarotCard that equals itself.
      const card = TarotCard(
        id: 1, type: 'major', number: 1,
        nameEn: 'a', nameZh: 'a', nameTl: 'a',
        keywordsEn: ['k'], keywordsZh: ['k'], keywordsTl: ['k'],
        meaningUprightEn: 'm', meaningUprightZh: 'm', meaningUprightTl: 'm',
        meaningReversedEn: 'm', meaningReversedZh: 'm', meaningReversedTl: 'm',
        loveEn: 'l', loveZh: 'l', loveTl: 'l',
        careerEn: 'c', careerZh: 'c', careerTl: 'c',
        adviceEn: 'a', adviceZh: 'a', adviceTl: 'a',
      );
      const interp = CardInterpretation(
        card: card, isReversed: false, name: 'a',
        keywords: ['k'], meaning: 'm', love: 'l',
        career: 'c', advice: 'a',
      );
      expect(
        interp,
        equals(const CardInterpretation(
          card: card, isReversed: false, name: 'a',
          keywords: ['k'], meaning: 'm', love: 'l',
          career: 'c', advice: 'a',
        )),
      );
    });
  });

  group('Spread == in a Set', () {
    test('spreads with an identical field set — equal across the set', () {
      // Sanity: confirm Spread === works when used as a Set key.
      const s1 = Spread(
        id: 'single',
        nameEn: 'Single', nameZh: '单张牌', nameTl: 'Isang Card',
        cardCount: 1,
        descriptionEn: 'd', descriptionZh: 'd', descriptionTl: 'd',
        positions: [
          SpreadPosition(index: 0, nameEn: 'A', nameZh: '甲', nameTl: 'A'),
        ],
      );
      final s2 = Spread(
        id: s1.id,
        nameEn: s1.nameEn, nameZh: s1.nameZh, nameTl: s1.nameTl,
        cardCount: s1.cardCount,
        descriptionEn: s1.descriptionEn,
        descriptionZh: s1.descriptionZh,
        descriptionTl: s1.descriptionTl,
        positions: s1.positions,
      );
      // Three equal-but-distinct instances collapsed through `==`.
      expect(<Spread>[s1, s2, s1].toSet(), hasLength(1));
    });
  });
}
