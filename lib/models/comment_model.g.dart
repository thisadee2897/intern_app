// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentModelImpl _$$CommentModelImplFromJson(Map<String, dynamic> json) =>
    _$CommentModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      project: json['project'] == null
          ? null
          : ProjectHDModel.fromJson(json['project'] as Map<String, dynamic>),
      typeOfWork: json['type_of_work'] == null
          ? null
          : TypeOfWorkModel.fromJson(
              json['type_of_work'] as Map<String, dynamic>),
      task: json['task'] == null
          ? null
          : TaskModel.fromJson(json['task'] as Map<String, dynamic>),
      commentJson: (json['comment_json'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      createdAt: json['created_at'] as String?,
      createBy: json['create_by'] == null
          ? null
          : UserModel.fromJson(json['create_by'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CommentModelImplToJson(_$CommentModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'project': instance.project,
      'type_of_work': instance.typeOfWork,
      'task': instance.task,
      'comment_json': instance.commentJson,
      'created_at': instance.createdAt,
      'create_by': instance.createBy,
    };
