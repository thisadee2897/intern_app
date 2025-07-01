
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project/models/user_model.dart';

part 'project_h_d_model.freezed.dart';
part 'project_h_d_model.g.dart';

@freezed
class ProjectHDModel with _$ProjectHDModel {
  const factory ProjectHDModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'category_id') String? categoryId,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'key') String? key,
  @JsonKey(name: 'description') String? description,
  @JsonKey(name: 'leader') UserModel? leader,
  @JsonKey(name: 'created_at') String? createdAt,
  @JsonKey(name: 'updated_at') String? updatedAt,
  @JsonKey(name: 'created_by') UserModel? createdBy,
  @JsonKey(name: 'updated_by') UserModel? updatedBy,
  @JsonKey(name: 'active') bool? active,
  @JsonKey(ignore: true) @Default(0.0)double progress,
  }) = _ProjectHDModel;

  factory ProjectHDModel.fromJson(Map<String, dynamic> json) => _$ProjectHDModelFromJson(json);
}
