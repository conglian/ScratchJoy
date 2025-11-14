import 'package:json_annotation/json_annotation.dart';

part 'SJprobability_config.g.dart';

@JsonSerializable()
class ProbabilityConfig {
  @JsonKey(name: 'probability_0.8')
  final double probability08;

  @JsonKey(name: 'probability_0.99')
  final double probability099;

  @JsonKey(name: 'probability_1')
  final double probability1;

  ProbabilityConfig({
    required this.probability08,
    required this.probability099,
    required this.probability1,
  });

  factory ProbabilityConfig.fromJson(Map<String, dynamic> json) =>
      _$ProbabilityConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ProbabilityConfigToJson(this);
}
