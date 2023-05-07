// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notes _$NotesFromJson(Map<String, dynamic> json) => Notes(
      id: json['id'],
      name: json['name'] as String,
      description: json['description'] as String,
      colour: json['colour'] as int?,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      hierarchyParentId: json['hierarchyParentId'],
    );

Map<String, dynamic> _$NotesToJson(Notes instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'colour': instance.colour,
      'createdDate': instance.createdDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'hierarchyParentId': instance.hierarchyParentId,
    };
