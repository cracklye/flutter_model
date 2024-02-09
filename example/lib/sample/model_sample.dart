import 'package:flutter_model/flutter_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_sample.freezed.dart';
part 'model_sample.g.dart';

@JsonSerializable()
@freezed
class Sample extends IModel with _$Sample implements IHierarchy {
   Sample._();

  factory Sample({
    dynamic id,
    required String name,
    required String description,
    int? colour,
    DateTime? createdDate,
    DateTime? modifiedDate,
    dynamic hierarchyParentId,
  }) = _Sample;

  @override
  Map<String, dynamic> toJson() {
    return _$SampleToJson(this);
  }

  static Sample fromJson(Map<String, dynamic> json) => _$SampleFromJson(json);

  @override
  String get displayLabel => name;

  @override
  IModel copyWithId(
      {dynamic id, DateTime? createdDate, DateTime? modifiedDate}) {
    Sample t = this;
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

