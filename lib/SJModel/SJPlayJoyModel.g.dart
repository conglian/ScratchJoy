// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SJPlayJoyModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SJPlayJoyModel _$SJPlayJoyModelFromJson(
  Map<String, dynamic> json,
) => SJPlayJoyModel(
  extraBonus: json['extra_bonus'] == null
      ? const GameMode()
      : GameMode.fromJson(json['extra_bonus'] as Map<String, dynamic>),
  goldRush: json['gold_rush'] == null
      ? const GameMode()
      : GameMode.fromJson(json['gold_rush'] as Map<String, dynamic>),
  luckuMoment: json['lucku_moment'] == null
      ? const GameModeLuck()
      : GameModeLuck.fromJson(json['lucku_moment'] as Map<String, dynamic>),
  secretStash: json['secret_stash'] == null
      ? const GameModeSecret()
      : GameModeSecret.fromJson(json['secret_stash'] as Map<String, dynamic>),
  superMultiple: json['super_multiple'] == null
      ? const GameModeSuper()
      : GameModeSuper.fromJson(json['super_multiple'] as Map<String, dynamic>),
  fortuneRush: json['fortune_rush'] == null
      ? const GameMode()
      : GameMode.fromJson(json['fortune_rush'] as Map<String, dynamic>),
  sweetTime: json['sweet_time'] == null
      ? const GameMode()
      : GameMode.fromJson(json['sweet_time'] as Map<String, dynamic>),
  diceNumeric:
      (json['dice_numeric'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  boxInterval: (json['box_interval'] as num?)?.toInt() ?? 0,
  boxReward:
      (json['box_reward'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$SJPlayJoyModelToJson(SJPlayJoyModel instance) =>
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

GameMode _$GameModeFromJson(Map<String, dynamic> json) => GameMode(
  winupNumber: (json['winup_number'] as num?)?.toInt() ?? 0,
  pop:
      (json['pop'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  point: (json['point'] as num?)?.toDouble() ?? 0.0,
  diceProbability: (json['dice_probability'] as num?)?.toDouble() ?? 0.0,
  prize:
      (json['prize'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$GameModeToJson(GameMode instance) => <String, dynamic>{
  'winup_number': instance.winupNumber,
  'pop': instance.pop,
  'point': instance.point,
  'dice_probability': instance.diceProbability,
  'prize': instance.prize,
};

GameModeLuck _$GameModeLuckFromJson(Map<String, dynamic> json) => GameModeLuck(
  winupNumber: (json['winup_number'] as num?)?.toInt() ?? 0,
  pop:
      (json['pop'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  point1x: (json['point_1x'] as num?)?.toDouble() ?? 0.0,
  diceProbability: (json['dice_probability'] as num?)?.toDouble() ?? 0.0,
  prize:
      (json['prize'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$GameModeLuckToJson(GameModeLuck instance) =>
    <String, dynamic>{
      'winup_number': instance.winupNumber,
      'pop': instance.pop,
      'point_1x': instance.point1x,
      'dice_probability': instance.diceProbability,
      'prize': instance.prize,
    };

GameModeSecret _$GameModeSecretFromJson(Map<String, dynamic> json) =>
    GameModeSecret(
      winupNumber: (json['winup_number'] as num?)?.toInt() ?? 0,
      pop:
          (json['pop'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      point1x: (json['point_1x'] as num?)?.toDouble() ?? 0.0,
      point2x: (json['point_2x'] as num?)?.toDouble() ?? 0.0,
      point5x: (json['point_5x'] as num?)?.toDouble() ?? 0.0,
      nullValue: (json['null'] as num?)?.toDouble() ?? 0.0,
      diceProbability: (json['dice_probability'] as num?)?.toDouble() ?? 0.0,
      prize:
          (json['prize'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GameModeSecretToJson(GameModeSecret instance) =>
    <String, dynamic>{
      'winup_number': instance.winupNumber,
      'pop': instance.pop,
      'point_1x': instance.point1x,
      'point_2x': instance.point2x,
      'point_5x': instance.point5x,
      'null': instance.nullValue,
      'dice_probability': instance.diceProbability,
      'prize': instance.prize,
    };

GameModeSuper _$GameModeSuperFromJson(Map<String, dynamic> json) =>
    GameModeSuper(
      winupNumber: (json['winup_number'] as num?)?.toInt() ?? 0,
      pop:
          (json['pop'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      point20x: (json['point_20x'] as num?)?.toDouble() ?? 0.0,
      point30x: (json['point_30x'] as num?)?.toDouble() ?? 0.0,
      point50x: (json['point_50x'] as num?)?.toDouble() ?? 0.0,
      nullValue: (json['null'] as num?)?.toDouble() ?? 0.0,
      diceProbability: (json['dice_probability'] as num?)?.toDouble() ?? 0.0,
      prize:
          (json['prize'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GameModeSuperToJson(GameModeSuper instance) =>
    <String, dynamic>{
      'winup_number': instance.winupNumber,
      'pop': instance.pop,
      'point_20x': instance.point20x,
      'point_30x': instance.point30x,
      'point_50x': instance.point50x,
      'null': instance.nullValue,
      'dice_probability': instance.diceProbability,
      'prize': instance.prize,
    };
