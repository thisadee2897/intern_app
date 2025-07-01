// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkspaceModel _$WorkspaceModelFromJson(Map<String, dynamic> json) {
  return _WorkspaceModel.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceModel {
  @JsonKey(name: 'table_name')
  String? get tableName => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'users')
  List<UserModel>? get users => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_role')
  UserRoleModel? get userRole => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceModelCopyWith<WorkspaceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceModelCopyWith<$Res> {
  factory $WorkspaceModelCopyWith(
          WorkspaceModel value, $Res Function(WorkspaceModel) then) =
      _$WorkspaceModelCopyWithImpl<$Res, WorkspaceModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'users') List<UserModel>? users,
      @JsonKey(name: 'user_role') UserRoleModel? userRole});

  $UserRoleModelCopyWith<$Res>? get userRole;
}

/// @nodoc
class _$WorkspaceModelCopyWithImpl<$Res, $Val extends WorkspaceModel>
    implements $WorkspaceModelCopyWith<$Res> {
  _$WorkspaceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? users = freezed,
    Object? userRole = freezed,
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
      users: freezed == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>?,
      userRole: freezed == userRole
          ? _value.userRole
          : userRole // ignore: cast_nullable_to_non_nullable
              as UserRoleModel?,
    ) as $Val);
  }

  /// Create a copy of WorkspaceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserRoleModelCopyWith<$Res>? get userRole {
    if (_value.userRole == null) {
      return null;
    }

    return $UserRoleModelCopyWith<$Res>(_value.userRole!, (value) {
      return _then(_value.copyWith(userRole: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WorkspaceModelImplCopyWith<$Res>
    implements $WorkspaceModelCopyWith<$Res> {
  factory _$$WorkspaceModelImplCopyWith(_$WorkspaceModelImpl value,
          $Res Function(_$WorkspaceModelImpl) then) =
      __$$WorkspaceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'users') List<UserModel>? users,
      @JsonKey(name: 'user_role') UserRoleModel? userRole});

  @override
  $UserRoleModelCopyWith<$Res>? get userRole;
}

/// @nodoc
class __$$WorkspaceModelImplCopyWithImpl<$Res>
    extends _$WorkspaceModelCopyWithImpl<$Res, _$WorkspaceModelImpl>
    implements _$$WorkspaceModelImplCopyWith<$Res> {
  __$$WorkspaceModelImplCopyWithImpl(
      _$WorkspaceModelImpl _value, $Res Function(_$WorkspaceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkspaceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? users = freezed,
    Object? userRole = freezed,
  }) {
    return _then(_$WorkspaceModelImpl(
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
      users: freezed == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserModel>?,
      userRole: freezed == userRole
          ? _value.userRole
          : userRole // ignore: cast_nullable_to_non_nullable
              as UserRoleModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceModelImpl implements _WorkspaceModel {
  const _$WorkspaceModelImpl(
      {@JsonKey(name: 'table_name') this.tableName,
      @JsonKey(name: 'id') this.id,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'users') final List<UserModel>? users,
      @JsonKey(name: 'user_role') this.userRole})
      : _users = users;

  factory _$WorkspaceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceModelImplFromJson(json);

  @override
  @JsonKey(name: 'table_name')
  final String? tableName;
  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'name')
  final String? name;
  final List<UserModel>? _users;
  @override
  @JsonKey(name: 'users')
  List<UserModel>? get users {
    final value = _users;
    if (value == null) return null;
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'user_role')
  final UserRoleModel? userRole;

  @override
  String toString() {
    return 'WorkspaceModel(tableName: $tableName, id: $id, name: $name, users: $users, userRole: $userRole)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceModelImpl &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.userRole, userRole) ||
                other.userRole == userRole));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tableName, id, name,
      const DeepCollectionEquality().hash(_users), userRole);

  /// Create a copy of WorkspaceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceModelImplCopyWith<_$WorkspaceModelImpl> get copyWith =>
      __$$WorkspaceModelImplCopyWithImpl<_$WorkspaceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceModelImplToJson(
      this,
    );
  }
}

abstract class _WorkspaceModel implements WorkspaceModel {
  const factory _WorkspaceModel(
          {@JsonKey(name: 'table_name') final String? tableName,
          @JsonKey(name: 'id') final String? id,
          @JsonKey(name: 'name') final String? name,
          @JsonKey(name: 'users') final List<UserModel>? users,
          @JsonKey(name: 'user_role') final UserRoleModel? userRole}) =
      _$WorkspaceModelImpl;

  factory _WorkspaceModel.fromJson(Map<String, dynamic> json) =
      _$WorkspaceModelImpl.fromJson;

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
  @JsonKey(name: 'users')
  List<UserModel>? get users;
  @override
  @JsonKey(name: 'user_role')
  UserRoleModel? get userRole;

  /// Create a copy of WorkspaceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceModelImplCopyWith<_$WorkspaceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
