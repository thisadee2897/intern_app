// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetTaskModelImpl _$$GetTaskModelImplFromJson(Map<String, dynamic> json) =>
    _$GetTaskModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      projectHd: json['project_hd'] == null
          ? null
          : ProjectHDModel.fromJson(json['project_hd'] as Map<String, dynamic>),
      sprint: json['sprint'] == null
          ? null
          : SprintModel.fromJson(json['sprint'] as Map<String, dynamic>),
      priority: json['priority'] == null
          ? null
          : PriorityModel.fromJson(json['priority'] as Map<String, dynamic>),
      taskStatus: json['task_status'] == null
          ? null
          : TaskStatusModel.fromJson(
              json['task_status'] as Map<String, dynamic>),
      typeOfWork: json['type_of_work'] == null
          ? null
          : TypeOfWorkModel.fromJson(
              json['type_of_work'] as Map<String, dynamic>),
      assignedTo: json['assigned_to'] as String?,
      taskStartDate: json['task_start_date'] as String?,
      taskEndDate: json['task_end_date'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: json['created_by'] == null
          ? null
          : UserModel.fromJson(json['created_by'] as Map<String, dynamic>),
      updatedBy: json['updated_by'] == null
          ? null
          : UserModel.fromJson(json['updated_by'] as Map<String, dynamic>),
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$$GetTaskModelImplToJson(_$GetTaskModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'project_hd': instance.projectHd,
      'sprint': instance.sprint,
      'priority': instance.priority,
      'task_status': instance.taskStatus,
      'type_of_work': instance.typeOfWork,
      'assigned_to': instance.assignedTo,
      'task_start_date': instance.taskStartDate,
      'task_end_date': instance.taskEndDate,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'active': instance.active,
    };
