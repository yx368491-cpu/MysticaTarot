import '../domain/entities/life_path_number.dart';

/// Numerology calculation service
class NumerologyService {
  /// Calculate life path number from birthday
  /// Reduces date digits until a single digit (1-9) or master number (11, 22, 33)
  static int calculateLifePathNumber(int year, int month, int day) {
    int sum = _reduceToDigit(year) + _reduceToDigit(month) + _reduceToDigit(day);
    sum = _reduceToDigit(sum);
    // Check for master numbers
    if (sum == 11 || sum == 22 || sum == 33) return sum;
    // Reduce to single digit
    while (sum > 9) {
      sum = _reduceToDigit(sum);
    }
    return sum;
  }

  /// Calculate destiny number from full name (A=1, B=2, ..., Z=26)
  static int calculateDestinyNumber(String fullName) {
    final cleaned = fullName.replaceAll(RegExp(r'[^a-zA-Z]'), '').toUpperCase();
    int sum = 0;
    for (final char in cleaned.runes) {
      final value = char - 64; // A=1, B=2, ...
      if (value >= 1 && value <= 26) {
        sum += value;
      }
    }
    sum = _reduceToDigit(sum);
    if (sum == 11 || sum == 22 || sum == 33) return sum;
    while (sum > 9) {
      sum = _reduceToDigit(sum);
    }
    return sum;
  }

  static int _reduceToDigit(int num) {
    int sum = 0;
    for (final char in num.abs().toString().runes) {
      sum += char - 48; // '0' = 48
    }
    return sum;
  }

  /// Get life path number data for a calculated number
  static LifePathNumber getLifePathData(int number) {
    return _allNumbers.firstWhere(
      (n) => n.number == number,
      orElse: () => _allNumbers.first,
    );
  }

