import 'package:flutter/foundation.dart';

/// Position within a spread layout
class SpreadPosition {
  final int index;
  final String nameEn;
  final String nameZh;
  final String nameTl;
  final String descriptionEn;
  final String descriptionZh;
  final String descriptionTl;

  const SpreadPosition({
    required this.index,
    required this.nameEn,
    required this.nameZh,
    required this.nameTl,
    this.descriptionEn = '',
    this.descriptionZh = '',
    this.descriptionTl = '',
  });

  String localizedName(String locale) {
    switch (locale) {
      case 'zh': return nameZh;
      case 'tl': return nameTl;
      default: return nameEn;
    }
  }

  String localizedDescription(String locale) {
    switch (locale) {
      case 'zh': return descriptionZh;
      case 'tl': return descriptionTl;
      default: return descriptionEn;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpreadPosition &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          nameEn == other.nameEn &&
          nameZh == other.nameZh &&
          nameTl == other.nameTl &&
          descriptionEn == other.descriptionEn &&
          descriptionZh == other.descriptionZh &&
          descriptionTl == other.descriptionTl;

  @override
  int get hashCode => Object.hash(
        index,
        nameEn,
        nameZh,
        nameTl,
        descriptionEn,
        descriptionZh,
        descriptionTl,
      );
}

/// Spread (牌阵) definition
class Spread {
  final String id;
  final String nameEn;
  final String nameZh;
  final String nameTl;
  final int cardCount;
  final String descriptionEn;
  final String descriptionZh;
  final String descriptionTl;
  final List<SpreadPosition> positions;

  const Spread({
    required this.id,
    required this.nameEn,
    required this.nameZh,
    required this.nameTl,
    required this.cardCount,
    required this.descriptionEn,
    required this.descriptionZh,
    required this.descriptionTl,
    required this.positions,
  });

  String localizedName(String locale) {
    switch (locale) {
      case 'zh': return nameZh;
      case 'tl': return nameTl;
      default: return nameEn;
    }
  }

  String localizedDescription(String locale) {
    switch (locale) {
      case 'zh': return descriptionZh;
      case 'tl': return descriptionTl;
      default: return descriptionEn;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Spread &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nameEn == other.nameEn &&
          nameZh == other.nameZh &&
          nameTl == other.nameTl &&
          cardCount == other.cardCount &&
          descriptionEn == other.descriptionEn &&
          descriptionZh == other.descriptionZh &&
          descriptionTl == other.descriptionTl &&
          listEquals(positions, other.positions);

  @override
  int get hashCode => Object.hash(
        id,
        nameEn,
        nameZh,
        nameTl,
        cardCount,
        descriptionEn,
        descriptionZh,
        descriptionTl,
        Object.hashAll(positions),
      );
}
