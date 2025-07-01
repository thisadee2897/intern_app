// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_of_work_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TypeOfWorkModelImpl _$$TypeOfWorkModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TypeOfWorkModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      color: json['color'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$$TypeOfWorkModelImplToJson(
        _$TypeOfWorkModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
      'active': instance.active,
    };
