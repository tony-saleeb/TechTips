/// Category entity for organizing tips
class CategoryEntity {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final String iconPath;
  final String color;
  final int tipCount;
  final bool isActive;
  
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    required this.iconPath,
    required this.color,
    required this.tipCount,
    required this.isActive,
  });
  
  /// Create a copy of this entity with updated values
  CategoryEntity copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? iconPath,
    String? color,
    int? tipCount,
    bool? isActive,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      color: color ?? this.color,
      tipCount: tipCount ?? this.tipCount,
      isActive: isActive ?? this.isActive,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is CategoryEntity &&
        other.id == id &&
        other.name == name &&
        other.displayName == displayName &&
        other.description == description &&
        other.iconPath == iconPath &&
        other.color == color &&
        other.tipCount == tipCount &&
        other.isActive == isActive;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      displayName,
      description,
      iconPath,
      color,
      tipCount,
      isActive,
    );
  }
  
  @override
  String toString() {
    return 'CategoryEntity(id: $id, name: $name, tipCount: $tipCount)';
  }
}
