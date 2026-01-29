// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SJprobability_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProbabilityConfig _$ProbabilityConfigFromJson(Map<String, dynamic> json) =>
    ProbabilityConfig(
      probabilityopen: (json['probability_open'] as num).toDouble(),
      probability08: (json['probability_0.8'] as num).toDouble(),
      probability099: (json['probability_0.99'] as num).toDouble(),
      probability1: (json['probability_1'] as num).toDouble(),
    );

Map<String, dynamic> _$ProbabilityConfigToJson(ProbabilityConfig instance) =>
    <String, dynamic>{
      'probability_open': instance.probabilityopen,
      'probability_0.8': instance.probability08,
      'probability_0.99': instance.probability099,
      'probability_1': instance.probability1,
    };
