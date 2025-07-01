// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivityTypeModel _$ActivityTypeModelFromJson(Map<String, dynamic> json) {
  return _ActivityTypeModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityTypeModel {
  @JsonKey(name: 'table_name')
  String? get tableName => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'color')
  String? get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'active')
  bool? get active => throw _privateConstructorUsedError;

  /// Serializes this ActivityTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityTypeModelCopyWith<ActivityTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityTypeModelCopyWith<$Res> {
  factory $ActivityTypeModelCopyWith(
          ActivityTypeModel value, $Res Function(ActivityTypeModel) then) =
      _$ActivityTypeModelCopyWithImpl<$Res, ActivityTypeModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'color') String? color,
      @JsonKey(name: 'active') bool? active});
}

/// @nodoc
class _$ActivityTypeModelCopyWithImpl<$Res, $Val extends ActivityTypeModel>
    implements $ActivityTypeModelCopyWith<$Res> {
  _$ActivityTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? color = freezed,
    Object? active = freezed,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityTypeModelImplCopyWith<$Res>
    implements $ActivityTypeModelCopyWith<$Res> {
  factory _$$ActivityTypeModelImplCopyWith(_$ActivityTypeModelImpl value,
          $Res Function(_$ActivityTypeModelImpl) then) =
      __$$ActivityTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'color') String? color,
      @JsonKey(name: 'active') bool? active});
}

/// @nodoc
class __$$ActivityTypeModelImplCopyWithImpl<$Res>
    extends _$ActivityTypeModelCopyWithImpl<$Res, _$ActivityTypeModelImpl>
    implements _$$ActivityTypeModelImplCopyWith<$Res> {
  __$$ActivityTypeModelImplCopyWithImpl(_$ActivityTypeModelImpl _value,
      $Res Function(_$ActivityTypeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? color = freezed,
    Object? active = freezed,
  }) {
    return _then(_$ActivityTypeModelImpl(
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityTypeModelImpl implements _ActivityTypeModel {
  const _$ActivityTypeModelImpl(
      {@JsonKey(name: 'table_name') this.tableName,
      @JsonKey(name: 'id') this.id,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'color') this.color,
      @JsonKey(name: 'active') this.active});

  factory _$ActivityTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityTypeModelImplFromJson(json);

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
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'color')
  final String? color;
  @override
  @JsonKey(name: 'active')
  final bool? active;

  @override
  String toString() {
    return 'ActivityTypeModel(tableName: $tableName, id: $id, name: $name, description: $description, color: $color, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityTypeModelImpl &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tableName, id, name, description, color, active);

  /// Create a copy of ActivityTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityTypeModelImplCopyWith<_$ActivityTypeModelImpl> get copyWith =>
      __$$ActivityTypeModelImplCopyWithImpl<_$ActivityTypeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityTypeModelImplToJson(
      this,
    );
  }
}

abstract class _ActivityTypeModel implements ActivityTypeModel {
  const factory _ActivityTypeModel(
      {@JsonKey(name: 'table_name') final String? tableName,
      @JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'color') final String? color,
      @JsonKey(name: 'active') final bool? active}) = _$ActivityTypeModelImpl;

  factory _ActivityTypeModel.fromJson(Map<String, dynamic> json) =
      _$ActivityTypeModelImpl.fromJson;

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
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'color')
  String? get color;
  @override
  @JsonKey(name: 'active')
  bool? get active;

  /// Create a copy of ActivityTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityTypeModelImplCopyWith<_$ActivityTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
