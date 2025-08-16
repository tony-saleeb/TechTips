import '../entities/tip_entity.dart';

/// Abstract repository contract for tip data operations
abstract class TipRepository {
  /// Get all tips
  Future<List<TipEntity>> getAllTips();
  
  /// Get tips by operating system
  Future<List<TipEntity>> getTipsByOS(String os);
  
  /// Get tip by ID
  Future<TipEntity?> getTipById(int id);
  
  /// Search tips by query
  Future<List<TipEntity>> searchTips(String query);
  
  /// Search tips by query within specific OS
  Future<List<TipEntity>> searchTipsByOS(String query, String os);
  
  /// Get favorite tip IDs
  Future<List<int>> getFavoriteTipIds();
  
  /// Add tip to favorites
  Future<void> addToFavorites(int tipId);
  
  /// Remove tip from favorites
  Future<void> removeFromFavorites(int tipId);
  
  /// Check if tip is favorite
  Future<bool> isFavorite(int tipId);
  
  /// Get favorite tips
  Future<List<TipEntity>> getFavoriteTips();
  
  /// Refresh tips from remote source (future implementation)
  Future<void> refreshTips();
  
  /// Get tips by tags
  Future<List<TipEntity>> getTipsByTags(List<String> tags);
  
  /// Get all available tags
  Future<List<String>> getAllTags();
  
  /// Get popular tips (most favorited)
  Future<List<TipEntity>> getPopularTips({int limit = 10});
  
  /// Get recent tips
  Future<List<TipEntity>> getRecentTips({int limit = 10});
}
