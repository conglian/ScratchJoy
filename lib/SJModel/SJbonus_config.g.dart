// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SJbonus_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BonusConfig _$BonusConfigFromJson(Map<String, dynamic> json) => BonusConfig(
  extraBonus: BonusItem.fromJson(json['extra_bonus'] as Map<String, dynamic>),
  goldRush: BonusItem.fromJson(json['gold_rush'] as Map<String, dynamic>),
  luckuMoment: BonusItem.fromJson(json['lucku_moment'] as Map<String, dynamic>),
  secretStash: BonusItem.fromJson(json['secret_stash'] as Map<String, dynamic>),
  superMultiple: BonusItem.fromJson(
    json['super_multiple'] as Map<String, dynamic>,
  ),
  fortuneRush: BonusItem.fromJson(json['fortune_rush'] as Map<String, dynamic>),
  sweetTime: BonusItem.fromJson(json['sweet_time'] as Map<String, dynamic>),
  diceNumeric: (json['dice_numeric'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  boxInterval: (json['box_interval'] as num).toInt(),
  boxReward: (json['box_reward'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$BonusConfigToJson(BonusConfig instance) =>
    <String, dynamic>{
      'extra_bonus': instance.extraBonus,
      'gold_rush': instance.goldRush,
      'lucku_moment': instance.luckuMoment,
      'secret_stash': instance.secretStash,
      'super_multiple': instance.superMultiple,
      'fortune_rush': instance.fortuneRush,
      'sweet_time': instance.sweetTime,
      'dice_numeric': instance.diceNumeric,
      'box_interval': instance.boxInterval,
      'box_reward': instance.boxReward,
    };

BonusItem _$BonusItemFromJson(Map<String, dynamic> json) => BonusItem(
  winupNumber: (json['winup_number'] as num).toInt(),
  pop: (json['pop'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
  point: (json['point'] as num?)?.toDouble(),
  point1x: (json['point_1x'] as num?)?.toDouble(),
  point2x: (json['point_2x'] as num?)?.toDouble(),
  point5x: (json['point_5x'] as num?)?.toDouble(),
  point20x: (json['point_20x'] as num?)?.toDouble(),
  point30x: (json['point_30x'] as num?)?.toDouble(),
  point50x: (json['point_50x'] as num?)?.toDouble(),
  nullValue: (json['null'] as num?)?.toDouble(),
  diceProbability: (json['dice_probability'] as num?)?.toDouble(),
  prize: (json['prize'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$BonusItemToJson(BonusItem instance) => <String, dynamic>{
  'winup_number': instance.winupNumber,
  'pop': instance.pop,
  'point': instance.point,
  'point_1x': instance.point1x,
  'point_2x': instance.point2x,
  'point_5x': instance.point5x,
  'point_20x': instance.point20x,
  'point_30x': instance.point30x,
  'point_50x': instance.point50x,
  'null': instance.nullValue,
  'dice_probability': instance.diceProbability,
  'prize': instance.prize,
};
