// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SJbonus_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BonusConfig _$BonusConfigFromJson(Map<String, dynamic> json) => BonusConfig(
  winpop: (json['win_pop'] as List<dynamic>)
      .map((e) => WinPopModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  extraBonus: BonusItem.fromJson(json['extra_bonus'] as Map<String, dynamic>),
  goldRush: BonusItem.fromJson(json['gold_rush'] as Map<String, dynamic>),
  secretStash: BonusItem.fromJson(json['secret_stash'] as Map<String, dynamic>),
  superMultiple: BonusItem.fromJson(
    json['super_multiple'] as Map<String, dynamic>,
  ),
  fortuneRush: BonusItem.fromJson(json['fortune_rush'] as Map<String, dynamic>),
  sweetTime: BonusItem.fromJson(json['sweet_time'] as Map<String, dynamic>),
  luckyMoment: BonusItem.fromJson(json['lucky_moment'] as Map<String, dynamic>),
  diceNumeric: (json['dice_numeric'] as List<dynamic>)
      .map((e) => DiceNumericItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  boxReward: (json['box_reward'] as List<dynamic>)
      .map((e) => PrizeRange.fromJson(e as Map<String, dynamic>))
      .toList(),
  boxInterval: (json['box_interval'] as num).toInt(),
);

Map<String, dynamic> _$BonusConfigToJson(BonusConfig instance) =>
    <String, dynamic>{
      'win_pop': instance.winpop.map((e) => e.toJson()).toList(),
      'extra_bonus': instance.extraBonus.toJson(),
      'gold_rush': instance.goldRush.toJson(),
      'secret_stash': instance.secretStash.toJson(),
      'super_multiple': instance.superMultiple.toJson(),
      'fortune_rush': instance.fortuneRush.toJson(),
      'sweet_time': instance.sweetTime.toJson(),
      'lucky_moment': instance.luckyMoment.toJson(),
      'dice_numeric': instance.diceNumeric.map((e) => e.toJson()).toList(),
      'box_reward': instance.boxReward.map((e) => e.toJson()).toList(),
      'box_interval': instance.boxInterval,
    };

WinPopModel _$WinPopModelFromJson(Map<String, dynamic> json) => WinPopModel(
  firstnumber: (json['first_number'] as num?)?.toInt() ?? 0,
  superwin:
      (json['super_win'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  endnumber: (json['end_number'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$WinPopModelToJson(WinPopModel instance) =>
    <String, dynamic>{
      'first_number': instance.firstnumber,
      'super_win': instance.superwin,
      'end_number': instance.endnumber,
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
      ?.map((e) => PrizeRange.fromJson(e as Map<String, dynamic>))
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
  'prize': instance.prize?.map((e) => e.toJson()).toList(),
};

PrizeRange _$PrizeRangeFromJson(Map<String, dynamic> json) => PrizeRange(
  firstNumber: (json['first_number'] as num).toInt(),
  prize: (json['prize'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  endNumber: (json['end_number'] as num).toInt(),
);

Map<String, dynamic> _$PrizeRangeToJson(PrizeRange instance) =>
    <String, dynamic>{
      'first_number': instance.firstNumber,
      'prize': instance.prize,
      'end_number': instance.endNumber,
    };

DiceNumericItem _$DiceNumericItemFromJson(Map<String, dynamic> json) =>
    DiceNumericItem(
      firstNumber: (json['first_number'] as num).toInt(),
      values: (json['values'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      endNumber: (json['end_number'] as num).toInt(),
    );

Map<String, dynamic> _$DiceNumericItemToJson(DiceNumericItem instance) =>
    <String, dynamic>{
      'first_number': instance.firstNumber,
      'values': instance.values,
      'end_number': instance.endNumber,
    };
