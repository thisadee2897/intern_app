// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  @JsonKey(name: 'table_name')
  String? get tableName => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_hd')
  ProjectHDModel? get projectHd => throw _privateConstructorUsedError;
  @JsonKey(name: 'sprint')
  SprintModel? get sprint => throw _privateConstructorUsedError;
  @JsonKey(name: 'priority')
  PriorityModel? get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_status')
  TaskStatusModel? get taskStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_of_work')
  TypeOfWorkModel? get typeOfWork => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to')
  UserModel? get assignedTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_start_date')
  String? get taskStartDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_end_date')
  String? get taskEndDate => throw _privateConstructorUsedError;
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

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'project_hd') ProjectHDModel? projectHd,
      @JsonKey(name: 'sprint') SprintModel? sprint,
      @JsonKey(name: 'priority') PriorityModel? priority,
      @JsonKey(name: 'task_status') TaskStatusModel? taskStatus,
      @JsonKey(name: 'type_of_work') TypeOfWorkModel? typeOfWork,
      @JsonKey(name: 'assigned_to') UserModel? assignedTo,
      @JsonKey(name: 'task_start_date') String? taskStartDate,
      @JsonKey(name: 'task_end_date') String? taskEndDate,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'created_by') UserModel? createdBy,
      @JsonKey(name: 'updated_by') UserModel? updatedBy,
      @JsonKey(name: 'active') bool? active});

  $ProjectHDModelCopyWith<$Res>? get projectHd;
  $SprintModelCopyWith<$Res>? get sprint;
  $PriorityModelCopyWith<$Res>? get priority;
  $TaskStatusModelCopyWith<$Res>? get taskStatus;
  $TypeOfWorkModelCopyWith<$Res>? get typeOfWork;
  $UserModelCopyWith<$Res>? get assignedTo;
  $UserModelCopyWith<$Res>? get createdBy;
  $UserModelCopyWith<$Res>? get updatedBy;
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? projectHd = freezed,
    Object? sprint = freezed,
    Object? priority = freezed,
    Object? taskStatus = freezed,
    Object? typeOfWork = freezed,
    Object? assignedTo = freezed,
    Object? taskStartDate = freezed,
    Object? taskEndDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
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
      projectHd: freezed == projectHd
          ? _value.projectHd
          : projectHd // ignore: cast_nullable_to_non_nullable
              as ProjectHDModel?,
      sprint: freezed == sprint
          ? _value.sprint
          : sprint // ignore: cast_nullable_to_non_nullable
              as SprintModel?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as PriorityModel?,
      taskStatus: freezed == taskStatus
          ? _value.taskStatus
          : taskStatus // ignore: cast_nullable_to_non_nullable
              as TaskStatusModel?,
      typeOfWork: freezed == typeOfWork
          ? _value.typeOfWork
          : typeOfWork // ignore: cast_nullable_to_non_nullable
              as TypeOfWorkModel?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      taskStartDate: freezed == taskStartDate
          ? _value.taskStartDate
          : taskStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      taskEndDate: freezed == taskEndDate
          ? _value.taskEndDate
          : taskEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ) as $Val);
  }

  /// Create a copy of TaskModel
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

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SprintModelCopyWith<$Res>? get sprint {
    if (_value.sprint == null) {
      return null;
    }

    return $SprintModelCopyWith<$Res>(_value.sprint!, (value) {
      return _then(_value.copyWith(sprint: value) as $Val);
    });
  }

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriorityModelCopyWith<$Res>? get priority {
    if (_value.priority == null) {
      return null;
    }

    return $PriorityModelCopyWith<$Res>(_value.priority!, (value) {
      return _then(_value.copyWith(priority: value) as $Val);
    });
  }

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskStatusModelCopyWith<$Res>? get taskStatus {
    if (_value.taskStatus == null) {
      return null;
    }

    return $TaskStatusModelCopyWith<$Res>(_value.taskStatus!, (value) {
      return _then(_value.copyWith(taskStatus: value) as $Val);
    });
  }

  /// Create a copy of TaskModel
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

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get assignedTo {
    if (_value.assignedTo == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.assignedTo!, (value) {
      return _then(_value.copyWith(assignedTo: value) as $Val);
    });
  }

  /// Create a copy of TaskModel
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

  /// Create a copy of TaskModel
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
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
          _$TaskModelImpl value, $Res Function(_$TaskModelImpl) then) =
      __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'id') String? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'project_hd') ProjectHDModel? projectHd,
      @JsonKey(name: 'sprint') SprintModel? sprint,
      @JsonKey(name: 'priority') PriorityModel? priority,
      @JsonKey(name: 'task_status') TaskStatusModel? taskStatus,
      @JsonKey(name: 'type_of_work') TypeOfWorkModel? typeOfWork,
      @JsonKey(name: 'assigned_to') UserModel? assignedTo,
      @JsonKey(name: 'task_start_date') String? taskStartDate,
      @JsonKey(name: 'task_end_date') String? taskEndDate,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'created_by') UserModel? createdBy,
      @JsonKey(name: 'updated_by') UserModel? updatedBy,
      @JsonKey(name: 'active') bool? active});

  @override
  $ProjectHDModelCopyWith<$Res>? get projectHd;
  @override
  $SprintModelCopyWith<$Res>? get sprint;
  @override
  $PriorityModelCopyWith<$Res>? get priority;
  @override
  $TaskStatusModelCopyWith<$Res>? get taskStatus;
  @override
  $TypeOfWorkModelCopyWith<$Res>? get typeOfWork;
  @override
  $UserModelCopyWith<$Res>? get assignedTo;
  @override
  $UserModelCopyWith<$Res>? get createdBy;
  @override
  $UserModelCopyWith<$Res>? get updatedBy;
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
      _$TaskModelImpl _value, $Res Function(_$TaskModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? projectHd = freezed,
    Object? sprint = freezed,
    Object? priority = freezed,
    Object? taskStatus = freezed,
    Object? typeOfWork = freezed,
    Object? assignedTo = freezed,
    Object? taskStartDate = freezed,
    Object? taskEndDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? active = freezed,
  }) {
    return _then(_$TaskModelImpl(
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
      projectHd: freezed == projectHd
          ? _value.projectHd
          : projectHd // ignore: cast_nullable_to_non_nullable
              as ProjectHDModel?,
      sprint: freezed == sprint
          ? _value.sprint
          : sprint // ignore: cast_nullable_to_non_nullable
              as SprintModel?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as PriorityModel?,
      taskStatus: freezed == taskStatus
          ? _value.taskStatus
          : taskStatus // ignore: cast_nullable_to_non_nullable
              as TaskStatusModel?,
      typeOfWork: freezed == typeOfWork
          ? _value.typeOfWork
          : typeOfWork // ignore: cast_nullable_to_non_nullable
              as TypeOfWorkModel?,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      taskStartDate: freezed == taskStartDate
          ? _value.taskStartDate
          : taskStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      taskEndDate: freezed == taskEndDate
          ? _value.taskEndDate
          : taskEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskModelImpl implements _TaskModel {
  const _$TaskModelImpl(
      {@JsonKey(name: 'table_name') this.tableName,
      @JsonKey(name: 'id') this.id,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'project_hd') this.projectHd,
      @JsonKey(name: 'sprint') this.sprint,
      @JsonKey(name: 'priority') this.priority,
      @JsonKey(name: 'task_status') this.taskStatus,
      @JsonKey(name: 'type_of_work') this.typeOfWork,
      @JsonKey(name: 'assigned_to') this.assignedTo,
      @JsonKey(name: 'task_start_date') this.taskStartDate,
      @JsonKey(name: 'task_end_date') this.taskEndDate,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'updated_by') this.updatedBy,
      @JsonKey(name: 'active') this.active});

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

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
  @JsonKey(name: 'project_hd')
  final ProjectHDModel? projectHd;
  @override
  @JsonKey(name: 'sprint')
  final SprintModel? sprint;
  @override
  @JsonKey(name: 'priority')
  final PriorityModel? priority;
  @override
  @JsonKey(name: 'task_status')
  final TaskStatusModel? taskStatus;
  @override
  @JsonKey(name: 'type_of_work')
  final TypeOfWorkModel? typeOfWork;
  @override
  @JsonKey(name: 'assigned_to')
  final UserModel? assignedTo;
  @override
  @JsonKey(name: 'task_start_date')
  final String? taskStartDate;
  @override
  @JsonKey(name: 'task_end_date')
  final String? taskEndDate;
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
  String toString() {
    return 'TaskModel(tableName: $tableName, id: $id, name: $name, description: $description, projectHd: $projectHd, sprint: $sprint, priority: $priority, taskStatus: $taskStatus, typeOfWork: $typeOfWork, assignedTo: $assignedTo, taskStartDate: $taskStartDate, taskEndDate: $taskEndDate, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.projectHd, projectHd) ||
                other.projectHd == projectHd) &&
            (identical(other.sprint, sprint) || other.sprint == sprint) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.taskStatus, taskStatus) ||
                other.taskStatus == taskStatus) &&
            (identical(other.typeOfWork, typeOfWork) ||
                other.typeOfWork == typeOfWork) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.taskStartDate, taskStartDate) ||
                other.taskStartDate == taskStartDate) &&
            (identical(other.taskEndDate, taskEndDate) ||
                other.taskEndDate == taskEndDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tableName,
      id,
      name,
      description,
      projectHd,
      sprint,
      priority,
      taskStatus,
      typeOfWork,
      assignedTo,
      taskStartDate,
      taskEndDate,
      createdAt,
      updatedAt,
      createdBy,
      updatedBy,
      active);

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(
      this,
    );
  }
}

