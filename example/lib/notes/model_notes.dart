import 'package:flutter_model/flutter_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_notes.freezed.dart';
part 'model_notes.g.dart';

@JsonSerializable()
@freezed
class Notes with _$Notes, IModel, IHierarchy {
  const Notes._();

  factory Notes({
    dynamic id,
    required String name,
    required String description,
    int? colour,
    DateTime? createdDate,
    DateTime? modifiedDate,
    dynamic hierarchyParentId,
  }) = _Notes;

  @override
  Map<String, dynamic> toJson() {
    return _$NotesToJson(this);
  }

  static Notes fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);

  @override
  String get displayLabel => name;

  @override
  IModel copyWithId(
      {dynamic id, DateTime? createdDate, DateTime? modifiedDate}) {
    Notes t = this;
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
