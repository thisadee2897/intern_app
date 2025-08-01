// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sprint_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SprintModelImpl _$$SprintModelImplFromJson(Map<String, dynamic> json) =>
    _$SprintModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      duration: json['duration'] as num?,
      satartDate: json['satart_date'] as String?,
      endDate: json['end_date'] as String?,
      goal: json['goal'] as String?,
      completed: json['completed'] as bool?,
      projectHd: json['project_hd'] == null
          ? null
          : ProjectHDModel.fromJson(json['project_hd'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: json['created_by'] == null
          ? null
          : UserModel.fromJson(json['created_by'] as Map<String, dynamic>),
      updatedBy: json['updated_by'] == null
          ? null
          : UserModel.fromJson(json['updated_by'] as Map<String, dynamic>),
      active: json['active'] as bool?,
      startting: json['startting'] as bool?,
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SprintModelImplToJson(_$SprintModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'duration': instance.duration,
      'satart_date': instance.satartDate,
      'end_date': instance.endDate,
      'goal': instance.goal,
      'completed': instance.completed,
      'project_hd': instance.projectHd,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'active': instance.active,
      'startting': instance.startting,
      'tasks': instance.tasks,
    };
