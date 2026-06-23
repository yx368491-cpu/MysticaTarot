import '../domain/entities/spread.dart';

/// Service for managing spread layouts
class SpreadService {
  /// All available spreads
  static const List<Spread> allSpreads = [
    Spread(
      id: 'single',
      nameEn: 'Single Card',
      nameZh: '单张牌',
      nameTl: 'Isang Card',
      cardCount: 1,
      descriptionEn: 'Quick daily guidance from a single card.',
      descriptionZh: '单张牌快速指引。',
      descriptionTl: 'Mabilis na gabay mula sa isang card.',
      positions: [
        SpreadPosition(index: 0, nameEn: 'Guidance', nameZh: '指引', nameTl: 'Gabay'),
      ],
    ),
    Spread(
      id: 'three',
      nameEn: 'Three Cards',
      nameZh: '三张牌',
      nameTl: 'Tatlong Cards',
      cardCount: 3,
      descriptionEn: 'Past - Present - Future insight.',
      descriptionZh: '过去 - 现在 - 未来洞察。',
      descriptionTl: 'Nakaraan - Kasalukuyan - Kinabukasan.',
      positions: [
        SpreadPosition(index: 0, nameEn: 'Past', nameZh: '过去', nameTl: 'Nakaraan', descriptionEn: 'What has passed', descriptionZh: '已经过去的事', descriptionTl: 'Ang lumipas na'),
        SpreadPosition(index: 1, nameEn: 'Present', nameZh: '现在', nameTl: 'Kasalukuyan', descriptionEn: 'What is now', descriptionZh: '当下的事', descriptionTl: 'Ang kasalukuyan'),
        SpreadPosition(index: 2, nameEn: 'Future', nameZh: '未来', nameTl: 'Kinabukasan', descriptionEn: 'What will come', descriptionZh: '将要发生的事', descriptionTl: 'Ang darating'),
      ],
    ),
    Spread(
      id: 'celtic_cross',
      nameEn: 'Celtic Cross',
      nameZh: '凯尔特十字',
      nameTl: 'Celtic Cross',
      cardCount: 10,
      descriptionEn: 'Classic deep reading for comprehensive insight.',
      descriptionZh: '经典深度解读，全面洞悉。',
      descriptionTl: 'Klasikong malalim na pagbabasa para sa komprehensibong pananaw.',
      positions: [
        SpreadPosition(index: 0, nameEn: 'Center', nameZh: '中心', nameTl: 'Gitna', descriptionEn: 'Current situation', descriptionZh: '当前状况', descriptionTl: 'Kasalukuyang sitwasyon'),
        SpreadPosition(index: 1, nameEn: 'Crossing', nameZh: '阻碍', nameTl: 'Hadlang', descriptionEn: 'Challenge', descriptionZh: '挑战', descriptionTl: 'Hamon'),
        SpreadPosition(index: 2, nameEn: 'Foundation', nameZh: '基础', nameTl: 'Pundasyon', descriptionEn: 'Root cause', descriptionZh: '根本原因', descriptionTl: 'Ugat'),
        SpreadPosition(index: 3, nameEn: 'Past', nameZh: '过去', nameTl: 'Nakaraan', descriptionEn: 'Recent past', descriptionZh: '近期过去', descriptionTl: 'Kamakailan'),
        SpreadPosition(index: 4, nameEn: 'Crown', nameZh: '最佳', nameTl: 'Pinakamahusay', descriptionEn: 'Potential outcome', descriptionZh: '潜在结果', descriptionTl: 'Potensyal na resulta'),
        SpreadPosition(index: 5, nameEn: 'Future', nameZh: '未来', nameTl: 'Kinabukasan', descriptionEn: 'Near future', descriptionZh: '近期未来', descriptionTl: 'Malapit na hinaharap'),
        SpreadPosition(index: 6, nameEn: 'Advice', nameZh: '建议', nameTl: 'Payo', descriptionEn: 'Advice to follow', descriptionZh: '应遵循的建议', descriptionTl: 'Payo na sundan'),
        SpreadPosition(index: 7, nameEn: 'Self', nameZh: '自我', nameTl: 'Sarili', descriptionEn: 'Your perspective', descriptionZh: '你的视角', descriptionTl: 'Iyong pananaw'),
        SpreadPosition(index: 8, nameEn: 'Environment', nameZh: '环境', nameTl: 'Kapaligiran', descriptionEn: 'External influences', descriptionZh: '外部影响', descriptionTl: 'Panlabas na impluwensya'),
        SpreadPosition(index: 9, nameEn: 'Final Outcome', nameZh: '最终结果', nameTl: 'Huling Resulta', descriptionEn: 'Final outcome', descriptionZh: '最终结果', descriptionTl: 'Huling resulta'),
      ],
    ),
    Spread(
      id: 'relationship',
      nameEn: 'Relationship',
      nameZh: '关系牌阵',
      nameTl: 'Relasyon',
      cardCount: 6,
      descriptionEn: 'Deep relationship analysis between two people.',
      descriptionZh: '两人之间的深度关系分析。',
      descriptionTl: 'Malalim na pagsusuri ng relasyon sa pagitan ng dalawang tao.',
      positions: [
        SpreadPosition(index: 0, nameEn: 'You', nameZh: '你', nameTl: 'Ikaw', descriptionEn: 'Your current state', descriptionZh: '你的当前状态', descriptionTl: 'Iyong kasalukuyang estado'),
        SpreadPosition(index: 1, nameEn: 'Them', nameZh: '对方', nameTl: 'Sila', descriptionEn: 'Their perspective', descriptionZh: '对方的视角', descriptionTl: 'Kanilang pananaw'),
        SpreadPosition(index: 2, nameEn: 'Bond', nameZh: '纽带', nameTl: 'Bigkis', descriptionEn: 'What connects you', descriptionZh: '连接你们的事物', descriptionTl: 'Nag-uugnay sa inyo'),
        SpreadPosition(index: 3, nameEn: 'Challenge', nameZh: '挑战', nameTl: 'Hamon', descriptionEn: 'Relationship challenge', descriptionZh: '关系中的挑战', descriptionTl: 'Hamon sa relasyon'),
        SpreadPosition(index: 4, nameEn: 'Advice', nameZh: '建议', nameTl: 'Payo', descriptionEn: 'Guidance for the relationship', descriptionZh: '对关系的建议', descriptionTl: 'Gabay para sa relasyon'),
        SpreadPosition(index: 5, nameEn: 'Outcome', nameZh: '结果', nameTl: 'Resulta', descriptionEn: 'Potential outcome', descriptionZh: '潜在结果', descriptionTl: 'Potensyal na resulta'),
      ],
    ),
    Spread(
      id: 'wish',
      nameEn: 'Wish',
      nameZh: '愿望牌阵',
      nameTl: 'Wish',
      cardCount: 4,
      descriptionEn: 'Goal achievement path analysis.',
      descriptionZh: '目标达成路径分析。',
      descriptionTl: 'Pagsusuri ng landas ng tagumpay.',
      positions: [
        SpreadPosition(index: 0, nameEn: 'Wish', nameZh: '愿望', nameTl: 'Wish', descriptionEn: 'Your wish or goal', descriptionZh: '你的愿望或目标', descriptionTl: 'Iyong wish o layunin'),
        SpreadPosition(index: 1, nameEn: 'Obstacle', nameZh: '障碍', nameTl: 'Hadlang', descriptionEn: 'What stands in the way', descriptionZh: '横亘的障碍', descriptionTl: 'Ano ang humahadlang'),
        SpreadPosition(index: 2, nameEn: 'Action', nameZh: '行动', nameTl: 'Aksyon', descriptionEn: 'Action needed', descriptionZh: '需要采取的行动', descriptionTl: 'Kailangang aksyon'),
        SpreadPosition(index: 3, nameEn: 'Result', nameZh: '结果', nameTl: 'Resulta', descriptionEn: 'Likely outcome', descriptionZh: '可能的结果', descriptionTl: 'Malamang na resulta'),
      ],
    ),
    Spread(
      id: 'four_seasons',
      nameEn: 'Four Seasons',
      nameZh: '四季牌阵',
      nameTl: 'Apat na Season',
      cardCount: 4,
      descriptionEn: 'Quarterly seasonal outlook spread.',
      descriptionZh: '季度运势展望牌阵。',
      descriptionTl: 'Pananaw sa quarterly ng season.',
      positions: [
        SpreadPosition(index: 0, nameEn: 'Spring', nameZh: '春季', nameTl: 'Spring', descriptionEn: 'Spring quarter outlook', descriptionZh: '春季展望', descriptionTl: 'Pananaw ng Spring'),
        SpreadPosition(index: 1, nameEn: 'Summer', nameZh: '夏季', nameTl: 'Summer', descriptionEn: 'Summer quarter outlook', descriptionZh: '夏季展望', descriptionTl: 'Pananaw ng Summer'),
        SpreadPosition(index: 2, nameEn: 'Autumn', nameZh: '秋季', nameTl: 'Autumn', descriptionEn: 'Autumn quarter outlook', descriptionZh: '秋季展望', descriptionTl: 'Pananaw ng Autumn'),
        SpreadPosition(index: 3, nameEn: 'Winter', nameZh: '冬季', nameTl: 'Winter', descriptionEn: 'Winter quarter outlook', descriptionZh: '冬季展望', descriptionTl: 'Pananaw ng Winter'),
      ],
    ),
  ];

  /// Get spread by ID
  static Spread? getSpreadById(String id) {
    try {
      return allSpreads.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
