import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/features/oracle_cards/services/oracle_reading_service.dart';

void main() {
  OracleCard cardFactory(int id) => OracleCard(
        id: id,
        nameEn: 'card-en-$id',
        nameZh: '卡牌-$id',
        nameTl: 'card-tl-$id',
        messageEn: 'message-en-$id',
        messageZh: '信息-$id',
        messageTl: 'message-tl-$id',
      );

  group('OracleCard.localized*', () {
    test('localizedName picks per-locale field with en fallback', () {
      expect(cardFactory(1).localizedName('zh'), '卡牌-1');
      expect(cardFactory(1).localizedName('tl'), 'card-tl-1');
      expect(cardFactory(1).localizedName('en'), 'card-en-1');
      expect(cardFactory(1).localizedName('xx'), 'card-en-1');
    });

    test('localizedMessage picks per-locale field with en fallback', () {
      expect(cardFactory(2).localizedMessage('zh'), '信息-2');
      expect(cardFactory(2).localizedMessage('tl'), 'message-tl-2');
      expect(cardFactory(2).localizedMessage('en'), 'message-en-2');
    });
  });

  group('OracleCard.fromJson', () {
    test('parses complete JSON', () {
      final c = OracleCard.fromJson({
        'id': 5,
        'nameEn': 'New Beginning',
        'nameZh': '新的开始',
        'nameTl': 'Bagong Simula',
        'messageEn': 'Open the door',
        'messageZh': '打开门',
        'messageTl': 'Buksan ang pinto',
      });
      expect(c.id, 5);
      expect(c.localizedName('zh'), '新的开始');
    });

    test('tolerates missing fields with defaults', () {
      final c = OracleCard.fromJson(<String, dynamic>{});
      expect(c.id, 0);
      expect(c.nameEn, '');
      expect(c.localizedName('zh'), '');
    });
  });

  group('OracleReadingResult', () {
    test('exposes card + position', () {
      final r = OracleReadingResult(card: cardFactory(1), position: 2);
      expect(r.card.id, 1);
      expect(r.position, 2);
    });
  });

  group('OraclePosition presets', () {
    test('singlePositions has exactly 1 entry = Guidance', () {
      expect(OraclePosition.singlePositions.length, 1);
      expect(OraclePosition.singlePositions.first.localizedName('zh'), '指引');
      expect(OraclePosition.singlePositions.first.localizedName('en'), 'Guidance');
    });

    test('triplePositions has 3 entries: Past / Present / Future', () {
      expect(OraclePosition.triplePositions.length, 3);
      expect(
        OraclePosition.triplePositions.map((p) => p.localizedName('en')).toList(),
        ['Past', 'Present', 'Future'],
      );
      expect(
        OraclePosition.triplePositions.map((p) => p.localizedName('zh')).toList(),
        ['过去', '现在', '未来'],
      );
      expect(
        OraclePosition.triplePositions.map((p) => p.localizedName('tl')).toList(),
        ['Nakaraan', 'Kasalukuyan', 'Kinabukasan'],
      );
    });

    test('localizedName falls back to english for unknown locale', () {
      expect(OraclePosition.triplePositions.first.localizedName('xx'), 'Past');
    });
  });
}
