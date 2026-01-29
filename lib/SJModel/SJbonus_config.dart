import 'package:json_annotation/json_annotation.dart';

part 'SJbonus_config.g.dart';

@JsonSerializable(explicitToJson: true)
class BonusConfig {
  @JsonKey(name: 'win_pop')
  final List<WinPopModel> winpop;

  @JsonKey(name: 'extra_bonus')
  final BonusItem extraBonus;

  @JsonKey(name: 'gold_rush')
  final BonusItem goldRush;

  @JsonKey(name: 'secret_stash')
  final BonusItem secretStash;

  @JsonKey(name: 'super_multiple')
  final BonusItem superMultiple;

  @JsonKey(name: 'fortune_rush')
  final BonusItem fortuneRush;

  @JsonKey(name: 'sweet_time')
  final BonusItem sweetTime;

  @JsonKey(name: 'lucky_moment')
  final BonusItem luckyMoment; // 修正原来拼写错误 lucku_moment

  @JsonKey(name: 'dice_numeric')
  final List<DiceNumericItem> diceNumeric;

  @JsonKey(name: 'box_reward')
  final List<PrizeRange> boxReward;

  @JsonKey(name: 'box_interval')
  final int boxInterval;

  BonusConfig({
    required this.winpop,
    required this.extraBonus,
    required this.goldRush,
    required this.secretStash,
    required this.superMultiple,
    required this.fortuneRush,
    required this.sweetTime,
    required this.luckyMoment,
    required this.diceNumeric,
    required this.boxReward,
    required this.boxInterval,
  });

  factory BonusConfig.fromJson(Map<String, dynamic> json) =>
      _$BonusConfigFromJson(json);

  Map<String, dynamic> toJson() => _$BonusConfigToJson(this);
}
/// 🧩 通用模式
@JsonSerializable()
class WinPopModel {
  @JsonKey(name: 'first_number')
  final int firstnumber;
  @JsonKey(name: 'super_win')
  final List<int> superwin;
  @JsonKey(name: 'end_number')
  final int endnumber;


  const WinPopModel({
    this.firstnumber = 0,
    this.superwin = const [],
    this.endnumber = 0,
  });

  factory WinPopModel.fromJson(Map<String, dynamic> json) =>
      _$WinPopModelFromJson(json);
  Map<String, dynamic> toJson() => _$WinPopModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BonusItem {
  @JsonKey(name: 'winup_number')
  final int winupNumber;

  final List<int>? pop;

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

  @JsonKey(name: 'null')
  final double? nullValue;

  @JsonKey(name: 'dice_probability')
  final double? diceProbability;

  /// 这里 prize 是一个区间数组，不是 List<int>
  final List<PrizeRange>? prize;

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

@JsonSerializable()
class PrizeRange {
  @JsonKey(name: 'first_number')
  final int firstNumber;

  final List<double>? prize;

  @JsonKey(name: 'end_number')
  final int endNumber;

  PrizeRange({
    required this.firstNumber,
    required this.prize,
    required this.endNumber,
  });

  factory PrizeRange.fromJson(Map<String, dynamic> json) =>
      _$PrizeRangeFromJson(json);

  Map<String, dynamic> toJson() => _$PrizeRangeToJson(this);
}

@JsonSerializable()
class DiceNumericItem {
  @JsonKey(name: 'first_number')
  final int firstNumber;

  final List<int> values;

  @JsonKey(name: 'end_number')
  final int endNumber;

  DiceNumericItem({
    required this.firstNumber,
    required this.values,
    required this.endNumber,
  });

  factory DiceNumericItem.fromJson(Map<String, dynamic> json) =>
      _$DiceNumericItemFromJson(json);

  Map<String, dynamic> toJson() => _$DiceNumericItemToJson(this);
}
