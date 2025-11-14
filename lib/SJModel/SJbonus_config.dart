import 'package:json_annotation/json_annotation.dart';

part 'SJbonus_config.g.dart';

@JsonSerializable()
class BonusConfig {
  @JsonKey(name: 'extra_bonus')
  final BonusItem extraBonus;

  @JsonKey(name: 'gold_rush')
  final BonusItem goldRush;

  @JsonKey(name: 'lucku_moment')
  final BonusItem luckuMoment;

  @JsonKey(name: 'secret_stash')
  final BonusItem secretStash;

  @JsonKey(name: 'super_multiple')
  final BonusItem superMultiple;

  @JsonKey(name: 'fortune_rush')
  final BonusItem fortuneRush;

  @JsonKey(name: 'sweet_time')
  final BonusItem sweetTime;

  @JsonKey(name: 'dice_numeric')
  final List<int> diceNumeric;

  @JsonKey(name: 'box_interval')
  final int boxInterval;

  @JsonKey(name: 'box_reward')
  final List<int> boxReward;

  BonusConfig({
    required this.extraBonus,
    required this.goldRush,
    required this.luckuMoment,
    required this.secretStash,
    required this.superMultiple,
    required this.fortuneRush,
    required this.sweetTime,
    required this.diceNumeric,
    required this.boxInterval,
    required this.boxReward,
  });

  factory BonusConfig.fromJson(Map<String, dynamic> json) =>
      _$BonusConfigFromJson(json);

  Map<String, dynamic> toJson() => _$BonusConfigToJson(this);
}

@JsonSerializable()
class BonusItem {
  @JsonKey(name: 'winup_number')
  final int winupNumber;

  /// pop: [44, 47]
  final List<int>? pop;

  /// 可为 point, point_1x, point_2x... 等
  @JsonKey(name: 'point')
  final double? point;

  @JsonKey(name: 'point_1x')
  final double? point1x;

  @JsonKey(name: 'point_2x')
  final double? point2x;

  @JsonKey(name: 'point_5x')
  final double? point5x;

  @JsonKey(name: 'point_20x')
  final double? point20x;

  @JsonKey(name: 'point_30x')
  final double? point30x;

  @JsonKey(name: 'point_50x')
  final double? point50x;

  /// null 字段也需要保留
  @JsonKey(name: 'null')
  final double? nullValue;

  @JsonKey(name: 'dice_probability')
  final double? diceProbability;

  /// prize: [40, 50]
  final List<int>? prize;

  BonusItem({
    required this.winupNumber,
    this.pop,
    this.point,
    this.point1x,
    this.point2x,
    this.point5x,
    this.point20x,
    this.point30x,
    this.point50x,
    this.nullValue,
    this.diceProbability,
    this.prize,
  });

  factory BonusItem.fromJson(Map<String, dynamic> json) =>
      _$BonusItemFromJson(json);

  Map<String, dynamic> toJson() => _$BonusItemToJson(this);
}
