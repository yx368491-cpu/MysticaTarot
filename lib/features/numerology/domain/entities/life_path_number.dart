/// Life path number entity
class LifePathNumber {
  final int number;
  final bool isMasterNumber;
  final String nameEn;
  final String nameZh;
  final String nameTl;
  final String meaningEn;
  final String meaningZh;
  final String meaningTl;
  final String strengthEn;
  final String strengthZh;
  final String strengthTl;
  final String challengeEn;
  final String challengeZh;
  final String challengeTl;

  const LifePathNumber({
    required this.number,
    this.isMasterNumber = false,
    required this.nameEn,
    required this.nameZh,
    required this.nameTl,
    required this.meaningEn,
    required this.meaningZh,
    required this.meaningTl,
    required this.strengthEn,
    required this.strengthZh,
    required this.strengthTl,
    required this.challengeEn,
    required this.challengeZh,
    required this.challengeTl,
  });

  String localizedName(String locale) {
    switch (locale) {
      case 'zh': return nameZh;
      case 'tl': return nameTl;
      default: return nameEn;
    }
  }

  String localizedMeaning(String locale) {
    switch (locale) {
      case 'zh': return meaningZh;
      case 'tl': return meaningTl;
      default: return meaningEn;
    }
  }

  String localizedStrength(String locale) {
    switch (locale) {
      case 'zh': return strengthZh;
      case 'tl': return strengthTl;
      default: return strengthEn;
    }
  }

  String localizedChallenge(String locale) {
    switch (locale) {
      case 'zh': return challengeZh;
      case 'tl': return challengeTl;
      default: return challengeEn;
    }
  }
}
