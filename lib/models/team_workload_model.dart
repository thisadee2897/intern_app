
import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_workload_model.freezed.dart';
part 'team_workload_model.g.dart';

@freezed
class TeamWorkloadModel with _$TeamWorkloadModel {
  const factory TeamWorkloadModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'description') String? description,
  @JsonKey(name: 'color') String? color,
  @JsonKey(name: 'active') @Default(true) bool active,
  @JsonKey(name: 'count') @Default(0) num count,
  }) = _TeamWorkloadModel;

  factory TeamWorkloadModel.fromJson(Map<String, dynamic> json) => _$TeamWorkloadModelFromJson(json);
}
