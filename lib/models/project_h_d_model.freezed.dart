// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_h_d_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectHDModel _$ProjectHDModelFromJson(Map<String, dynamic> json) {
  return _ProjectHDModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectHDModel {
  @JsonKey(name: 'table_name')
  String? get tableName => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category')
  CategoryModel? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'key')
  String? get key => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'leader')
  UserModel? get leader => throw _privateConstructorUsedError;
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
  @JsonKey(ignore: true)
  double get progress => throw _privateConstructorUsedError;

  /// Serializes this ProjectHDModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectHDModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectHDModelCopyWith<ProjectHDModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectHDModelCopyWith<$Res> {
  factory $ProjectHDModelCopyWith(
          ProjectHDModel value, $Res Function(ProjectHDModel) then) =
      _$ProjectHDModelCopyWithImpl<$Res, ProjectHDModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'category') CategoryModel? category,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'leader') UserModel? leader,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'created_by') UserModel? createdBy,
      @JsonKey(name: 'updated_by') UserModel? updatedBy,
      @JsonKey(name: 'active') bool? active,
      @JsonKey(ignore: true) double progress});

  $CategoryModelCopyWith<$Res>? get category;
  $UserModelCopyWith<$Res>? get leader;
  $UserModelCopyWith<$Res>? get createdBy;
  $UserModelCopyWith<$Res>? get updatedBy;
}

/// @nodoc
class _$ProjectHDModelCopyWithImpl<$Res, $Val extends ProjectHDModel>
    implements $ProjectHDModelCopyWith<$Res> {
  _$ProjectHDModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectHDModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? categoryId = freezed,
    Object? category = freezed,
    Object? name = freezed,
    Object? key = freezed,
    Object? description = freezed,
    Object? leader = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? active = freezed,
    Object? progress = null,
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
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      leader: freezed == leader
          ? _value.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as UserModel?,
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
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of ProjectHDModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryModelCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of ProjectHDModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get leader {
    if (_value.leader == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.leader!, (value) {
      return _then(_value.copyWith(leader: value) as $Val);
    });
  }

  /// Create a copy of ProjectHDModel
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

  /// Create a copy of ProjectHDModel
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
abstract class _$$ProjectHDModelImplCopyWith<$Res>
    implements $ProjectHDModelCopyWith<$Res> {
  factory _$$ProjectHDModelImplCopyWith(_$ProjectHDModelImpl value,
          $Res Function(_$ProjectHDModelImpl) then) =
      __$$ProjectHDModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'category_id') String? categoryId,
      @JsonKey(name: 'category') CategoryModel? category,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'leader') UserModel? leader,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'created_by') UserModel? createdBy,
      @JsonKey(name: 'updated_by') UserModel? updatedBy,
      @JsonKey(name: 'active') bool? active,
      @JsonKey(ignore: true) double progress});

  @override
  $CategoryModelCopyWith<$Res>? get category;
  @override
  $UserModelCopyWith<$Res>? get leader;
  @override
  $UserModelCopyWith<$Res>? get createdBy;
  @override
  $UserModelCopyWith<$Res>? get updatedBy;
}

/// @nodoc
class __$$ProjectHDModelImplCopyWithImpl<$Res>
    extends _$ProjectHDModelCopyWithImpl<$Res, _$ProjectHDModelImpl>
    implements _$$ProjectHDModelImplCopyWith<$Res> {
  __$$ProjectHDModelImplCopyWithImpl(
      _$ProjectHDModelImpl _value, $Res Function(_$ProjectHDModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectHDModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? categoryId = freezed,
    Object? category = freezed,
    Object? name = freezed,
    Object? key = freezed,
    Object? description = freezed,
    Object? leader = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? active = freezed,
    Object? progress = null,
  }) {
    return _then(_$ProjectHDModelImpl(
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CategoryModel?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      leader: freezed == leader
          ? _value.leader
          : leader // ignore: cast_nullable_to_non_nullable
              as UserModel?,
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
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectHDModelImpl implements _ProjectHDModel {
  const _$ProjectHDModelImpl(
      {@JsonKey(name: 'table_name') this.tableName,
      @JsonKey(name: 'id') this.id,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'category') this.category,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'key') this.key,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'leader') this.leader,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'updated_by') this.updatedBy,
      @JsonKey(name: 'active') this.active,
      @JsonKey(ignore: true) this.progress = 0.0});

  factory _$ProjectHDModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectHDModelImplFromJson(json);

  @override
  @JsonKey(name: 'table_name')
  final String? tableName;
  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  @JsonKey(name: 'category')
  final CategoryModel? category;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'key')
  final String? key;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'leader')
  final UserModel? leader;
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
  @JsonKey(ignore: true)
  final double progress;

  @override
  String toString() {
    return 'ProjectHDModel(tableName: $tableName, id: $id, categoryId: $categoryId, category: $category, name: $name, key: $key, description: $description, leader: $leader, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, active: $active, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectHDModelImpl &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.leader, leader) || other.leader == leader) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tableName,
      id,
      categoryId,
      category,
      name,
      key,
      description,
      leader,
      createdAt,
      updatedAt,
      createdBy,
      updatedBy,
      active,
      progress);

  /// Create a copy of ProjectHDModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectHDModelImplCopyWith<_$ProjectHDModelImpl> get copyWith =>
      __$$ProjectHDModelImplCopyWithImpl<_$ProjectHDModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectHDModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectHDModel implements ProjectHDModel {
  const factory _ProjectHDModel(
      {@JsonKey(name: 'table_name') final String? tableName,
      @JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'category_id') final String? categoryId,
      @JsonKey(name: 'category') final CategoryModel? category,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'key') final String? key,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'leader') final UserModel? leader,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'created_by') final UserModel? createdBy,
      @JsonKey(name: 'updated_by') final UserModel? updatedBy,
      @JsonKey(name: 'active') final bool? active,
      @JsonKey(ignore: true) final double progress}) = _$ProjectHDModelImpl;

  factory _ProjectHDModel.fromJson(Map<String, dynamic> json) =
      _$ProjectHDModelImpl.fromJson;

  @override
  @JsonKey(name: 'table_name')
  String? get tableName;
  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  @JsonKey(name: 'category')
  CategoryModel? get category;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'key')
  String? get key;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'leader')
  UserModel? get leader;
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
  @JsonKey(ignore: true)
  double get progress;

  /// Create a copy of ProjectHDModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectHDModelImplCopyWith<_$ProjectHDModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
