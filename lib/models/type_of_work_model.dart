
import 'package:freezed_annotation/freezed_annotation.dart';

part 'type_of_work_model.freezed.dart';
part 'type_of_work_model.g.dart';

@freezed
class TypeOfWorkModel with _$TypeOfWorkModel {
  const factory TypeOfWorkModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'id') String? id,
  @JsonKey(name: 'name') String? name,
  @JsonKey(name: 'description') String? description,
  @JsonKey(name: 'color') String? color,
  @JsonKey(name: 'active') bool? active,
  }) = _TypeOfWorkModel;

  factory TypeOfWorkModel.fromJson(Map<String, dynamic> json) => _$TypeOfWorkModelFromJson(json);
}
