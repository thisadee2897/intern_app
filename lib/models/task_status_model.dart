
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_status_model.freezed.dart';
part 'task_status_model.g.dart';

@freezed
class TaskStatusModel with _$TaskStatusModel {
  const factory TaskStatusModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'description') String? description,
  @JsonKey(name: 'color') String? color,
  @JsonKey(name: 'active') bool? active,
  @JsonKey(name: 'count') @Default(0) int count,
  }) = _TaskStatusModel;

  factory TaskStatusModel.fromJson(Map<String, dynamic> json) => _$TaskStatusModelFromJson(json);
}
