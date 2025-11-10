import 'package:json_annotation/json_annotation.dart';

part 'SJAdModel.g.dart';

@JsonSerializable()
class SJAdModel {
  late int xrpaxjqa = 0;
  late int jotsibno = 0;
  late bool scxji_switch = false;
  late List<SJAdModellist> scxji_int = [];
  late List<SJAdModellist> scxji_rv = [];
  SJAdModel();

  // 工厂构造函数，用于反序列化
  factory SJAdModel.fromJson(Map<String, dynamic> json) => _$SJAdModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$SJAdModelToJson(this);
}

@JsonSerializable()
class SJAdModellist {
  // id
  late String hnmkuhdz = "";
  // type
  late String feytgpub = "";
  // ad_type
  late String ggtcworw = "";
  //
  late int yemylnvt = 0;
  //
  late double? ecpm = 0;

  SJAdModellist();

  // 工厂构造函数，用于反序列化
  factory SJAdModellist.fromJson(Map<String, dynamic> json) => _$SJAdModellistFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$SJAdModellistToJson(this);
}