// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_workload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamWorkloadModelImpl _$$TeamWorkloadModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TeamWorkloadModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      color: json['color'] as String?,
      active: json['active'] as bool? ?? true,
      count: json['count'] as num? ?? 0,
    );

Map<String, dynamic> _$$TeamWorkloadModelImplToJson(
        _$TeamWorkloadModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'active': instance.active,
      'count': instance.count,
    };
