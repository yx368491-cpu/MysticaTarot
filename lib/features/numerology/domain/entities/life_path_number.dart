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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LifePathNumber &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          isMasterNumber == other.isMasterNumber &&
          nameEn == other.nameEn &&
          nameZh == other.nameZh &&
          nameTl == other.nameTl &&
          meaningEn == other.meaningEn &&
          meaningZh == other.meaningZh &&
          meaningTl == other.meaningTl &&
          strengthEn == other.strengthEn &&
          strengthZh == other.strengthZh &&
          strengthTl == other.strengthTl &&
          challengeEn == other.challengeEn &&
          challengeZh == other.challengeZh &&
          challengeTl == other.challengeTl;

  @override
  int get hashCode => Object.hash(
        number,
        isMasterNumber,
        nameEn,
        nameZh,
        nameTl,
        meaningEn,
        meaningZh,
        meaningTl,
        strengthEn,
        strengthZh,
        strengthTl,
        challengeEn,
        challengeZh,
        challengeTl,
      );
}
