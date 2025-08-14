// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_over_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectOverViewModelImpl _$$ProjectOverViewModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectOverViewModelImpl(
      tableName: json['table_name'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      count: json['count'] as num? ?? 0,
    );

Map<String, dynamic> _$$ProjectOverViewModelImplToJson(
        _$ProjectOverViewModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'count': instance.count,
    };
