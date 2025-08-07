// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return _CommentModel.fromJson(json);
}

/// @nodoc
mixin _$CommentModel {
  @JsonKey(name: 'table_name')
  String? get tableName => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'project')
  ProjectHDModel? get project => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_of_work')
  TypeOfWorkModel? get typeOfWork => throw _privateConstructorUsedError;
  @JsonKey(name: 'task')
  TaskModel? get task => throw _privateConstructorUsedError;
  @JsonKey(name: 'comment_json')
  List<Map<String, dynamic>>? get commentJson =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'create_by')
  UserModel? get createBy => throw _privateConstructorUsedError;

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentModelCopyWith<CommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentModelCopyWith<$Res> {
  factory $CommentModelCopyWith(
          CommentModel value, $Res Function(CommentModel) then) =
      _$CommentModelCopyWithImpl<$Res, CommentModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'project') ProjectHDModel? project,
      @JsonKey(name: 'type_of_work') TypeOfWorkModel? typeOfWork,
      @JsonKey(name: 'task') TaskModel? task,
      @JsonKey(name: 'comment_json') List<Map<String, dynamic>>? commentJson,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'create_by') UserModel? createBy});

  $ProjectHDModelCopyWith<$Res>? get project;
  $TypeOfWorkModelCopyWith<$Res>? get typeOfWork;
  $TaskModelCopyWith<$Res>? get task;
  $UserModelCopyWith<$Res>? get createBy;
}

