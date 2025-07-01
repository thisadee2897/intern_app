// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRoleModelImpl _$$UserRoleModelImplFromJson(Map<String, dynamic> json) =>
    _$UserRoleModelImpl(
      canCreateCategory: json['can_create_category'] as bool?,
      canCreateProject: json['can_create_project'] as bool?,
      canCreateSprint: json['can_create_sprint'] as bool?,
      canCreateTask: json['can_create_task'] as bool?,
    );

Map<String, dynamic> _$$UserRoleModelImplToJson(_$UserRoleModelImpl instance) =>
    <String, dynamic>{
      'can_create_category': instance.canCreateCategory,
      'can_create_project': instance.canCreateProject,
      'can_create_sprint': instance.canCreateSprint,
      'can_create_task': instance.canCreateTask,
    };
