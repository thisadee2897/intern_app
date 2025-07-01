
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_role_model.freezed.dart';
part 'user_role_model.g.dart';

@freezed
class UserRoleModel with _$UserRoleModel {
  const factory UserRoleModel({
  @JsonKey(name: 'can_create_category') bool? canCreateCategory,
  @JsonKey(name: 'can_create_project') bool? canCreateProject,
  @JsonKey(name: 'can_create_sprint') bool? canCreateSprint,
  @JsonKey(name: 'can_create_task') bool? canCreateTask,
  }) = _UserRoleModel;

  factory UserRoleModel.fromJson(Map<String, dynamic> json) => _$UserRoleModelFromJson(json);
}
