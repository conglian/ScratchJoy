import 'package:json_annotation/json_annotation.dart';

part 'SJPlayJoyModel.g.dart';

@JsonSerializable()
class SJPlayJoyModel {

  @JsonKey(name: 'extra_bonus')
  final GameMode extraBonus;

  @JsonKey(name: 'gold_rush')
  final GameMode goldRush;

  @JsonKey(name: 'lucku_moment')
  final GameModeLuck luckuMoment;

  @JsonKey(name: 'secret_stash')
  final GameModeSecret secretStash;

  @JsonKey(name: 'super_multiple')
  final GameModeSuper superMultiple;

  @JsonKey(name: 'fortune_rush')
  final GameMode fortuneRush;

  @JsonKey(name: 'sweet_time')
  final GameMode sweetTime;

  @JsonKey(name: 'dice_numeric')
  final List<int> diceNumeric;

  @JsonKey(name: 'box_interval')
  final int boxInterval;

  @JsonKey(name: 'box_reward')
  final List<int> boxReward;

  const SJPlayJoyModel({
    this.extraBonus = const GameMode(),
    this.goldRush = const GameMode(),
    this.luckuMoment = const GameModeLuck(),
    this.secretStash = const GameModeSecret(),
    this.superMultiple = const GameModeSuper(),
    this.fortuneRush = const GameMode(),
    this.sweetTime = const GameMode(),
    this.diceNumeric = const [],
    this.boxInterval = 0,
    this.boxReward = const [],
  });

  factory SJPlayJoyModel.fromJson(Map<String, dynamic> json) =>
      _$SJPlayJoyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SJPlayJoyModelToJson(this);
}

/// 🧩 通用模式
@JsonSerializable()
class GameMode {
  @JsonKey(name: 'winup_number')
  final int winupNumber;

  final List<int> pop;
  final double point;

  @JsonKey(name: 'dice_probability')
  final double diceProbability;

  final List<int> prize;

  const GameMode({
    this.winupNumber = 0,
    this.pop = const [],
    this.point = 0.0,
    this.diceProbability = 0.0,
    this.prize = const [],
  });

  factory GameMode.fromJson(Map<String, dynamic> json) =>
      _$GameModeFromJson(json);
  Map<String, dynamic> toJson() => _$GameModeToJson(this);
}

/// 🍀 lucku_moment
@JsonSerializable()
class GameModeLuck {
  @JsonKey(name: 'winup_number')
  final int winupNumber;

  final List<int> pop;

  @JsonKey(name: 'point_1x')
  final double point1x;

  @JsonKey(name: 'dice_probability')
  final double diceProbability;

  final List<int> prize;

  const GameModeLuck({
    this.winupNumber = 0,
    this.pop = const [],
    this.point1x = 0.0,
    this.diceProbability = 0.0,
    this.prize = const [],
  });

  factory GameModeLuck.fromJson(Map<String, dynamic> json) =>
      _$GameModeLuckFromJson(json);
  Map<String, dynamic> toJson() => _$GameModeLuckToJson(this);
}

/// 🗝️ secret_stash
@JsonSerializable()
class GameModeSecret {
  @JsonKey(name: 'winup_number')
  final int winupNumber;

  final List<int> pop;

  @JsonKey(name: 'point_1x')
  final double point1x;

  @JsonKey(name: 'point_2x')
  final double point2x;

  @JsonKey(name: 'point_5x')
  final double point5x;

  @JsonKey(name: 'null')
  final double nullValue;

  @JsonKey(name: 'dice_probability')
  final double diceProbability;

  final List<int> prize;

  const GameModeSecret({
    this.winupNumber = 0,
    this.pop = const [],
    this.point1x = 0.0,
    this.point2x = 0.0,
    this.point5x = 0.0,
    this.nullValue = 0.0,
    this.diceProbability = 0.0,
    this.prize = const [],
  });

  factory GameModeSecret.fromJson(Map<String, dynamic> json) =>
      _$GameModeSecretFromJson(json);
  Map<String, dynamic> toJson() => _$GameModeSecretToJson(this);
}

/// 💥 super_multiple
@JsonSerializable()
class GameModeSuper {
  @JsonKey(name: 'winup_number')
  final int winupNumber;

  final List<int> pop;

  @JsonKey(name: 'point_20x')
  final double point20x;

  @JsonKey(name: 'point_30x')
  final double point30x;

  @JsonKey(name: 'point_50x')
  final double point50x;

  @JsonKey(name: 'null')
  final double nullValue;

  @JsonKey(name: 'dice_probability')
  final double diceProbability;

  final List<int> prize;

  const GameModeSuper({
    this.winupNumber = 0,
    this.pop = const [],
    this.point20x = 0.0,
    this.point30x = 0.0,
    this.point50x = 0.0,
    this.nullValue = 0.0,
    this.diceProbability = 0.0,
    this.prize = const [],
  });

  factory GameModeSuper.fromJson(Map<String, dynamic> json) =>
      _$GameModeSuperFromJson(json);
  Map<String, dynamic> toJson() => _$GameModeSuperToJson(this);
}
