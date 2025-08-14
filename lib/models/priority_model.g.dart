// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priority_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriorityModelImpl _$$PriorityModelImplFromJson(Map<String, dynamic> json) =>
    _$PriorityModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      color: json['color'] as String?,
      active: json['active'] as bool? ?? true,
      count: json['count'] as num? ?? 0,
    );

Map<String, dynamic> _$$PriorityModelImplToJson(_$PriorityModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'active': instance.active,
      'count': instance.count,
    };
