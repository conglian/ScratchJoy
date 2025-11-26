// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SJTXModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SJTXModel _$SJTXModelFromJson(Map<String, dynamic> json) => SJTXModel()
  ..tx_info = (json['tx_info'] as List<dynamic>)
      .map((e) => SJTXListModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$SJTXModelToJson(SJTXModel instance) => <String, dynamic>{
  'tx_info': instance.tx_info,
};

SJTXListModel _$SJTXListModelFromJson(Map<String, dynamic> json) =>
    SJTXListModel()
      ..tx_list = (json['tx_list'] as List<dynamic>)
          .map((e) => SJTXListDetailModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SJTXListModelToJson(SJTXListModel instance) =>
    <String, dynamic>{'tx_list': instance.tx_list};

SJTXListDetailModel _$SJTXListDetailModelFromJson(Map<String, dynamic> json) =>
    SJTXListDetailModel()
      ..number = (json['number'] as num).toInt()
      ..status = (json['status'] as num).toInt();

Map<String, dynamic> _$SJTXListDetailModelToJson(
  SJTXListDetailModel instance,
) => <String, dynamic>{'number': instance.number, 'status': instance.status};
