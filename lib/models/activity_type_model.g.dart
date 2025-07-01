// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityTypeModelImpl _$$ActivityTypeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityTypeModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      color: json['color'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$$ActivityTypeModelImplToJson(
        _$ActivityTypeModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'active': instance.active,
    };
