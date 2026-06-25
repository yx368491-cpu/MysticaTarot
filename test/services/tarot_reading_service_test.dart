import 'package:flutter_test/flutter_test.dart';
import 'package:mystica_tarot/features/tarot/services/tarot_reading_service.dart';
import 'package:mystica_tarot/features/tarot/domain/entities/tarot_card.dart';

void main() {
  late List<TarotCard> testCards;
  late TarotReadingService service;

  setUp(() {
    testCards = [
      const TarotCard(
        id: 0,
        type: 'major',
        number: 0,
        nameEn: 'The Fool',
        nameZh: '愚者',
        nameTl: 'Ang Manga',
        keywordsEn: ['beginnings', 'innocence'],
        keywordsZh: ['开始', '天真'],
        keywordsTl: ['simula', 'inosente'],
        meaningUprightEn: 'New beginnings, spontaneity, free spirit',
        meaningUprightZh: '新的开始、自发性、自由精神',
        meaningUprightTl: 'Bagong simula, spontaneity, malayang espiritu',
        meaningReversedEn: 'Recklessness, risk-taking, holding back',
        meaningReversedZh: '鲁莽、冒险、退缩',
        meaningReversedTl: 'Pabaya, pagkuha ng panganib, pagpigil',
        loveEn: 'New romance, adventurous partnership',
        loveZh: '新的恋情、冒险的伴侣关系',
        loveTl: 'Bagong pag-ibig, adventurous na relasyon',
        careerEn: 'New career path, starting fresh',
        careerZh: '新的职业道路、重新开始',
        careerTl: 'Bagong karera, bagong simula',
        adviceEn: 'Take a leap of faith',
        adviceZh: '跳脱舒适区',
        adviceTl: 'Gumawa ng leap of faith',
      ),
      const TarotCard(
        id: 1,
        type: 'major',
        number: 1,
        nameEn: 'The Magician',
        nameZh: '魔术师',
        nameTl: 'Ang Mago',
        keywordsEn: ['power', 'skill', 'willpower'],
        keywordsZh: ['力量', '技巧', '意志力'],
        keywordsTl: ['kapangyarihan', 'kasanayan', 'determinasyon'],
        meaningUprightEn: 'Manifestation, resourcefulness, inspired action',
        meaningUprightZh: '显化、足智多谋、灵感行动',
        meaningUprightTl: 'Manifestasyon, pagiging maparaan, inspiradong aksyon',
        meaningReversedEn: 'Trickery, manipulation, untapped potential',
        meaningReversedZh: '欺骗、操控、未开发的潜力',
        meaningReversedTl: 'Panlilinlang, manipulasyon, hindi nagamit na potensyal',
        loveEn: 'Charismatic connection, active pursuit',
        loveZh: '魅力连接、主动追求',
        loveTl: 'Karismatikong koneksyon, aktibong paghabol',
        careerEn: 'Skill mastery, taking initiative',
        careerZh: '技能精通、主动出击',
        careerTl: 'Pagpapakadalubhasa sa kasanayan, pagkuha ng inisyatibo',
        adviceEn: 'Use your skills and resources wisely',
        adviceZh: '善用你的技能和资源',
        adviceTl: 'Gamitin ang iyong mga kasanayan at resources nang matalino',
      ),
      const TarotCard(
        id: 2,
        type: 'major',
        number: 2,
        nameEn: 'The High Priestess',
        nameZh: '女祭司',
        nameTl: 'Ang Mataas na Pari',
        keywordsEn: ['intuition', 'mystery', 'inner knowledge'],
        keywordsZh: ['直觉', '神秘', '内在知识'],
        keywordsTl: ['intuwisyon', 'misteryo', 'panloob na kaalaman'],
        meaningUprightEn: 'Intuition, unconscious knowledge, mystery',
        meaningUprightZh: '直觉、潜意识知识、神秘',
        meaningUprightTl: 'Intuwisyon, hindi malay na kaalaman, misteryo',
        meaningReversedEn: 'Secrets, withdrawal, silence',
        meaningReversedZh: '秘密、退缩、沉默',
        meaningReversedTl: 'Lihim, pag-atras, katahimikan',
        loveEn: 'Deep emotional connection, spiritual bond',
        loveZh: '深层情感连接、灵性纽带',
        loveTl: 'Malalim na emosyonal na koneksyon, espiritwal na bigkis',
        careerEn: 'Trust your instincts at work',
        careerZh: '工作中相信直觉',
        careerTl: 'Magtiwala sa iyong instincts sa trabaho',
        adviceEn: 'Listen to your inner voice',
        adviceZh: '倾听你内心的声音',
        adviceTl: 'Makinig sa iyong panloob na boses',
      ),
    ];
    service = TarotReadingService(testCards, seed: 42);
  });

  group('TarotReadingService', () {
    test('allCards returns all cards', () {
      expect(service.allCards.length, 3);
      expect(service.allCards[0].nameEn, 'The Fool');
    });

    test('shuffleCards returns all cards in different order', () {
      final shuffled = service.shuffleCards();
      expect(shuffled.length, 3);
      // With seed 42, not all cards should be in original order
      final allSame = shuffled.every(
        (card) => shuffled.indexOf(card) == testCards.indexOf(card),
      );
      expect(allSame, isFalse);
    });

    test('shuffleCards is deterministic with same seed', () {
      final service1 = TarotReadingService(testCards, seed: 42);
      final service2 = TarotReadingService(testCards, seed: 42);
      final shuffled1 = service1.shuffleCards();
      final shuffled2 = service2.shuffleCards();
      expect(shuffled1.map((c) => c.id), equals(shuffled2.map((c) => c.id)));
    });

    test('drawCards returns correct number of results', () {
      final results = service.drawCards(2);
      expect(results.length, 2);
      expect(results[0].cardIndex, isA<int>());
      expect(results[0].position, 0);
      expect(results[1].position, 1);
    });

    test('drawCards does not exceed available cards', () {
      final results = service.drawCards(10);
      expect(results.length, 3); // Only 3 cards available
    });

    test('drawCardsSeeded is deterministic with same seed', () {
      final results1 = service.drawCardsSeeded(2, 123);
      final results2 = service.drawCardsSeeded(2, 123);
      expect(results1[0].cardIndex, equals(results2[0].cardIndex));
      expect(results1[1].cardIndex, equals(results2[1].cardIndex));
    });

    test('drawCardsSeeded returns different results with different seeds', () {
      final results1 = service.drawCardsSeeded(2, 123);
      final results2 = service.drawCardsSeeded(2, 456);
      // High likelihood of at least one difference
      final isDifferent = results1[0].cardIndex != results2[0].cardIndex ||
          results1[1].cardIndex != results2[1].cardIndex;
      expect(isDifferent, isTrue);
    });

    test('cutDeck returns all cards rearranged', () {
      final cut = service.cutDeck(testCards, cutPosition: 1);
      expect(cut.length, 3);
      // cutPosition=1: top=[0], bottom=[1,2] => [1, 2, 0]
      expect(cut[0].id, 1);
      expect(cut[1].id, 2);
      expect(cut[2].id, 0);
    });

    test('interpretCard returns correct upright interpretation', () {
      final card = testCards[0];
      final interpretation = service.interpretCard(card, false, 'en');
      expect(interpretation.name, 'The Fool');
      expect(interpretation.isReversed, false);
      expect(interpretation.meaning, 'New beginnings, spontaneity, free spirit');
      expect(interpretation.keywords, contains('beginnings'));
    });

    test('interpretCard returns correct reversed interpretation', () {
      final card = testCards[0];
      final interpretation = service.interpretCard(card, true, 'en');
      expect(interpretation.name, 'The Fool');
      expect(interpretation.isReversed, true);
      expect(interpretation.meaning, 'Recklessness, risk-taking, holding back');
      expect(interpretation.love, 'New romance, adventurous partnership');
      expect(interpretation.career, 'New career path, starting fresh');
      expect(interpretation.advice, 'Take a leap of faith');
    });

    test('interpretCard supports Chinese locale', () {
      final card = testCards[1];
      final interpretation = service.interpretCard(card, false, 'zh');
      expect(interpretation.name, '魔术师');
      expect(interpretation.meaning, '显化、足智多谋、灵感行动');
      expect(interpretation.keywords, contains('力量'));
    });

    test('interpretCard supports Tagalog locale', () {
      final card = testCards[2];
      final interpretation = service.interpretCard(card, false, 'tl');
      expect(interpretation.name, 'Ang Mataas na Pari');
      expect(interpretation.meaning, 'Intuwisyon, hindi malay na kaalaman, misteryo');
      expect(interpretation.keywords, contains('intuwisyon'));
    });
  });
}
