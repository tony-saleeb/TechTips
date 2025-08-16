import '../entities/tip_entity.dart';
import '../repositories/tip_repository.dart';

/// Use case for managing favorite tips
class ManageFavoritesUseCase {
  final TipRepository _repository;
  
  const ManageFavoritesUseCase(this._repository);
  
  /// Add tip to favorites
  Future<void> addToFavorites(int tipId) async {
    if (tipId <= 0) {
      throw ArgumentError('Invalid tip ID: $tipId');
    }
    
    try {
      // Check if tip exists
      final tip = await _repository.getTipById(tipId);
      if (tip == null) {
        throw Exception('Tip with ID $tipId not found');
      }
      
      // Check if already favorite
      final isFav = await _repository.isFavorite(tipId);
      if (isFav) {
        return; // Already favorite, no action needed
      }
      
      await _repository.addToFavorites(tipId);
    } catch (e) {
      throw Exception('Failed to add tip to favorites: $e');
    }
  }
  
  /// Remove tip from favorites
  Future<void> removeFromFavorites(int tipId) async {
    if (tipId <= 0) {
      throw ArgumentError('Invalid tip ID: $tipId');
    }
    
    try {
      // Check if currently favorite
      final isFav = await _repository.isFavorite(tipId);
      if (!isFav) {
        return; // Not favorite, no action needed
      }
      
      await _repository.removeFromFavorites(tipId);
    } catch (e) {
      throw Exception('Failed to remove tip from favorites: $e');
    }
  }
  
  /// Toggle favorite status
  Future<bool> toggleFavorite(int tipId) async {
    if (tipId <= 0) {
      throw ArgumentError('Invalid tip ID: $tipId');
    }
    
    try {
      final isFav = await _repository.isFavorite(tipId);
      
      if (isFav) {
        await removeFromFavorites(tipId);
        return false;
      } else {
        await addToFavorites(tipId);
        return true;
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite status: $e');
    }
  }
  
  /// Check if tip is favorite
  Future<bool> isFavorite(int tipId) async {
    if (tipId <= 0) {
      throw ArgumentError('Invalid tip ID: $tipId');
    }
    
    try {
      return await _repository.isFavorite(tipId);
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }
  
  /// Get all favorite tips
  Future<List<TipEntity>> getFavoriteTips() async {
    try {
      final favorites = await _repository.getFavoriteTips();
      
      // Sort by creation date (newest first)
      favorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return favorites;
    } catch (e) {
      throw Exception('Failed to get favorite tips: $e');
    }
  }
  
  /// Get favorite tip IDs
  Future<List<int>> getFavoriteIds() async {
    try {
      return await _repository.getFavoriteTipIds();
    } catch (e) {
      throw Exception('Failed to get favorite IDs: $e');
    }
  }
}
