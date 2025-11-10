// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SJAdModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SJAdModel _$SJAdModelFromJson(Map<String, dynamic> json) => SJAdModel()
  ..xrpaxjqa = (json['xrpaxjqa'] as num).toInt()
  ..jotsibno = (json['jotsibno'] as num).toInt()
  ..scxji_switch = json['scxji_switch'] as bool
  ..scxji_int = (json['scxji_int'] as List<dynamic>)
      .map((e) => SJAdModellist.fromJson(e as Map<String, dynamic>))
      .toList()
  ..scxji_rv = (json['scxji_rv'] as List<dynamic>)
      .map((e) => SJAdModellist.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$SJAdModelToJson(SJAdModel instance) => <String, dynamic>{
  'xrpaxjqa': instance.xrpaxjqa,
  'jotsibno': instance.jotsibno,
  'scxji_switch': instance.scxji_switch,
  'scxji_int': instance.scxji_int,
  'scxji_rv': instance.scxji_rv,
};

SJAdModellist _$SJAdModellistFromJson(Map<String, dynamic> json) =>
    SJAdModellist()
      ..hnmkuhdz = json['hnmkuhdz'] as String
      ..feytgpub = json['feytgpub'] as String
      ..ggtcworw = json['ggtcworw'] as String
      ..yemylnvt = (json['yemylnvt'] as num).toInt()
      ..ecpm = (json['ecpm'] as num?)?.toDouble();

Map<String, dynamic> _$SJAdModellistToJson(SJAdModellist instance) =>
    <String, dynamic>{
      'hnmkuhdz': instance.hnmkuhdz,
      'feytgpub': instance.feytgpub,
      'ggtcworw': instance.ggtcworw,
      'yemylnvt': instance.yemylnvt,
      'ecpm': instance.ecpm,
    };
