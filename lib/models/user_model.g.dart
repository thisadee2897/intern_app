// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      active: json['active'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'active': instance.active,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'image': instance.image,
    };
