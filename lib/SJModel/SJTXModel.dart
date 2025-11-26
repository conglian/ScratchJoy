import 'package:json_annotation/json_annotation.dart';

part 'SJTXModel.g.dart';

@JsonSerializable()
class SJTXModel {
  late List<SJTXListModel> tx_info = [];
  SJTXModel();

  // 工厂构造函数，用于反序列化
  factory SJTXModel.fromJson(Map<String, dynamic> json) => _$SJTXModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$SJTXModelToJson(this);
}

@JsonSerializable()
class SJTXListModel {
  late List<SJTXListDetailModel> tx_list = [];
  SJTXListModel();

  // 工厂构造函数，用于反序列化
  factory SJTXListModel.fromJson(Map<String, dynamic> json) => _$SJTXListModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$SJTXListModelToJson(this);
}

@JsonSerializable()
class SJTXListDetailModel {
  late int number = 0;
  late int status = 0;
  SJTXListDetailModel();

  // 工厂构造函数，用于反序列化
  factory SJTXListDetailModel.fromJson(Map<String, dynamic> json) => _$SJTXListDetailModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$SJTXListDetailModelToJson(this);
}