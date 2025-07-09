// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sprint_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SprintModel _$SprintModelFromJson(Map<String, dynamic> json) {
  return _SprintModel.fromJson(json);
}

/// @nodoc
mixin _$SprintModel {
  @JsonKey(name: 'table_name')
  String? get tableName => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration')
  num? get duration => throw _privateConstructorUsedError;
  @JsonKey(name: 'satart_date')
  String? get satartDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  String? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'goal')
  String? get goal => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed')
  bool? get completed => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_hd')
  ProjectHDModel? get projectHd => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  UserModel? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_by')
  UserModel? get updatedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'active')
  bool? get active => throw _privateConstructorUsedError;
  @JsonKey(name: 'startting')
  bool? get startting => throw _privateConstructorUsedError;

  /// Serializes this SprintModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SprintModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SprintModelCopyWith<SprintModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SprintModelCopyWith<$Res> {
  factory $SprintModelCopyWith(
          SprintModel value, $Res Function(SprintModel) then) =
      _$SprintModelCopyWithImpl<$Res, SprintModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
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
      @JsonKey(name: 'startting') bool? startting});

  $ProjectHDModelCopyWith<$Res>? get projectHd;
  $UserModelCopyWith<$Res>? get createdBy;
  $UserModelCopyWith<$Res>? get updatedBy;
}

/// @nodoc
class _$SprintModelCopyWithImpl<$Res, $Val extends SprintModel>
    implements $SprintModelCopyWith<$Res> {
  _$SprintModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SprintModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? duration = freezed,
    Object? satartDate = freezed,
    Object? endDate = freezed,
    Object? goal = freezed,
    Object? completed = freezed,
    Object? projectHd = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? active = freezed,
    Object? startting = freezed,
  }) {
    return _then(_value.copyWith(
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as num?,
      satartDate: freezed == satartDate
          ? _value.satartDate
          : satartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      completed: freezed == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool?,
      projectHd: freezed == projectHd
          ? _value.projectHd
          : projectHd // ignore: cast_nullable_to_non_nullable
              as ProjectHDModel?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      startting: freezed == startting
          ? _value.startting
          : startting // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of SprintModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectHDModelCopyWith<$Res>? get projectHd {
    if (_value.projectHd == null) {
      return null;
    }

    return $ProjectHDModelCopyWith<$Res>(_value.projectHd!, (value) {
      return _then(_value.copyWith(projectHd: value) as $Val);
    });
  }

  /// Create a copy of SprintModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get createdBy {
    if (_value.createdBy == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.createdBy!, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }

  /// Create a copy of SprintModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get updatedBy {
    if (_value.updatedBy == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.updatedBy!, (value) {
      return _then(_value.copyWith(updatedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SprintModelImplCopyWith<$Res>
    implements $SprintModelCopyWith<$Res> {
  factory _$$SprintModelImplCopyWith(
          _$SprintModelImpl value, $Res Function(_$SprintModelImpl) then) =
      __$$SprintModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
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
      @JsonKey(name: 'startting') bool? startting});

  @override
  $ProjectHDModelCopyWith<$Res>? get projectHd;
  @override
  $UserModelCopyWith<$Res>? get createdBy;
  @override
  $UserModelCopyWith<$Res>? get updatedBy;
}

/// @nodoc
class __$$SprintModelImplCopyWithImpl<$Res>
    extends _$SprintModelCopyWithImpl<$Res, _$SprintModelImpl>
    implements _$$SprintModelImplCopyWith<$Res> {
  __$$SprintModelImplCopyWithImpl(
      _$SprintModelImpl _value, $Res Function(_$SprintModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SprintModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? duration = freezed,
    Object? satartDate = freezed,
    Object? endDate = freezed,
    Object? goal = freezed,
    Object? completed = freezed,
    Object? projectHd = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? active = freezed,
    Object? startting = freezed,
  }) {
    return _then(_$SprintModelImpl(
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as num?,
      satartDate: freezed == satartDate
          ? _value.satartDate
          : satartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String?,
      completed: freezed == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool?,
      projectHd: freezed == projectHd
          ? _value.projectHd
          : projectHd // ignore: cast_nullable_to_non_nullable
              as ProjectHDModel?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      startting: freezed == startting
          ? _value.startting
          : startting // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SprintModelImpl implements _SprintModel {
  const _$SprintModelImpl(
      {@JsonKey(name: 'table_name') this.tableName,
      @JsonKey(name: 'id') this.id,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'duration') this.duration,
      @JsonKey(name: 'satart_date') this.satartDate,
      @JsonKey(name: 'end_date') this.endDate,
      @JsonKey(name: 'goal') this.goal,
      @JsonKey(name: 'completed') this.completed,
      @JsonKey(name: 'project_hd') this.projectHd,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'updated_by') this.updatedBy,
      @JsonKey(name: 'active') this.active,
      @JsonKey(name: 'startting') this.startting});

  factory _$SprintModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SprintModelImplFromJson(json);

  @override
  @JsonKey(name: 'table_name')
  final String? tableName;
  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'duration')
  final num? duration;
  @override
  @JsonKey(name: 'satart_date')
  final String? satartDate;
  @override
  @JsonKey(name: 'end_date')
  final String? endDate;
  @override
  @JsonKey(name: 'goal')
  final String? goal;
  @override
  @JsonKey(name: 'completed')
  final bool? completed;
  @override
  @JsonKey(name: 'project_hd')
  final ProjectHDModel? projectHd;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  @JsonKey(name: 'created_by')
  final UserModel? createdBy;
  @override
  @JsonKey(name: 'updated_by')
  final UserModel? updatedBy;
  @override
  @JsonKey(name: 'active')
  final bool? active;
  @override
  @JsonKey(name: 'startting')
  final bool? startting;

  @override
  String toString() {
    return 'SprintModel(tableName: $tableName, id: $id, name: $name, duration: $duration, satartDate: $satartDate, endDate: $endDate, goal: $goal, completed: $completed, projectHd: $projectHd, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, active: $active, startting: $startting)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SprintModelImpl &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.satartDate, satartDate) ||
                other.satartDate == satartDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.projectHd, projectHd) ||
                other.projectHd == projectHd) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.startting, startting) ||
                other.startting == startting));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tableName,
      id,
      name,
      duration,
      satartDate,
      endDate,
      goal,
      completed,
      projectHd,
      createdAt,
      updatedAt,
      createdBy,
      updatedBy,
      active,
      startting);

  /// Create a copy of SprintModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SprintModelImplCopyWith<_$SprintModelImpl> get copyWith =>
      __$$SprintModelImplCopyWithImpl<_$SprintModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SprintModelImplToJson(
      this,
    );
  }
}

