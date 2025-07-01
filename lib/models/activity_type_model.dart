
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_type_model.freezed.dart';
part 'activity_type_model.g.dart';

@freezed
class ActivityTypeModel with _$ActivityTypeModel {
  const factory ActivityTypeModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'description') String? description,
  @JsonKey(name: 'color') String? color,
  @JsonKey(name: 'active') bool? active,
  }) = _ActivityTypeModel;

  factory ActivityTypeModel.fromJson(Map<String, dynamic> json) => _$ActivityTypeModelFromJson(json);
}
