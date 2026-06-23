import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/features/fortune_slip/services/fortune_slip_service.dart';

void main() {
  FortuneSlip slipFactory(String grade) => FortuneSlip(
        id: 1,
        grade: grade,
        gradeEn: 'grade-en-$grade',
        gradeZh: '签级-$grade',
        gradeTl: 'grade-tl-$grade',
        textEn: 'text-en-$grade',
        textZh: '签文-$grade',
        textTl: 'text-tl-$grade',
      );

  group('FortuneSlip.localized*', () {
    test('localizedGrade picks per-locale field with en fallback', () {
      expect(slipFactory('daiji').localizedGrade('zh'), '签级-daiji');
      expect(slipFactory('daiji').localizedGrade('tl'), 'grade-tl-daiji');
      expect(slipFactory('daiji').localizedGrade('en'), 'grade-en-daiji');
      expect(slipFactory('daiji').localizedGrade('xx'), 'grade-en-daiji');
    });

    test('localizedText picks per-locale field with en fallback', () {
      expect(slipFactory('kyo').localizedText('zh'), '签文-kyo');
      expect(slipFactory('kyo').localizedText('tl'), 'text-tl-kyo');
      expect(slipFactory('kyo').localizedText('en'), 'text-en-kyo');
    });
  });

  group('FortuneSlip.rank', () {
    test('rank order: daiji(0) < chukichi(1) < kichi(2) < shokichi(3) < suekichi(4) < kyo(5)', () {
      expect(slipFactory('daiji').rank, 0);
      expect(slipFactory('chukichi').rank, 1);
      expect(slipFactory('kichi').rank, 2);
      expect(slipFactory('shokichi').rank, 3);
      expect(slipFactory('suekichi').rank, 4);
      expect(slipFactory('kyo').rank, 5);
    });

    test('sorting by rank yields best → worst', () {
      final slips = [slipFactory('kyo'), slipFactory('daiji'), slipFactory('shokichi'), slipFactory('kichi')];
      slips.sort((a, b) => a.rank.compareTo(b.rank));
      expect(slips.map((s) => s.grade).toList(),
          ['daiji', 'kichi', 'shokichi', 'kyo']);
    });

    test('unknown grade defaults to rank 3 (shokichi)', () {
      expect(slipFactory('lucky').rank, 3);
    });
  });

  group('FortuneSlip.fromJson', () {
    test('parses complete JSON', () {
      final s = FortuneSlip.fromJson({
        'id': 7,
        'grade': 'daiji',
        'gradeEn': 'Great Blessing',
        'gradeZh': '大吉',
        'gradeTl': 'Malaking Biyaya',
        'textEn': 'Wonderful things await',
        'textZh': '好运将至',
        'textTl': 'Magandang bagay ang naghihintay',
      });
      expect(s.id, 7);
      expect(s.grade, 'daiji');
      expect(s.localizedGrade('zh'), '大吉');
    });

    test('tolerates missing fields with defaults', () {
      final s = FortuneSlip.fromJson(<String, dynamic>{});
      expect(s.id, 0);
      expect(s.grade, '');
      expect(s.rank, 3); // default rank
    });
  });

  group('FortuneSlipService.getGradeEmoji', () {
    test('returns emoji for each grade', () {
      expect(FortuneSlipService.getGradeEmoji('daiji'), '🎉');
      expect(FortuneSlipService.getGradeEmoji('chukichi'), '🌟');
      expect(FortuneSlipService.getGradeEmoji('kichi'), '✨');
      expect(FortuneSlipService.getGradeEmoji('shokichi'), '💫');
      expect(FortuneSlipService.getGradeEmoji('suekichi'), '🌱');
      expect(FortuneSlipService.getGradeEmoji('kyo'), '🍂');
    });

    test('falls back to 🔮 for unknown grade', () {
      expect(FortuneSlipService.getGradeEmoji('mystery'), '🔮');
      expect(FortuneSlipService.getGradeEmoji(''), '🔮');
    });
  });
}