abstract class _SprintModel implements SprintModel {
  const factory _SprintModel(
      {@JsonKey(name: 'table_name') final String? tableName,
      @JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'duration') final num? duration,
      @JsonKey(name: 'satart_date') final String? satartDate,
      @JsonKey(name: 'end_date') final String? endDate,
      @JsonKey(name: 'goal') final String? goal,
      @JsonKey(name: 'completed') final bool? completed,
      @JsonKey(name: 'project_hd') final ProjectHDModel? projectHd,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'created_by') final UserModel? createdBy,
      @JsonKey(name: 'updated_by') final UserModel? updatedBy,
      @JsonKey(name: 'active') final bool? active,
      @JsonKey(name: 'startting') final bool? startting}) = _$SprintModelImpl;

  factory _SprintModel.fromJson(Map<String, dynamic> json) =
      _$SprintModelImpl.fromJson;

  @override
  @JsonKey(name: 'table_name')
  String? get tableName;
  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'duration')
  num? get duration;
  @override
  @JsonKey(name: 'satart_date')
  String? get satartDate;
  @override
  @JsonKey(name: 'end_date')
  String? get endDate;
  @override
  @JsonKey(name: 'goal')
  String? get goal;
  @override
  @JsonKey(name: 'completed')
  bool? get completed;
  @override
  @JsonKey(name: 'project_hd')
  ProjectHDModel? get projectHd;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(name: 'created_by')
  UserModel? get createdBy;
  @override
  @JsonKey(name: 'updated_by')
  UserModel? get updatedBy;
  @override
  @JsonKey(name: 'active')
  bool? get active;
  @override
  @JsonKey(name: 'startting')
  bool? get startting;

  /// Create a copy of SprintModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SprintModelImplCopyWith<_$SprintModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
