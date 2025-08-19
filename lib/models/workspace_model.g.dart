// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceModelImpl _$$WorkspaceModelImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceModelImpl(
      tableName: json['table_name'] as String?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      userRole: json['user_role'] == null
          ? null
          : UserRoleModel.fromJson(json['user_role'] as Map<String, dynamic>),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$WorkspaceModelImplToJson(
        _$WorkspaceModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'id': instance.id,
      'name': instance.name,
      'users': instance.users,
      'user_role': instance.userRole,
      'image': instance.image,
    };
