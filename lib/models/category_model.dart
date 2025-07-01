
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project/models/user_model.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'description') String? description,
  @JsonKey(name: 'active') bool? active,
  @JsonKey(name: 'created_at') String? createdAt,
  @JsonKey(name: 'updated_at') String? updatedAt,
  @JsonKey(name: 'created_by') UserModel? createdBy,
  @JsonKey(name: 'updated_by') UserModel? updatedBy,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
}
