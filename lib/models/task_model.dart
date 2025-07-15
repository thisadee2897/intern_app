
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project/models/priority_model.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/models/sprint_model.dart';
import 'package:project/models/task_status_model.dart';
import 'package:project/models/type_of_work_model.dart';
import 'package:project/models/user_model.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';
 
@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'description') String? description,
  @JsonKey(name: 'project_hd') ProjectHDModel? projectHd,
  @JsonKey(name: 'sprint') SprintModel? sprint,
  @JsonKey(name: 'priority') PriorityModel? priority,
  @JsonKey(name: 'task_status') TaskStatusModel? taskStatus,
  @JsonKey(name: 'type_of_work') TypeOfWorkModel? typeOfWork,
  @JsonKey(name: 'assigned_to') UserModel? assignedTo,
  @JsonKey(name: 'task_start_date') String? taskStartDate,
  @JsonKey(name: 'task_end_date') String? taskEndDate,
  @JsonKey(name: 'created_at') String? createdAt,
  @JsonKey(name: 'updated_at') String? updatedAt,
  @JsonKey(name: 'created_by') UserModel? createdBy,
  @JsonKey(name: 'updated_by') UserModel? updatedBy,
  @JsonKey(name: 'active') bool? active,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
}
