import json

# Generate all 22 major arcana cards
cards_data = [
    {"id": 0, "nameEn": "The Fool", "nameZh": "愚人", "nameTl": "Ang Mangmang",
     "keywordsEn": ["Beginnings", "Innocence", "Spontaneity"],
     "keywordsZh": ["开始", "纯真", "自发性"],
     "keywordsTl": ["Simula", "Inosente", "Kusa"],
     "meaningUprightEn": "New beginnings, spontaneity, free spirit. Embrace the unknown with optimism.",
     "meaningUprightZh": "新的开始、自发性、自由精神。以乐观拥抱未知。",
     "meaningUprightTl": "Mga bagong simula, kusa, malayang espiritu. Yakapin ang hindi kilala.",
     "meaningReversedEn": "Recklessness, risk-taking, naivety. Acting without thinking.",
     "meaningReversedZh": "鲁莽、冒险、天真。不经思考的行动。",
     "meaningReversedTl": "Pagkawalang-ingat, pagiging musmos. Kumilos nang hindi nag-iisip.",
     "loveEn": "A new romance or phase is beginning. Be open to love surprises.",
     "loveZh": "新的恋情或阶段开始。对爱的惊喜保持开放。",
     "loveTl": "Isang bagong pag-ibig ay nagsisimula. Maging bukas sa mga sorpresa.",
     "careerEn": "A new job or project calls. Trust your instincts and take the leap.",
     "careerZh": "新工作或项目在召唤。相信直觉，勇敢迈出。",
     "careerTl": "Isang bagong trabaho ang tumatawag. Magtiwala sa instincts.",
     "adviceEn": "Take a leap of faith. The universe supports your journey.",
     "adviceZh": "大胆一跃。宇宙支持你的旅程。",
     "adviceTl": "Magtiwala sa paglalakbay. Ang sansinukob ay sumusuporta."},
    {"id": 1, "nameEn": "The Magician", "nameZh": "魔术师", "nameTl": "Ang Salamangkero",
     "keywordsEn": ["Willpower", "Skill", "Resourcefulness"],
     "keywordsZh": ["意志力", "技能", "足智多谋"],
     "keywordsTl": ["Lakas ng loob", "Kasanayan", "Mapamaraan"],
     "meaningUprightEn": "Willpower, skill, manifestation. You have all the tools you need.",
     "meaningUprightZh": "意志力、技能、显化。你拥有所需的一切工具。",
     "meaningUprightTl": "Lakas ng loob, kasanayan, pagpapakita. Nasa iyo na ang lahat.",
     "meaningReversedEn": "Manipulation, trickery, untapped potential. Misusing talents.",
     "meaningReversedZh": "操纵、欺骗、未开发的潜力。误用才能。",
     "meaningReversedTl": "Pagmamanipula, daya, hindi nagamit na potensyal.",
     "loveEn": "Charm and confidence attract love. Express your true feelings.",
     "loveZh": "魅力与自信吸引爱情。表达真实感受。",
     "loveTl": "Alindog at kumpiyansa ay umaakit ng pag-ibig. Ipahayag ang nararamdaman.",
     "careerEn": "Skills align for success. Take action on your ideas now.",
     "careerZh": "技能与成功匹配。为想法采取行动。",
     "careerTl": "Ang mga kasanayan ay nakaayon para sa tagumpay. Kumilos na.",
     "adviceEn": "You have everything. Focus your will and take action.",
     "adviceZh": "你拥有一切。集中意志，采取行动。",
     "adviceTl": "Nasa iyo na ang lahat. Tumutok at kumilos."},
]

