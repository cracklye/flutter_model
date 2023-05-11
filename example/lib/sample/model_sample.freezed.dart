// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Sample {
  dynamic get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int? get colour => throw _privateConstructorUsedError;
  DateTime? get createdDate => throw _privateConstructorUsedError;
  DateTime? get modifiedDate => throw _privateConstructorUsedError;
  dynamic get hierarchyParentId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SampleCopyWith<Sample> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SampleCopyWith<$Res> {
  factory $SampleCopyWith(Sample value, $Res Function(Sample) then) =
      _$SampleCopyWithImpl<$Res, Sample>;
  @useResult
  $Res call(
      {dynamic id,
      String name,
      String description,
      int? colour,
      DateTime? createdDate,
      DateTime? modifiedDate,
      dynamic hierarchyParentId});
}

/// @nodoc
class _$SampleCopyWithImpl<$Res, $Val extends Sample>
    implements $SampleCopyWith<$Res> {
  _$SampleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? description = null,
    Object? colour = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
    Object? hierarchyParentId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      colour: freezed == colour
          ? _value.colour
          : colour // ignore: cast_nullable_to_non_nullable
              as int?,
      createdDate: freezed == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedDate: freezed == modifiedDate
          ? _value.modifiedDate
          : modifiedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hierarchyParentId: freezed == hierarchyParentId
          ? _value.hierarchyParentId
          : hierarchyParentId // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SampleCopyWith<$Res> implements $SampleCopyWith<$Res> {
  factory _$$_SampleCopyWith(_$_Sample value, $Res Function(_$_Sample) then) =
      __$$_SampleCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic id,
      String name,
      String description,
      int? colour,
      DateTime? createdDate,
      DateTime? modifiedDate,
      dynamic hierarchyParentId});
}

/// @nodoc
class __$$_SampleCopyWithImpl<$Res>
    extends _$SampleCopyWithImpl<$Res, _$_Sample>
    implements _$$_SampleCopyWith<$Res> {
  __$$_SampleCopyWithImpl(_$_Sample _value, $Res Function(_$_Sample) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? description = null,
    Object? colour = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
    Object? hierarchyParentId = freezed,
  }) {
    return _then(_$_Sample(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      colour: freezed == colour
          ? _value.colour
          : colour // ignore: cast_nullable_to_non_nullable
              as int?,
      createdDate: freezed == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedDate: freezed == modifiedDate
          ? _value.modifiedDate
          : modifiedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hierarchyParentId: freezed == hierarchyParentId
          ? _value.hierarchyParentId
          : hierarchyParentId // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$_Sample extends _Sample {
  _$_Sample(
      {this.id,
      required this.name,
      required this.description,
      this.colour,
      this.createdDate,
      this.modifiedDate,
      this.hierarchyParentId})
      : super._();

  @override
  final dynamic id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int? colour;
  @override
  final DateTime? createdDate;
  @override
  final DateTime? modifiedDate;
  @override
  final dynamic hierarchyParentId;

  @override
  String toString() {
    return 'Sample(id: $id, name: $name, description: $description, colour: $colour, createdDate: $createdDate, modifiedDate: $modifiedDate, hierarchyParentId: $hierarchyParentId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Sample &&
            const DeepCollectionEquality().equals(other.id, id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.colour, colour) || other.colour == colour) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.modifiedDate, modifiedDate) ||
                other.modifiedDate == modifiedDate) &&
            const DeepCollectionEquality()
                .equals(other.hierarchyParentId, hierarchyParentId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      name,
      description,
      colour,
      createdDate,
      modifiedDate,
      const DeepCollectionEquality().hash(hierarchyParentId));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SampleCopyWith<_$_Sample> get copyWith =>
      __$$_SampleCopyWithImpl<_$_Sample>(this, _$identity);
}

abstract class _Sample extends Sample {
  factory _Sample(
      {final dynamic id,
      required final String name,
      required final String description,
      final int? colour,
      final DateTime? createdDate,
      final DateTime? modifiedDate,
      final dynamic hierarchyParentId}) = _$_Sample;
  _Sample._() : super._();

  @override
  dynamic get id;
  @override
  String get name;
  @override
  String get description;
  @override
  int? get colour;
  @override
  DateTime? get createdDate;
  @override
  DateTime? get modifiedDate;
  @override
  dynamic get hierarchyParentId;
  @override
  @JsonKey(ignore: true)
  _$$_SampleCopyWith<_$_Sample> get copyWith =>
      throw _privateConstructorUsedError;
}
