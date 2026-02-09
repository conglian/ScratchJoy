import 'package:json_annotation/json_annotation.dart';

part 'SJFkModel.g.dart';

@JsonSerializable()
class SJFkModel {
  late SJUIModel ui = SJUIModel();
  late SJbehaviorModel behavior = SJbehaviorModel();
  late List<String> device = [];
  SJFkModel();

  // 工厂构造函数，用于反序列化
  factory SJFkModel.fromJson(Map<String, dynamic> json) => _$SJFkModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$SJFkModelToJson(this);
}

@JsonSerializable()
class SJUIModel {
  late int number = 0;
  late int behavior = 0;
  late int device = 0;
  SJUIModel();

  // 工厂构造函数，用于反序列化
  factory SJUIModel.fromJson(Map<String, dynamic> json) => _$SJUIModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$SJUIModelToJson(this);
}

@JsonSerializable()
class SJbehaviorModel {
  late SJad_shortModel ad_short_show = SJad_shortModel();
  late SJad_shortModel ad_short_close = SJad_shortModel();
  late int wrong_deem_ad_less = 0;
  late int wrong_deem_ad_more = 0;
  late int no_install = 0;
  late int ad_daily_show = 60;
  SJbehaviorModel();

  // 工厂构造函数，用于反序列化
  factory SJbehaviorModel.fromJson(Map<String, dynamic> json) => _$SJbehaviorModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$SJbehaviorModelToJson(this);
}

@JsonSerializable()
class SJad_shortModel {
  late int duration = 0;
  late int value = 0;

  SJad_shortModel();

  // 工厂构造函数，用于反序列化
  factory SJad_shortModel.fromJson(Map<String, dynamic> json) => _$SJad_shortModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$SJad_shortModelToJson(this);
}