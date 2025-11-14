// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SJint_ad_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RootModel _$RootModelFromJson(Map<String, dynamic> json) => RootModel(
  intAd: (json['int_ad'] as List<dynamic>)
      .map((e) => IntAdModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RootModelToJson(RootModel instance) => <String, dynamic>{
  'int_ad': instance.intAd,
};

IntAdModel _$IntAdModelFromJson(Map<String, dynamic> json) => IntAdModel(
  firstNumber: (json['first_number'] as num).toInt(),
  point: (json['point'] as num).toDouble(),
  endNumber: (json['end_number'] as num).toInt(),
);

Map<String, dynamic> _$IntAdModelToJson(IntAdModel instance) =>
    <String, dynamic>{
      'first_number': instance.firstNumber,
      'point': instance.point,
      'end_number': instance.endNumber,
    };
