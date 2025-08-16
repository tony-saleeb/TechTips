import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/tip_entity.dart';

part 'tip_model.g.dart';

/// Data model for tip with JSON serialization
@JsonSerializable()
class TipModel {
  final int id;
  final String os;
  final String title;
  final String description;
  final List<String> steps;
  @JsonKey(name: 'media')
  final String? mediaUrl;
  @JsonKey(name: 'media_type')
  final String? mediaType;
  final List<String> tags;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  
  const TipModel({
    required this.id,
    required this.os,
    required this.title,
    required this.description,
    required this.steps,
    this.mediaUrl,
    this.mediaType,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Create TipModel from JSON
  factory TipModel.fromJson(Map<String, dynamic> json) => _$TipModelFromJson(json);
  
  /// Convert TipModel to JSON
  Map<String, dynamic> toJson() => _$TipModelToJson(this);
  
  /// Convert TipModel to TipEntity
  TipEntity toEntity() {
    return TipEntity(
      id: id,
      os: os,
      title: title,
      description: description,
      steps: steps,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      tags: tags,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
  
  /// Create TipModel from TipEntity
  factory TipModel.fromEntity(TipEntity entity) {
    return TipModel(
      id: entity.id,
      os: entity.os,
      title: entity.title,
      description: entity.description,
      steps: entity.steps,
      mediaUrl: entity.mediaUrl,
      mediaType: entity.mediaType,
      tags: entity.tags,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
  
  /// Create a copy of this model with updated values
  TipModel copyWith({
    int? id,
    String? os,
    String? title,
    String? description,
    List<String>? steps,
    String? mediaUrl,
    String? mediaType,
    List<String>? tags,
    String? createdAt,
    String? updatedAt,
  }) {
    return TipModel(
      id: id ?? this.id,
      os: os ?? this.os,
      title: title ?? this.title,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is TipModel &&
        other.id == id &&
        other.os == os &&
        other.title == title &&
        other.description == description &&
        other.steps.length == steps.length &&
        other.mediaUrl == mediaUrl &&
        other.mediaType == mediaType &&
        other.tags.length == tags.length &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      os,
      title,
      description,
      steps.length,
      mediaUrl,
      mediaType,
      tags.length,
      createdAt,
      updatedAt,
    );
  }
  
  @override
  String toString() {
    return 'TipModel(id: $id, os: $os, title: $title)';
  }
}
