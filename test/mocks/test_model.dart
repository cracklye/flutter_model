import 'package:flutter_model/flutter_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_model.freezed.dart';
part 'test_model.g.dart';

@JsonSerializable()
@freezed
class TestModel extends IModel with _$TestModel implements IHierarchy {
  TestModel._();

  factory TestModel({
    dynamic id,
    int? colour,
    DateTime? createdDate,
    DateTime? modifiedDate,
    dynamic hierarchyParentId,
    required String name,
  }) = _TestModel;

  @override
  Map<String, dynamic> toJson() {
    return _$TestModelToJson(this);
  }

  static TestModel fromJson(Map<String, dynamic> json) =>
      _$TestModelFromJson(json);

  @override
  String get displayLabel => "name";

  @override
  IModel copyWithId(
      {dynamic id, DateTime? createdDate, DateTime? modifiedDate}) {
    TestModel t = this;
    if (id != null) {
      t = t.copyWith(id: id);
    } else if (modifiedDate != null) {
      t = t.copyWith(modifiedDate: modifiedDate);
    } else if (createdDate != null) {
      t = t.copyWith(createdDate: createdDate);
    }
    return t;
  }
}
