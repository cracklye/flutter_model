// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_dailyaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyAction _$DailyActionFromJson(Map<String, dynamic> json) => DailyAction(
      id: json['id'],
      name: json['name'] as String,
      description: json['description'] as String,
      carryOver: json['carryOver'] as bool,
      dailyactionType:
          $enumDecode(_$DailyActionTypeEnumMap, json['dailyactionType']),
      colour: (json['colour'] as num?)?.toInt(),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      hierarchyParentId: json['hierarchyParentId'],
    );

Map<String, dynamic> _$DailyActionToJson(DailyAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'carryOver': instance.carryOver,
      'dailyactionType': _$DailyActionTypeEnumMap[instance.dailyactionType]!,
      'colour': instance.colour,
      'createdDate': instance.createdDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'hierarchyParentId': instance.hierarchyParentId,
    };

const _$DailyActionTypeEnumMap = {
  DailyActionType.numberOf: 'numberOf',
  DailyActionType.checkbox: 'checkbox',
};
