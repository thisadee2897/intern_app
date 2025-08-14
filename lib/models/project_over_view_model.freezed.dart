// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_over_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectOverViewModel _$ProjectOverViewModelFromJson(Map<String, dynamic> json) {
  return _ProjectOverViewModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectOverViewModel {
  @JsonKey(name: 'table_name')
  String? get tableName => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon')
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'count')
  num get count => throw _privateConstructorUsedError;

  /// Serializes this ProjectOverViewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectOverViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectOverViewModelCopyWith<ProjectOverViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectOverViewModelCopyWith<$Res> {
  factory $ProjectOverViewModelCopyWith(ProjectOverViewModel value,
          $Res Function(ProjectOverViewModel) then) =
      _$ProjectOverViewModelCopyWithImpl<$Res, ProjectOverViewModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'title') String? title,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'icon') String? icon,
      @JsonKey(name: 'count') num count});
}

/// @nodoc
class _$ProjectOverViewModelCopyWithImpl<$Res,
        $Val extends ProjectOverViewModel>
    implements $ProjectOverViewModelCopyWith<$Res> {
  _$ProjectOverViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectOverViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? icon = freezed,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectOverViewModelImplCopyWith<$Res>
    implements $ProjectOverViewModelCopyWith<$Res> {
  factory _$$ProjectOverViewModelImplCopyWith(_$ProjectOverViewModelImpl value,
          $Res Function(_$ProjectOverViewModelImpl) then) =
      __$$ProjectOverViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'table_name') String? tableName,
      @JsonKey(name: 'title') String? title,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'icon') String? icon,
      @JsonKey(name: 'count') num count});
}

/// @nodoc
class __$$ProjectOverViewModelImplCopyWithImpl<$Res>
    extends _$ProjectOverViewModelCopyWithImpl<$Res, _$ProjectOverViewModelImpl>
    implements _$$ProjectOverViewModelImplCopyWith<$Res> {
  __$$ProjectOverViewModelImplCopyWithImpl(_$ProjectOverViewModelImpl _value,
      $Res Function(_$ProjectOverViewModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectOverViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tableName = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? icon = freezed,
    Object? count = null,
  }) {
    return _then(_$ProjectOverViewModelImpl(
      tableName: freezed == tableName
          ? _value.tableName
          : tableName // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectOverViewModelImpl implements _ProjectOverViewModel {
  const _$ProjectOverViewModelImpl(
      {@JsonKey(name: 'table_name') this.tableName,
      @JsonKey(name: 'title') this.title,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'icon') this.icon,
      @JsonKey(name: 'count') this.count = 0});

  factory _$ProjectOverViewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectOverViewModelImplFromJson(json);

  @override
  @JsonKey(name: 'table_name')
  final String? tableName;
  @override
  @JsonKey(name: 'title')
  final String? title;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'icon')
  final String? icon;
  @override
  @JsonKey(name: 'count')
  final num count;

  @override
  String toString() {
    return 'ProjectOverViewModel(tableName: $tableName, title: $title, description: $description, icon: $icon, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectOverViewModelImpl &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tableName, title, description, icon, count);

  /// Create a copy of ProjectOverViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectOverViewModelImplCopyWith<_$ProjectOverViewModelImpl>
      get copyWith =>
          __$$ProjectOverViewModelImplCopyWithImpl<_$ProjectOverViewModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectOverViewModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectOverViewModel implements ProjectOverViewModel {
  const factory _ProjectOverViewModel(
      {@JsonKey(name: 'table_name') final String? tableName,
      @JsonKey(name: 'title') final String? title,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'icon') final String? icon,
      @JsonKey(name: 'count') final num count}) = _$ProjectOverViewModelImpl;

  factory _ProjectOverViewModel.fromJson(Map<String, dynamic> json) =
      _$ProjectOverViewModelImpl.fromJson;

  @override
  @JsonKey(name: 'table_name')
  String? get tableName;
  @override
  @JsonKey(name: 'title')
  String? get title;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'icon')
  String? get icon;
  @override
  @JsonKey(name: 'count')
  num get count;

  /// Create a copy of ProjectOverViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectOverViewModelImplCopyWith<_$ProjectOverViewModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
