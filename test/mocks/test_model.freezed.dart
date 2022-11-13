// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'test_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TestModel {
  dynamic get id => throw _privateConstructorUsedError;
  int? get colour => throw _privateConstructorUsedError;
  DateTime? get createdDate => throw _privateConstructorUsedError;
  DateTime? get modifiedDate => throw _privateConstructorUsedError;
  dynamic get hierarchyParentId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TestModelCopyWith<TestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestModelCopyWith<$Res> {
  factory $TestModelCopyWith(TestModel value, $Res Function(TestModel) then) =
      _$TestModelCopyWithImpl<$Res>;
  $Res call(
      {dynamic id,
      int? colour,
      DateTime? createdDate,
      DateTime? modifiedDate,
      dynamic hierarchyParentId,
      String name});
}

/// @nodoc
class _$TestModelCopyWithImpl<$Res> implements $TestModelCopyWith<$Res> {
  _$TestModelCopyWithImpl(this._value, this._then);

  final TestModel _value;
  // ignore: unused_field
  final $Res Function(TestModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? colour = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
    Object? hierarchyParentId = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      colour: colour == freezed
          ? _value.colour
          : colour // ignore: cast_nullable_to_non_nullable
              as int?,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedDate: modifiedDate == freezed
          ? _value.modifiedDate
          : modifiedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hierarchyParentId: hierarchyParentId == freezed
          ? _value.hierarchyParentId
          : hierarchyParentId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_TestModelCopyWith<$Res> implements $TestModelCopyWith<$Res> {
  factory _$$_TestModelCopyWith(
          _$_TestModel value, $Res Function(_$_TestModel) then) =
      __$$_TestModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {dynamic id,
      int? colour,
      DateTime? createdDate,
      DateTime? modifiedDate,
      dynamic hierarchyParentId,
      String name});
}

/// @nodoc
class __$$_TestModelCopyWithImpl<$Res> extends _$TestModelCopyWithImpl<$Res>
    implements _$$_TestModelCopyWith<$Res> {
  __$$_TestModelCopyWithImpl(
      _$_TestModel _value, $Res Function(_$_TestModel) _then)
      : super(_value, (v) => _then(v as _$_TestModel));

  @override
  _$_TestModel get _value => super._value as _$_TestModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? colour = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
    Object? hierarchyParentId = freezed,
    Object? name = freezed,
  }) {
    return _then(_$_TestModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      colour: colour == freezed
          ? _value.colour
          : colour // ignore: cast_nullable_to_non_nullable
              as int?,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedDate: modifiedDate == freezed
          ? _value.modifiedDate
          : modifiedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hierarchyParentId: hierarchyParentId == freezed
          ? _value.hierarchyParentId
          : hierarchyParentId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_TestModel extends _TestModel {
  _$_TestModel(
      {this.id,
      this.colour,
      this.createdDate,
      this.modifiedDate,
      this.hierarchyParentId,
      required this.name})
      : super._();

  @override
  final dynamic id;
  @override
  final int? colour;
  @override
  final DateTime? createdDate;
  @override
  final DateTime? modifiedDate;
  @override
  final dynamic hierarchyParentId;
  @override
  final String name;

  @override
  String toString() {
    return 'TestModel(id: $id, colour: $colour, createdDate: $createdDate, modifiedDate: $modifiedDate, hierarchyParentId: $hierarchyParentId, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TestModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.colour, colour) &&
            const DeepCollectionEquality()
                .equals(other.createdDate, createdDate) &&
            const DeepCollectionEquality()
                .equals(other.modifiedDate, modifiedDate) &&
            const DeepCollectionEquality()
                .equals(other.hierarchyParentId, hierarchyParentId) &&
            const DeepCollectionEquality().equals(other.name, name));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(colour),
      const DeepCollectionEquality().hash(createdDate),
      const DeepCollectionEquality().hash(modifiedDate),
      const DeepCollectionEquality().hash(hierarchyParentId),
      const DeepCollectionEquality().hash(name));

  @JsonKey(ignore: true)
  @override
  _$$_TestModelCopyWith<_$_TestModel> get copyWith =>
      __$$_TestModelCopyWithImpl<_$_TestModel>(this, _$identity);
}

abstract class _TestModel extends TestModel {
  factory _TestModel(
      {final dynamic id,
      final int? colour,
      final DateTime? createdDate,
      final DateTime? modifiedDate,
      final dynamic hierarchyParentId,
      required final String name}) = _$_TestModel;
  _TestModel._() : super._();

  @override
  dynamic get id => throw _privateConstructorUsedError;
  @override
  int? get colour => throw _privateConstructorUsedError;
  @override
  DateTime? get createdDate => throw _privateConstructorUsedError;
  @override
  DateTime? get modifiedDate => throw _privateConstructorUsedError;
  @override
  dynamic get hierarchyParentId => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_TestModelCopyWith<_$_TestModel> get copyWith =>
      throw _privateConstructorUsedError;
}
