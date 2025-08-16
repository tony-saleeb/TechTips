/// Core tip entity - immutable business object
class TipEntity {
  final int id;
  final String os;
  final String title;
  final String description;
  final List<String> steps;
  final String? mediaUrl;
  final String? mediaType; // 'image', 'gif', 'video'
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const TipEntity({
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
  
  /// Create a copy of this entity with updated values
  TipEntity copyWith({
    int? id,
    String? os,
    String? title,
    String? description,
    List<String>? steps,
    String? mediaUrl,
    String? mediaType,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TipEntity(
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
    
    return other is TipEntity &&
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
    return 'TipEntity(id: $id, os: $os, title: $title)';
  }
}
