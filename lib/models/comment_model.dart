
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project/models/project_h_d_model.dart';
import 'package:project/models/task_model.dart';
import 'package:project/models/type_of_work_model.dart';
import 'package:project/models/user_model.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'project') ProjectHDModel? project,
  @JsonKey(name: 'type_of_work') TypeOfWorkModel? typeOfWork,
  @JsonKey(name: 'task') TaskModel? task,
  @JsonKey(name: 'comment_json') List<Map<String, dynamic>>? commentJson,
  @JsonKey(name: 'created_at') String? createdAt,
  @JsonKey(name: 'create_by') UserModel? createBy,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
}