  static const List<LifePathNumber> _allNumbers = [
    LifePathNumber(
      number: 1,
      nameEn: 'The Leader',
      nameZh: '领导者',
      nameTl: 'Ang Pinuno',
      meaningEn: 'You are a natural-born leader with a pioneering spirit. Independent, ambitious, and innovative.',
      meaningZh: '你是天生的领导者，具有开拓精神。独立、雄心勃勃、创新。',
      meaningTl: 'Ikaw ay likas na pinuno na may pioneer spirit. Independyente, ambisyoso, at makabago.',
      strengthEn: 'Leadership, independence, creativity, determination, originality',
      strengthZh: '领导力、独立性、创造力、决心、原创性',
      strengthTl: 'Pamumuno, kalayaan, pagkamalikhain, determinasyon, orihinalidad',
      challengeEn: 'Arrogance, stubbornness, impatience, dominance',
      challengeZh: '傲慢、固执、急躁、控制欲',
      challengeTl: 'Kayabangan, katigasan ng ulo, pagkainip, pangingibabaw',
    ),
    LifePathNumber(
      number: 2,
      nameEn: 'The Peacemaker',
      nameZh: '和平使者',
      nameTl: 'Ang Tagapamayapa',
      meaningEn: 'You are a natural diplomat who seeks harmony and balance. Cooperative, sensitive, and intuitive.',
      meaningZh: '你是天生的外交家，追求和谐与平衡。合作、敏感、直觉强。',
      meaningTl: 'Ikaw ay natural na diplomat na naghahanap ng harmoniya at balanse. Kooperatibo, sensitibo, at intuitive.',
      strengthEn: 'Diplomacy, cooperation, sensitivity, patience, intuition',
      strengthZh: '外交手腕、合作、敏感、耐心、直觉',
      strengthTl: 'Diplomasya, kooperasyon, sensitibidad, pasensya, intuwisyon',
      challengeEn: 'Timidity, indecisiveness, over-sensitivity, self-neglect',
      challengeZh: '胆怯、优柔寡断、过度敏感、忽视自我',
      challengeTl: 'Pagkamahiyain, pag-aalinlangan, sobrang sensitibo, pagpapabaya sa sarili',
    ),
    LifePathNumber(
      number: 3,
      nameEn: 'The Creative',
      nameZh: '创造者',
      nameTl: 'Ang Malikhain',
      meaningEn: 'You are a creative soul with a gift for self-expression. Optimistic, charming, and inspiring.',
      meaningZh: '你是富有创造力的灵魂，有自我表达的天赋。乐观、魅力、激励人心。',
      meaningTl: 'Ikaw ay isang malikhaing kaluluwa na may talento sa pagpapahayag. Optimistiko, kaakit-akit, at nagbibigay-inspirasyon.',
      strengthEn: 'Creativity, optimism, charisma, self-expression, social grace',
      strengthZh: '创造力、乐观、魅力、自我表达、社交优雅',
      strengthTl: 'Pagkamalikhain, optimismo, karisma, pagpapahayag, sosyal na grasya',
      challengeEn: 'Scattered energy, superficiality, criticism, moodiness',
      challengeZh: '能量分散、表面化、挑剔、情绪化',
      challengeTl: 'Nakakalat na enerhiya, kababawan, pagpuna, pagbabago ng mood',
    ),
    LifePathNumber(
      number: 4,
      nameEn: 'The Builder',
      nameZh: '建设者',
      nameTl: 'Ang Tagapagtayo',
      meaningEn: 'You are a practical and reliable builder of solid foundations. Disciplined, hardworking, and honest.',
      meaningZh: '你是务实可靠的建设者，建立坚实的基础。自律、勤奋、诚实。',
      meaningTl: 'Ikaw ay praktikal at maaasahang tagapagtayo ng matatag na pundasyon. Disiplinado, masipag, at tapat.',
      strengthEn: 'Practicality, reliability, discipline, determination, organization',
      strengthZh: '务实、可靠、自律、决心、组织力',
      strengthTl: 'Praktikalidad, pagiging maaasahan, disiplina, determinasyon, organisasyon',
      challengeEn: 'Rigidity, stubbornness, narrow-mindedness, workaholism',
      challengeZh: '僵化、固执、思想狭隘、工作狂',
      challengeTl: 'Katigasan, katigasan ng ulo, makitid na pag-iisip, workaholism',
    ),
    LifePathNumber(
      number: 5,
      nameEn: 'The Adventurer',
      nameZh: '冒险家',
      nameTl: 'Ang Adventurero',
      meaningEn: 'You are a free spirit who craves adventure and variety. Versatile, curious, and adaptable.',
      meaningZh: '你是渴望冒险和多样性的自由精神。多才多艺、好奇、适应力强。',
      meaningTl: 'Ikaw ay malayang espiritu na naghahangad ng pakikipagsapalaran at pagkakaiba-iba. Maraming kakayahan, mausisa, at madaling umangkop.',
      strengthEn: 'Versatility, adaptability, curiosity, courage, freedom',
      strengthZh: '多才多艺、适应力、好奇心、勇气、自由',
      strengthTl: 'Maraming kakayahan, kakayahang umangkop, kuryusidad, tapang, kalayaan',
      challengeEn: 'Restlessness, impulsiveness, irresponsibility, excess',
      challengeZh: '不安、冲动、不负责任、过度',
      challengeTl: 'Pagkabalisa, pagiging mapusok, kawalan ng pananagutan, labis',
    ),
    LifePathNumber(
      number: 6,
      nameEn: 'The Caretaker',
      nameZh: '守护者',
      nameTl: 'Ang Tagapangalaga',
      meaningEn: 'You are a nurturing soul who values family and community. Compassionate, responsible, and loving.',
      meaningZh: '你是关爱他人的灵魂，重视家庭和社区。富有同情心、负责、充满爱心。',
      meaningTl: 'Ikaw ay nag-aalaga na kaluluwa na pinahahalagahan ang pamilya at komunidad. Mahabagin, responsable, at mapagmahal.',
      strengthEn: 'Nurturing, responsibility, compassion, creativity, balance',
      strengthZh: '关怀、责任感、同情心、创造力、平衡',
      strengthTl: 'Pag-aalaga, pananagutan, habag, pagkamalikhain, balanse',
      challengeEn: 'Over-protectiveness, interference, self-righteousness, worry',
      challengeZh: '过度保护、干涉、自以为是、担忧',
      challengeTl: 'Labis na proteksyon, panghihimasok, pagiging mapagmatuwid, pag-aalala',
    ),
    LifePathNumber(
      number: 7,
      nameEn: 'The Seeker',
      nameZh: '求索者',
      nameTl: 'Ang Naghahanap',
      meaningEn: 'You are a deep thinker and spiritual seeker. Analytical, introspective, and wise.',
      meaningZh: '你是深刻的思想家和灵性探索者。分析力强、内省、智慧。',
      meaningTl: 'Ikaw ay malalim na nag-iisip at espiritwal na naghahanap. Analitikal, mapagnilay, at marunong.',
      strengthEn: 'Analysis, intuition, wisdom, perfection, spirituality',
      strengthZh: '分析力、直觉、智慧、完美、灵性',
      strengthTl: 'Analisis, intuwisyon, karunungan, perpeksyon, espiritwalidad',
      challengeEn: 'Isolation, skepticism, aloofness, secrecy',
      challengeZh: '孤立、怀疑、冷漠、隐秘',
      challengeTl: 'Paghihiwalay, pag-aalinlangan, pagkalayo, lihim',
    ),
    LifePathNumber(
      number: 8,
      nameEn: 'The Achiever',
      nameZh: '成就者',
      nameTl: 'Ang Nakakamit',
      meaningEn: 'You are a powerful achiever with a head for business and ambition. Authoritative, driven, and successful.',
      meaningZh: '你是强有力的成就者，有商业头脑和雄心。权威、动力、成功。',
      meaningTl: 'Ikaw ay makapangyarihang nakakamit na may ulo para sa negosyo at ambisyon. May awtoridad, determinado, at matagumpay.',
      strengthEn: 'Ambition, authority, business sense, leadership, efficiency',
      strengthZh: '雄心、权威、商业头脑、领导力、效率',
      strengthTl: 'Ambisyon, awtoridad, sentido sa negosyo, pamumuno, kahusayan',
      challengeEn: 'Materialism, workaholism, arrogance, ruthlessness',
      challengeZh: '物质主义、工作狂、傲慢、冷酷',
      challengeTl: 'Materialismo, workaholism, kayabangan, kawalan ng awa',
    ),
    LifePathNumber(
      number: 9,
      nameEn: 'The Humanitarian',
      nameZh: '人道主义者',
      nameTl: 'Ang Humanitarian',
      meaningEn: 'You are a compassionate humanitarian with a global vision. Selfless, creative, and generous.',
      meaningZh: '你是富有同情心的人道主义者，具有全球视野。无私、创造力、慷慨。',
      meaningTl: 'Ikaw ay mahabaging humanitarian na may pandaigdigang pananaw. Walang pag-iimbot, malikhain, at mapagbigay.',
      strengthEn: 'Compassion, creativity, generosity, wisdom, tolerance',
      strengthZh: '同情心、创造力、慷慨、智慧、包容',
      strengthTl: 'Habag, pagkamalikhain, pagkabukas-palad, karunungan, pagpapaubaya',
      challengeEn: 'Emotional intensity, financial struggles, letting go',
      challengeZh: '情感强烈、财务困扰、难以放手',
      challengeTl: 'Emosyonal na intensidad, pinansiyal na pakikibaka, pagbitaw',
    ),
    LifePathNumber(
      number: 11,
      isMasterNumber: true,
      nameEn: 'The Intuitive',
      nameZh: '直觉者',
      nameTl: 'Ang Intuitibo',
      meaningEn: 'Master number of intuition and spiritual insight. Highly intuitive, inspirational, and enlightened.',
      meaningZh: '直觉和灵性洞察的导师数字。高度直觉、激励人心、启迪。',
      meaningTl: 'Master number ng intuwisyon at espiritwal na pananaw. Lubos na intuitive, nagbibigay-inspirasyon, at maliwanagan.',
      strengthEn: 'Intuition, inspiration, spiritual insight, enlightenment, charisma',
      strengthZh: '直觉、灵感、灵性洞察、启迪、魅力',
      strengthTl: 'Intuwisyon, inspirasyon, espiritwal na pananaw, kaliwanagan, karisma',
      challengeEn: 'Nervous tension, unrealistic expectations, oversensitivity',
      challengeZh: '紧张、不切实际的期望、过度敏感',
      challengeTl: 'Pagkabalisang tensyon, hindi makatotohanang inaasahan, sobrang sensitibo',
    ),
    LifePathNumber(
      number: 22,
      isMasterNumber: true,
      nameEn: 'The Master Builder',
      nameZh: '大师建造者',
      nameTl: 'Ang Master Builder',
      meaningEn: 'Master number of manifesting dreams into reality. Powerful, visionary, and practical.',
      meaningZh: '将梦想变为现实的大师数字。强大、远见、务实。',
      meaningTl: 'Master number ng pagpapakita ng mga pangarap sa katotohanan. Makapangyarihan, visionary, at praktikal.',
      strengthEn: 'Manifestation, vision, practicality, leadership, influence',
      strengthZh: '显化、愿景、务实、领导力、影响力',
      strengthTl: 'Manifestasyon, pananaw, praktikalidad, pamumuno, impluwensya',
      challengeEn: 'Overwhelming responsibility, burnout, control issues',
      challengeZh: '压倒性的责任、倦怠、控制问题',
      challengeTl: 'Napakalaking responsibilidad, burnout, isyu sa kontrol',
    ),
    LifePathNumber(
      number: 33,
      isMasterNumber: true,
      nameEn: 'The Master Teacher',
      nameZh: '大师教师',
      nameTl: 'Ang Master Teacher',
      meaningEn: 'Master number of unconditional love and compassion. Selfless, nurturing, and inspiring.',
      meaningZh: '无条件的爱和同情心的大师数字。无私、滋养、激励人心。',
      meaningTl: 'Master number ng walang kondisyong pag-ibig at habag. Walang pag-iimbot, nag-aalaga, at nagbibigay-inspirasyon.',
      strengthEn: 'Compassion, teaching, healing, creativity, unconditional love',
      strengthZh: '同情心、教学、疗愈、创造力、无条件的爱',
      strengthTl: 'Habag, pagtuturo, paggaling, pagkamalikhain, walang kondisyong pag-ibig',
      challengeEn: 'Emotional overload, self-sacrifice, boundary issues',
      challengeZh: '情感过载、自我牺牲、边界问题',
      challengeTl: 'Emosyonal na labis, pagsasakripisyo sa sarili, isyu sa hangganan',
    ),
  ];
}
