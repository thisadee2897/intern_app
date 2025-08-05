// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_h_d_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectHDModelImpl _$$ProjectHDModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectHDModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      categoryId: json['category_id'] as String?,
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      name: json['name'] as String?,
      key: json['key'] as String?,
      description: json['description'] as String?,
      leader: json['leader'] == null
          ? null
          : UserModel.fromJson(json['leader'] as Map<String, dynamic>),
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

Map<String, dynamic> _$$ProjectHDModelImplToJson(
        _$ProjectHDModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'category_id': instance.categoryId,
      'category': instance.category,
      'name': instance.name,
      'key': instance.key,
      'description': instance.description,
      'leader': instance.leader,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'active': instance.active,
    };
