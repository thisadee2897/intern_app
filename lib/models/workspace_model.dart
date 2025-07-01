
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';
import 'user_role_model.dart';

part 'workspace_model.freezed.dart';
part 'workspace_model.g.dart';

@freezed
class WorkspaceModel with _$WorkspaceModel {
  const factory WorkspaceModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'users') List<UserModel>? users,
  @JsonKey(name: 'user_role') UserRoleModel? userRole,
  }) = _WorkspaceModel;

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) => _$WorkspaceModelFromJson(json);
}
