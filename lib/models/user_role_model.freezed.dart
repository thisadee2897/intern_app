// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserRoleModel _$UserRoleModelFromJson(Map<String, dynamic> json) {
  return _UserRoleModel.fromJson(json);
}

/// @nodoc
mixin _$UserRoleModel {
  @JsonKey(name: 'can_create_category')
  bool? get canCreateCategory => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_create_project')
  bool? get canCreateProject => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_create_sprint')
  bool? get canCreateSprint => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_create_task')
  bool? get canCreateTask => throw _privateConstructorUsedError;

  /// Serializes this UserRoleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRoleModelCopyWith<UserRoleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRoleModelCopyWith<$Res> {
  factory $UserRoleModelCopyWith(
          UserRoleModel value, $Res Function(UserRoleModel) then) =
      _$UserRoleModelCopyWithImpl<$Res, UserRoleModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'can_create_category') bool? canCreateCategory,
      @JsonKey(name: 'can_create_project') bool? canCreateProject,
      @JsonKey(name: 'can_create_sprint') bool? canCreateSprint,
      @JsonKey(name: 'can_create_task') bool? canCreateTask});
}

/// @nodoc
class _$UserRoleModelCopyWithImpl<$Res, $Val extends UserRoleModel>
    implements $UserRoleModelCopyWith<$Res> {
  _$UserRoleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canCreateCategory = freezed,
    Object? canCreateProject = freezed,
    Object? canCreateSprint = freezed,
    Object? canCreateTask = freezed,
  }) {
    return _then(_value.copyWith(
      canCreateCategory: freezed == canCreateCategory
          ? _value.canCreateCategory
          : canCreateCategory // ignore: cast_nullable_to_non_nullable
              as bool?,
      canCreateProject: freezed == canCreateProject
          ? _value.canCreateProject
          : canCreateProject // ignore: cast_nullable_to_non_nullable
              as bool?,
      canCreateSprint: freezed == canCreateSprint
          ? _value.canCreateSprint
          : canCreateSprint // ignore: cast_nullable_to_non_nullable
              as bool?,
      canCreateTask: freezed == canCreateTask
          ? _value.canCreateTask
          : canCreateTask // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRoleModelImplCopyWith<$Res>
    implements $UserRoleModelCopyWith<$Res> {
  factory _$$UserRoleModelImplCopyWith(
          _$UserRoleModelImpl value, $Res Function(_$UserRoleModelImpl) then) =
      __$$UserRoleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'can_create_category') bool? canCreateCategory,
      @JsonKey(name: 'can_create_project') bool? canCreateProject,
      @JsonKey(name: 'can_create_sprint') bool? canCreateSprint,
      @JsonKey(name: 'can_create_task') bool? canCreateTask});
}

/// @nodoc
class __$$UserRoleModelImplCopyWithImpl<$Res>
    extends _$UserRoleModelCopyWithImpl<$Res, _$UserRoleModelImpl>
    implements _$$UserRoleModelImplCopyWith<$Res> {
  __$$UserRoleModelImplCopyWithImpl(
      _$UserRoleModelImpl _value, $Res Function(_$UserRoleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canCreateCategory = freezed,
    Object? canCreateProject = freezed,
    Object? canCreateSprint = freezed,
    Object? canCreateTask = freezed,
  }) {
    return _then(_$UserRoleModelImpl(
      canCreateCategory: freezed == canCreateCategory
          ? _value.canCreateCategory
          : canCreateCategory // ignore: cast_nullable_to_non_nullable
              as bool?,
      canCreateProject: freezed == canCreateProject
          ? _value.canCreateProject
          : canCreateProject // ignore: cast_nullable_to_non_nullable
              as bool?,
      canCreateSprint: freezed == canCreateSprint
          ? _value.canCreateSprint
          : canCreateSprint // ignore: cast_nullable_to_non_nullable
              as bool?,
      canCreateTask: freezed == canCreateTask
          ? _value.canCreateTask
          : canCreateTask // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRoleModelImpl implements _UserRoleModel {
  const _$UserRoleModelImpl(
      {@JsonKey(name: 'can_create_category') this.canCreateCategory,
      @JsonKey(name: 'can_create_project') this.canCreateProject,
      @JsonKey(name: 'can_create_sprint') this.canCreateSprint,
      @JsonKey(name: 'can_create_task') this.canCreateTask});

  factory _$UserRoleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRoleModelImplFromJson(json);

  @override
  @JsonKey(name: 'can_create_category')
  final bool? canCreateCategory;
  @override
  @JsonKey(name: 'can_create_project')
  final bool? canCreateProject;
  @override
  @JsonKey(name: 'can_create_sprint')
  final bool? canCreateSprint;
  @override
  @JsonKey(name: 'can_create_task')
  final bool? canCreateTask;

  @override
  String toString() {
    return 'UserRoleModel(canCreateCategory: $canCreateCategory, canCreateProject: $canCreateProject, canCreateSprint: $canCreateSprint, canCreateTask: $canCreateTask)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRoleModelImpl &&
            (identical(other.canCreateCategory, canCreateCategory) ||
                other.canCreateCategory == canCreateCategory) &&
            (identical(other.canCreateProject, canCreateProject) ||
                other.canCreateProject == canCreateProject) &&
            (identical(other.canCreateSprint, canCreateSprint) ||
                other.canCreateSprint == canCreateSprint) &&
            (identical(other.canCreateTask, canCreateTask) ||
                other.canCreateTask == canCreateTask));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, canCreateCategory,
      canCreateProject, canCreateSprint, canCreateTask);

  /// Create a copy of UserRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRoleModelImplCopyWith<_$UserRoleModelImpl> get copyWith =>
      __$$UserRoleModelImplCopyWithImpl<_$UserRoleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRoleModelImplToJson(
      this,
    );
  }
}

abstract class _UserRoleModel implements UserRoleModel {
  const factory _UserRoleModel(
          {@JsonKey(name: 'can_create_category') final bool? canCreateCategory,
          @JsonKey(name: 'can_create_project') final bool? canCreateProject,
          @JsonKey(name: 'can_create_sprint') final bool? canCreateSprint,
          @JsonKey(name: 'can_create_task') final bool? canCreateTask}) =
      _$UserRoleModelImpl;

  factory _UserRoleModel.fromJson(Map<String, dynamic> json) =
      _$UserRoleModelImpl.fromJson;

  @override
  @JsonKey(name: 'can_create_category')
  bool? get canCreateCategory;
  @override
  @JsonKey(name: 'can_create_project')
  bool? get canCreateProject;
  @override
  @JsonKey(name: 'can_create_sprint')
  bool? get canCreateSprint;
  @override
  @JsonKey(name: 'can_create_task')
  bool? get canCreateTask;

  /// Create a copy of UserRoleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRoleModelImplCopyWith<_$UserRoleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