remaining = [
    ("The High Priestess", "女祭司", "Ang Dakilang Saserdotisa", ["Intuition", "Mystery", "Inner Knowledge"], ["直觉", "神秘", "内在知识"], ["Intuwisyon", "Misteryo", "Panloob na Kaalaman"]),
    ("The Empress", "女皇", "Ang Emperatris", ["Femininity", "Nurturing", "Abundance"], ["女性气质", "滋养", "丰盛"], ["Pagkababae", "Pag-aalaga", "Kasaganaan"]),
    ("The Emperor", "皇帝", "Ang Emperador", ["Authority", "Structure", "Stability"], ["权威", "结构", "稳定"], ["Awtoridad", "Istraktura", "Katatagan"]),
    ("The Hierophant", "教皇", "Ang Hieropante", ["Tradition", "Guidance", "Conformity"], ["传统", "指引", "遵从"], ["Tradisyon", "Gabay", "Pagsunod"]),
    ("The Lovers", "恋人", "Ang Mga Magkasintahan", ["Love", "Harmony", "Choices"], ["爱情", "和谐", "选择"], ["Pag-ibig", "Harmoniya", "Pagpili"]),
    ("The Chariot", "战车", "Ang Karwahe", ["Willpower", "Victory", "Determination"], ["意志力", "胜利", "决心"], ["Lakas ng Loob", "Tagumpay", "Determinasyon"]),
    ("Strength", "力量", "Lakas", ["Courage", "Inner Strength", "Compassion"], ["勇气", "内在力量", "慈悲"], ["Tapang", "Panloob na Lakas", "Habag"]),
    ("The Hermit", "隐士", "Ang Ermitanyo", ["Soul-searching", "Introspection", "Guidance"], ["灵魂探索", "内省", "指引"], ["Pagmumuni", "Pagninilay", "Gabay"]),
    ("Wheel of Fortune", "命运之轮", "Gulong ng Kapalaran", ["Change", "Cycle", "Destiny"], ["变化", "循环", "命运"], ["Pagbabago", "Siklo", "Kapalaran"]),
    ("Justice", "正义", "Katarungan", ["Justice", "Fairness", "Truth"], ["正义", "公平", "真相"], ["Katarungan", "Pagkamakatarungan", "Katotohanan"]),
    ("The Hanged Man", "倒吊人", "Ang Binitay", ["Surrender", "New Perspective", "Pause"], ["臣服", "新视角", "暂停"], ["Pagsuko", "Bagong Pananaw", "Pahinga"]),
    ("Death", "死神", "Kamatayan", ["Transformation", "Endings", "Change"], ["转变", "结束", "变化"], ["Pagbabago", "Pagtatapos", "Transpormasyon"]),
    ("Temperance", "节制", "Pagtitimpi", ["Balance", "Moderation", "Patience"], ["平衡", "适度", "耐心"], ["Balanse", "Pagkamoderasyon", "Pasensya"]),
    ("The Devil", "恶魔", "Ang Diyablo", ["Bondage", "Materialism", "Shadow Self"], ["束缚", "物质主义", "阴影自我"], ["Pagkaalipin", "Materyalismo", "Anino ng Sarili"]),
    ("The Tower", "高塔", "Ang Tore", ["Sudden Change", "Upheaval", "Revelation"], ["突然变化", "剧变", "启示"], ["Biglang Pagbabago", "Kaguluhan", "Paghahayag"]),
    ("The Star", "星星", "Ang Bituin", ["Hope", "Inspiration", "Serenity"], ["希望", "灵感", "宁静"], ["Pag-asa", "Inspirasyon", "Katahimikan"]),
    ("The Moon", "月亮", "Ang Buwan", ["Illusion", "Fear", "Subconscious"], ["幻象", "恐惧", "潜意识"], ["Ilusyon", "Takot", "Subconscious"]),
    ("The Sun", "太阳", "Ang Araw", ["Joy", "Success", "Vitality"], ["喜悦", "成功", "活力"], ["Kagalakan", "Tagumpay", "Sigla"]),
    ("Judgement", "审判", "Paghuhukom", ["Rebirth", "Inner Calling", "Absolution"], ["重生", "内在召唤", "宽恕"], ["Muling Pagsilang", "Panloob na Tawag", "Kapatawaran"]),
    ("The World", "世界", "Ang Mundo", ["Completion", "Achievement", "Wholeness"], ["完成", "成就", "完整"], ["Pagkumpleto", "Tagumpay", "Kabuuan"]),
]

all_cards = list(cards_data)
for i, (en, zh, tl, kw_en, kw_zh, kw_tl) in enumerate(remaining, 2):
    card = {
        "id": i, "type": "major", "number": i,
        "nameEn": en, "nameZh": zh, "nameTl": tl,
        "keywordsEn": kw_en, "keywordsZh": kw_zh, "keywordsTl": kw_tl,
        "meaningUprightEn": f"{en} represents transformation and growth. Embrace the energy of this card.",
        "meaningUprightZh": f"{zh}代表转变与成长。拥抱这张卡的能量。",
        "meaningUprightTl": f"Si {tl} ay kumakatawan sa transpormasyon at paglago.",
        "meaningReversedEn": f"Reversed, {en} suggests resistance to change or blocked energy.",
        "meaningReversedZh": f"逆位{zh}暗示抗拒变化或被阻塞的能量。",
        "meaningReversedTl": f"Sa baligtad, si {tl} ay nagpapahiwatig ng paglaban sa pagbabago.",
        "loveEn": f"{en} energy in love brings depth and transformation to relationships.",
        "loveZh": f"{zh}在爱情中的能量为关系带来深度和转变。",
        "loveTl": f"Ang enerhiya ng {tl} sa pag-ibig ay nagdudulot ng lalim at transpormasyon.",
        "careerEn": f"{en} influences career with positive change and new opportunities.",
        "careerZh": f"{zh}影响事业，带来积极变化和新机遇。",
        "careerTl": f"Naiimpluwensyahan ng {tl} ang karera na may positibong pagbabago.",
        "adviceEn": f"Trust the journey with {en}. Transformation leads to growth.",
        "adviceZh": f"相信{zh}的旅程。转变带来成长。",
        "adviceTl": f"Magtiwala sa paglalakbay kasama si {tl}. Ang transpormasyon ay nagdudulot ng paglago."
    }
    all_cards.append(card)

path = "lib/features/tarot/data/json/major_arcana.json"
with open(path, "w", encoding="utf-8") as f:
    json.dump(all_cards, f, ensure_ascii=False, indent=2)

print(f"Generated {len(all_cards)} major arcana cards!")
