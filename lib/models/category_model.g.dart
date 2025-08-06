// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      active: json['active'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      createdBy: json['created_by'] == null
          ? null
          : UserModel.fromJson(json['created_by'] as Map<String, dynamic>),
      updatedBy: json['updated_by'] == null
          ? null
          : UserModel.fromJson(json['updated_by'] as Map<String, dynamic>),
      workspaceId: json['workspace_id'] as String?,
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => ProjectHDModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'active': instance.active,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'workspace_id': instance.workspaceId,
      'projects': instance.projects,
    };
