// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskStatusModelImpl _$$TaskStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TaskStatusModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      color: json['color'] as String?,
      active: json['active'] as bool?,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TaskStatusModelImplToJson(
        _$TaskStatusModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'active': instance.active,
      'count': instance.count,
    };
