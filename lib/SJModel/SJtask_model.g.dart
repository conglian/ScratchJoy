// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SJtask_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskRootModel _$TaskRootModelFromJson(Map<String, dynamic> json) =>
    TaskRootModel(
      task: (json['task'] as List<dynamic>)
          .map(
            (e) => (e as List<dynamic>)
                .map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
                .toList(),
          )
          .toList(),
    );

Map<String, dynamic> _$TaskRootModelToJson(TaskRootModel instance) =>
    <String, dynamic>{'task': instance.task};

TaskItem _$TaskItemFromJson(Map<String, dynamic> json) =>
    TaskItem(name: json['name'] as String, num: (json['num'] as num).toInt());

Map<String, dynamic> _$TaskItemToJson(TaskItem instance) => <String, dynamic>{
  'name': instance.name,
  'num': instance.num,
};
