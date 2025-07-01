
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'email') String? email,
  @JsonKey(name: 'password') String? password,
  @JsonKey(name: 'active') bool? active,
  @JsonKey(name: 'created_at') String? createdAt,
  @JsonKey(name: 'updated_at') String? updatedAt,
  @JsonKey(name: 'image') String? image,
  @JsonKey(name: 'public_name') String? publicName,
  @JsonKey(name: 'job_title') String? jobTitle,
  @JsonKey(name: 'department') String? department,
  @JsonKey(name: 'base_in') String? baseIn,
  @JsonKey(name: 'phone_number') String? phoneNumber,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
