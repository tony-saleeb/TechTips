// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipModel _$TipModelFromJson(Map<String, dynamic> json) => TipModel(
  id: (json['id'] as num).toInt(),
  os: json['os'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
  mediaUrl: json['media'] as String?,
  mediaType: json['media_type'] as String?,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$TipModelToJson(TipModel instance) => <String, dynamic>{
  'id': instance.id,
  'os': instance.os,
  'title': instance.title,
  'description': instance.description,
  'steps': instance.steps,
  'media': instance.mediaUrl,
  'media_type': instance.mediaType,
  'tags': instance.tags,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
