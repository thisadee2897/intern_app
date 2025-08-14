import 'package:freezed_annotation/freezed_annotation.dart';

part 'priority_model.freezed.dart';
part 'priority_model.g.dart';

@freezed
class PriorityModel with _$PriorityModel {
  const factory PriorityModel({
    @JsonKey(name: 'table_name') String? tableName,
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'color') String? color,
    @JsonKey(name: 'active') @Default(true) bool active,
    @JsonKey(name: 'count') @Default(0) num count,
  }) = _PriorityModel;

  factory PriorityModel.fromJson(Map<String, dynamic> json) => _$PriorityModelFromJson(json);
}
