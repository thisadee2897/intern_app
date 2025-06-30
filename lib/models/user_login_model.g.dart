// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserLoginModelImpl _$$UserLoginModelImplFromJson(Map<String, dynamic> json) =>
    _$UserLoginModelImpl(
      accessToken: json['access_token'] as String?,
      tokenType: json['token_type'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserLoginModelImplToJson(
        _$UserLoginModelImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'user': instance.user,
    };