/// @nodoc
class _$CommentModelCopyWithImpl<$Res, $Val extends CommentModel>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? project = freezed,
    Object? typeOfWork = freezed,
    Object? task = freezed,
    Object? commentJson = freezed,
    Object? createdAt = freezed,
    Object? createBy = freezed,
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
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as ProjectHDModel?,
      typeOfWork: freezed == typeOfWork
          ? _value.typeOfWork
          : typeOfWork // ignore: cast_nullable_to_non_nullable
              as TypeOfWorkModel?,
      task: freezed == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as TaskModel?,
      commentJson: freezed == commentJson
          ? _value.commentJson
          : commentJson // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createBy: freezed == createBy
          ? _value.createBy
          : createBy // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ) as $Val);
  }

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectHDModelCopyWith<$Res>? get project {
    if (_value.project == null) {
      return null;
    }

    return $ProjectHDModelCopyWith<$Res>(_value.project!, (value) {
      return _then(_value.copyWith(project: value) as $Val);
    });
  }

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TypeOfWorkModelCopyWith<$Res>? get typeOfWork {
    if (_value.typeOfWork == null) {
      return null;
    }

    return $TypeOfWorkModelCopyWith<$Res>(_value.typeOfWork!, (value) {
      return _then(_value.copyWith(typeOfWork: value) as $Val);
    });
  }

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskModelCopyWith<$Res>? get task {
    if (_value.task == null) {
      return null;
    }

    return $TaskModelCopyWith<$Res>(_value.task!, (value) {
      return _then(_value.copyWith(task: value) as $Val);
    });
  }

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get createBy {
    if (_value.createBy == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.createBy!, (value) {
      return _then(_value.copyWith(createBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentModelImplCopyWith<$Res>
    implements $CommentModelCopyWith<$Res> {
  factory _$$CommentModelImplCopyWith(
          _$CommentModelImpl value, $Res Function(_$CommentModelImpl) then) =
      __$$CommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'project') ProjectHDModel? project,
      @JsonKey(name: 'type_of_work') TypeOfWorkModel? typeOfWork,
      @JsonKey(name: 'task') TaskModel? task,
      @JsonKey(name: 'comment_json') List<Map<String, dynamic>>? commentJson,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'create_by') UserModel? createBy});

  @override
  $ProjectHDModelCopyWith<$Res>? get project;
  @override
  $TypeOfWorkModelCopyWith<$Res>? get typeOfWork;
  @override
  $TaskModelCopyWith<$Res>? get task;
  @override
  $UserModelCopyWith<$Res>? get createBy;
}

/// @nodoc
class __$$CommentModelImplCopyWithImpl<$Res>
    extends _$CommentModelCopyWithImpl<$Res, _$CommentModelImpl>
    implements _$$CommentModelImplCopyWith<$Res> {
  __$$CommentModelImplCopyWithImpl(
      _$CommentModelImpl _value, $Res Function(_$CommentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? project = freezed,
    Object? typeOfWork = freezed,
    Object? task = freezed,
    Object? commentJson = freezed,
    Object? createdAt = freezed,
    Object? createBy = freezed,
  }) {
    return _then(_$CommentModelImpl(
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as ProjectHDModel?,
      typeOfWork: freezed == typeOfWork
          ? _value.typeOfWork
          : typeOfWork // ignore: cast_nullable_to_non_nullable
              as TypeOfWorkModel?,
      task: freezed == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as TaskModel?,
      commentJson: freezed == commentJson
          ? _value._commentJson
          : commentJson // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createBy: freezed == createBy
          ? _value.createBy
          : createBy // ignore: cast_nullable_to_non_nullable
              as UserModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentModelImpl implements _CommentModel {
  const _$CommentModelImpl(
      {@JsonKey(name: 'table_name') this.tableName,
      @JsonKey(name: 'id') this.id,
      @JsonKey(name: 'project') this.project,
      @JsonKey(name: 'type_of_work') this.typeOfWork,
      @JsonKey(name: 'task') this.task,
      @JsonKey(name: 'comment_json')
      final List<Map<String, dynamic>>? commentJson,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'create_by') this.createBy})
      : _commentJson = commentJson;

  factory _$CommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentModelImplFromJson(json);

  @override
  @JsonKey(name: 'table_name')
  final String? tableName;
  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'project')
  final ProjectHDModel? project;
  @override
  @JsonKey(name: 'type_of_work')
  final TypeOfWorkModel? typeOfWork;
  @override
  @JsonKey(name: 'task')
  final TaskModel? task;
  final List<Map<String, dynamic>>? _commentJson;
  @override
  @JsonKey(name: 'comment_json')
  List<Map<String, dynamic>>? get commentJson {
    final value = _commentJson;
    if (value == null) return null;
    if (_commentJson is EqualUnmodifiableListView) return _commentJson;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'create_by')
  final UserModel? createBy;

  @override
  String toString() {
    return 'CommentModel(tableName: $tableName, id: $id, project: $project, typeOfWork: $typeOfWork, task: $task, commentJson: $commentJson, createdAt: $createdAt, createBy: $createBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentModelImpl &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.typeOfWork, typeOfWork) ||
                other.typeOfWork == typeOfWork) &&
            (identical(other.task, task) || other.task == task) &&
            const DeepCollectionEquality()
                .equals(other._commentJson, _commentJson) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createBy, createBy) ||
                other.createBy == createBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tableName,
      id,
      project,
      typeOfWork,
      task,
      const DeepCollectionEquality().hash(_commentJson),
      createdAt,
      createBy);

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      __$$CommentModelImplCopyWithImpl<_$CommentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentModelImplToJson(
      this,
    );
  }
}

abstract class _CommentModel implements CommentModel {
  const factory _CommentModel(
          {@JsonKey(name: 'table_name') final String? tableName,
          @JsonKey(name: 'id') final String? id,
          @JsonKey(name: 'project') final ProjectHDModel? project,
          @JsonKey(name: 'type_of_work') final TypeOfWorkModel? typeOfWork,
          @JsonKey(name: 'task') final TaskModel? task,
          @JsonKey(name: 'comment_json')
          final List<Map<String, dynamic>>? commentJson,
          @JsonKey(name: 'created_at') final String? createdAt,
          @JsonKey(name: 'create_by') final UserModel? createBy}) =
      _$CommentModelImpl;

  factory _CommentModel.fromJson(Map<String, dynamic> json) =
      _$CommentModelImpl.fromJson;

  @override
  @JsonKey(name: 'table_name')
  String? get tableName;
  @override
  @JsonKey(name: 'id')
  String? get id;
  @override
  @JsonKey(name: 'project')
  ProjectHDModel? get project;
  @override
  @JsonKey(name: 'type_of_work')
  TypeOfWorkModel? get typeOfWork;
  @override
  @JsonKey(name: 'task')
  TaskModel? get task;
  @override
  @JsonKey(name: 'comment_json')
  List<Map<String, dynamic>>? get commentJson;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'create_by')
  UserModel? get createBy;

  /// Create a copy of CommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentModelImplCopyWith<_$CommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