abstract class _TaskModel implements TaskModel {
  const factory _TaskModel(
      {@JsonKey(name: 'table_name') final String? tableName,
      @JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'project_hd') final ProjectHDModel? projectHd,
      @JsonKey(name: 'sprint') final SprintModel? sprint,
      @JsonKey(name: 'priority') final PriorityModel? priority,
      @JsonKey(name: 'task_status') final TaskStatusModel? taskStatus,
      @JsonKey(name: 'type_of_work') final TypeOfWorkModel? typeOfWork,
      @JsonKey(name: 'assigned_to') final UserModel? assignedTo,
      @JsonKey(name: 'task_start_date') final String? taskStartDate,
      @JsonKey(name: 'task_end_date') final String? taskEndDate,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'created_by') final UserModel? createdBy,
      @JsonKey(name: 'updated_by') final UserModel? updatedBy,
      @JsonKey(name: 'active') final bool? active}) = _$TaskModelImpl;

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

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
  @JsonKey(name: 'project_hd')
  ProjectHDModel? get projectHd;
  @override
  @JsonKey(name: 'sprint')
  SprintModel? get sprint;
  @override
  @JsonKey(name: 'priority')
  PriorityModel? get priority;
  @override
  @JsonKey(name: 'task_status')
  TaskStatusModel? get taskStatus;
  @override
  @JsonKey(name: 'type_of_work')
  TypeOfWorkModel? get typeOfWork;
  @override
  @JsonKey(name: 'assigned_to')
  UserModel? get assignedTo;
  @override
  @JsonKey(name: 'task_start_date')
  String? get taskStartDate;
  @override
  @JsonKey(name: 'task_end_date')
  String? get taskEndDate;
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

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
