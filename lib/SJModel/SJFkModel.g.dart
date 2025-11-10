// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SJFkModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SJFkModel _$SJFkModelFromJson(Map<String, dynamic> json) => SJFkModel()
  ..ui = SJUIModel.fromJson(json['ui'] as Map<String, dynamic>)
  ..behavior = SJbehaviorModel.fromJson(
    json['behavior'] as Map<String, dynamic>,
  )
  ..device = (json['device'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$SJFkModelToJson(SJFkModel instance) => <String, dynamic>{
  'ui': instance.ui,
  'behavior': instance.behavior,
  'device': instance.device,
};

SJUIModel _$SJUIModelFromJson(Map<String, dynamic> json) => SJUIModel()
  ..number = (json['number'] as num).toInt()
  ..behavior = (json['behavior'] as num).toInt()
  ..device = (json['device'] as num).toInt();

Map<String, dynamic> _$SJUIModelToJson(SJUIModel instance) => <String, dynamic>{
  'number': instance.number,
  'behavior': instance.behavior,
  'device': instance.device,
};

SJbehaviorModel _$SJbehaviorModelFromJson(Map<String, dynamic> json) =>
    SJbehaviorModel()
      ..ad_short_show = SJad_shortModel.fromJson(
        json['ad_short_show'] as Map<String, dynamic>,
      )
      ..ad_short_close = SJad_shortModel.fromJson(
        json['ad_short_close'] as Map<String, dynamic>,
      )
      ..wrong_deem_ad_less = (json['wrong_deem_ad_less'] as num).toInt()
      ..wrong_deem_ad_more = (json['wrong_deem_ad_more'] as num).toInt()
      ..no_install = (json['no_install'] as num).toInt()
      ..ad_daily_show = (json['ad_daily_show'] as num).toInt();

Map<String, dynamic> _$SJbehaviorModelToJson(SJbehaviorModel instance) =>
    <String, dynamic>{
      'ad_short_show': instance.ad_short_show,
      'ad_short_close': instance.ad_short_close,
      'wrong_deem_ad_less': instance.wrong_deem_ad_less,
      'wrong_deem_ad_more': instance.wrong_deem_ad_more,
      'no_install': instance.no_install,
      'ad_daily_show': instance.ad_daily_show,
    };

SJad_shortModel _$SJad_shortModelFromJson(Map<String, dynamic> json) =>
    SJad_shortModel()
      ..duration = (json['duration'] as num).toInt()
      ..value = (json['value'] as num).toInt();

Map<String, dynamic> _$SJad_shortModelToJson(SJad_shortModel instance) =>
    <String, dynamic>{'duration': instance.duration, 'value': instance.value};
