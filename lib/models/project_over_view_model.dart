
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_over_view_model.freezed.dart';
part 'project_over_view_model.g.dart';

@freezed
class ProjectOverViewModel with _$ProjectOverViewModel {
  const factory ProjectOverViewModel({
  @JsonKey(name: 'table_name') String? tableName,
  @JsonKey(name: 'title') String? title,
  @JsonKey(name: 'description') String? description,
  @JsonKey(name: 'icon') String? icon,
  @JsonKey(name: 'count') @Default(0) num count,
  }) = _ProjectOverViewModel;

  factory ProjectOverViewModel.fromJson(Map<String, dynamic> json) => _$ProjectOverViewModelFromJson(json);
}
