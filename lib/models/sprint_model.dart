
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/models/user_model.dart';

part 'sprint_model.freezed.dart';
part 'sprint_model.g.dart';

@freezed
class SprintModel with _$SprintModel {
  const factory SprintModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'duration') num? duration,
  @JsonKey(name: 'satart_date') String? satartDate,
  @JsonKey(name: 'end_date') String? endDate,
  @JsonKey(name: 'goal') String? goal,
  @JsonKey(name: 'completed') bool? completed,
  @JsonKey(name: 'project_hd') ProjectHDModel? projectHd,
  @JsonKey(name: 'created_at') String? createdAt,
  @JsonKey(name: 'updated_at') String? updatedAt,
  @JsonKey(name: 'created_by') UserModel? createdBy,
  @JsonKey(name: 'updated_by') UserModel? updatedBy,
  @JsonKey(name: 'active') bool? active,
  @JsonKey(name: 'startting') bool? startting,
  }) = _SprintModel;

  factory SprintModel.fromJson(Map<String, dynamic> json) => _$SprintModelFromJson(json);
}
