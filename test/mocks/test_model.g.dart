// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestModel _$TestModelFromJson(Map<String, dynamic> json) => TestModel(
      id: json['id'],
      colour: json['colour'] as int?,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      hierarchyParentId: json['hierarchyParentId'],
      name: json['name'] as String,
    );

Map<String, dynamic> _$TestModelToJson(TestModel instance) => <String, dynamic>{
      'id': instance.id,
      'colour': instance.colour,
      'createdDate': instance.createdDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'hierarchyParentId': instance.hierarchyParentId,
      'name': instance.name,
    };
