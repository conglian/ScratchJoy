import 'package:json_annotation/json_annotation.dart';

part 'SJtask_model.g.dart';

@JsonSerializable()
class TaskRootModel {
  final List<List<TaskItem>> task;

  TaskRootModel({required this.task});

  factory TaskRootModel.fromJson(Map<String, dynamic> json) =>
      _$TaskRootModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskRootModelToJson(this);
}

@JsonSerializable()
class TaskItem {
  final String name;
  final int num;

  TaskItem({
    required this.name,
    required this.num,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  Map<String, dynamic> toJson() => _$TaskItemToJson(this);
}
