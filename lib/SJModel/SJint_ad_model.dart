import 'package:json_annotation/json_annotation.dart';

part 'SJint_ad_model.g.dart';

@JsonSerializable()
class RootModel {
  @JsonKey(name: 'int_ad')
  final List<IntAdModel> intAd;

  RootModel({required this.intAd});

  factory RootModel.fromJson(Map<String, dynamic> json) =>
      _$RootModelFromJson(json);

  Map<String, dynamic> toJson() => _$RootModelToJson(this);
}

@JsonSerializable()
class IntAdModel {
  @JsonKey(name: 'first_number')
  final int firstNumber;

  final double point;

  @JsonKey(name: 'end_number')
  final int endNumber;

  IntAdModel({
    required this.firstNumber,
    required this.point,
    required this.endNumber,
  });

  factory IntAdModel.fromJson(Map<String, dynamic> json) =>
      _$IntAdModelFromJson(json);

  Map<String, dynamic> toJson() => _$IntAdModelToJson(this);
}
