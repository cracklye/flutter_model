import 'package:flutter_model/flutter_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_dailyaction.freezed.dart';
part 'model_dailyaction.g.dart';

enum DailyActionType {
  numberOf,
  checkbox,
}

@JsonSerializable()
@freezed
class DailyAction extends IModel with _$DailyAction {
  DailyAction._();

  factory DailyAction({
    dynamic id,
    required String name,
    required String description,
    @Default(false) bool carryOver,
    @Default(DailyActionType.checkbox) DailyActionType dailyactionType,
    Reminder? reminder,
    Schedule? schedule,
    int? colour,
    DateTime? createdDate,
    DateTime? modifiedDate,
    dynamic hierarchyParentId,
  }) = _DailyAction;

  @override
  Map<String, dynamic> toJson() {
    return _$DailyActionToJson(this);
  }

  static DailyAction fromJson(Map<String, dynamic> json) =>
      _$DailyActionFromJson(json);

  @override
  String get displayLabel => name;

  @override
  IModel copyWithId(
      {dynamic id, DateTime? createdDate, DateTime? modifiedDate}) {
    DailyAction t = this;
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

class Reminder {}

class Schedule {}
