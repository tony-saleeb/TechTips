import '../../domain/entities/tip_entity.dart';
import '../../domain/repositories/tip_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/tip_model.dart';

/// Implementation of TipRepository using local data source
class TipRepositoryImpl implements TipRepository {
  final LocalDataSource _localDataSource;
  List<TipModel>? _cachedTips;
  
  TipRepositoryImpl(this._localDataSource);
  
  /// Load and cache tips if not already loaded
  Future<List<TipModel>> _getTips() async {
    _cachedTips ??= await _localDataSource.loadTipsFromAsset();
    return _cachedTips!;
  }
  
  @override
  Future<List<TipEntity>> getAllTips() async {
    try {
      final tips = await _getTips();
      return tips.map((tip) => tip.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get all tips: $e');
    }
  }
  
  @override
  Future<List<TipEntity>> getTipsByOS(String os) async {
    try {
      final tips = await _getTips();
      final filteredTips = tips
          .where((tip) => tip.os.toLowerCase() == os.toLowerCase())
          .toList();
      return filteredTips.map((tip) => tip.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get tips for $os: $e');
    }
  }
  
  @override
  Future<TipEntity?> getTipById(int id) async {
    try {
      final tips = await _getTips();
      final tip = tips.cast<TipModel?>().firstWhere(
        (tip) => tip?.id == id,
        orElse: () => null,
      );
      return tip?.toEntity();
    } catch (e) {
      throw Exception('Failed to get tip by ID $id: $e');
    }
  }
  
  @override
  Future<List<TipEntity>> searchTips(String query) async {
    try {
      final tips = await _getTips();
      final queryLower = query.toLowerCase();
      
      final filteredTips = tips.where((tip) {
        return tip.title.toLowerCase().contains(queryLower) ||
               tip.description.toLowerCase().contains(queryLower) ||
               tip.steps.any((step) => step.toLowerCase().contains(queryLower)) ||
               tip.tags.any((tag) => tag.toLowerCase().contains(queryLower));
      }).toList();
      
      return filteredTips.map((tip) => tip.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search tips: $e');
    }
  }
  
  @override
  Future<List<TipEntity>> searchTipsByOS(String query, String os) async {
    try {
      final tips = await _getTips();
      final queryLower = query.toLowerCase();
      final osLower = os.toLowerCase();
      
      final filteredTips = tips.where((tip) {
        final matchesOS = tip.os.toLowerCase() == osLower;
        final matchesQuery = tip.title.toLowerCase().contains(queryLower) ||
                           tip.description.toLowerCase().contains(queryLower) ||
                           tip.steps.any((step) => step.toLowerCase().contains(queryLower)) ||
                           tip.tags.any((tag) => tag.toLowerCase().contains(queryLower));
        
        return matchesOS && matchesQuery;
      }).toList();
      
      return filteredTips.map((tip) => tip.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search tips for $os: $e');
    }
  }
  
  @override
  Future<List<int>> getFavoriteTipIds() async {
    try {
      return await _localDataSource.getFavoriteTipIds();
    } catch (e) {
      throw Exception('Failed to get favorite tip IDs: $e');
    }
  }
  
  @override
  Future<void> addToFavorites(int tipId) async {
    try {
      await _localDataSource.addToFavorites(tipId);
    } catch (e) {
      throw Exception('Failed to add tip to favorites: $e');
    }
  }
  
  @override
  Future<void> removeFromFavorites(int tipId) async {
    try {
      await _localDataSource.removeFromFavorites(tipId);
    } catch (e) {
      throw Exception('Failed to remove tip from favorites: $e');
    }
  }
  
  @override
  Future<bool> isFavorite(int tipId) async {
    try {
      return await _localDataSource.isFavorite(tipId);
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }
  
  @override
  Future<List<TipEntity>> getFavoriteTips() async {
    try {
      final favoriteIds = await _localDataSource.getFavoriteTipIds();
      if (favoriteIds.isEmpty) {
        return [];
      }
      
      final tips = await _getTips();
      final favoriteTips = tips
          .where((tip) => favoriteIds.contains(tip.id))
          .toList();
      
      return favoriteTips.map((tip) => tip.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get favorite tips: $e');
    }
  }
  
  @override
  Future<void> refreshTips() async {
    try {
      // Clear cache to force reload from asset
      _cachedTips = null;
      // Preload tips
      await _getTips();
    } catch (e) {
      throw Exception('Failed to refresh tips: $e');
    }
  }
  
  @override
  Future<List<TipEntity>> getTipsByTags(List<String> tags) async {
    try {
      final tips = await _getTips();
      final tagsLower = tags.map((tag) => tag.toLowerCase()).toList();
      
      final filteredTips = tips.where((tip) {
        return tip.tags.any((tag) => tagsLower.contains(tag.toLowerCase()));
      }).toList();
      
      return filteredTips.map((tip) => tip.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get tips by tags: $e');
    }
  }
  
  @override
  Future<List<String>> getAllTags() async {
    try {
      final tips = await _getTips();
      final allTags = <String>{};
      
      for (final tip in tips) {
        allTags.addAll(tip.tags);
      }
      
      final sortedTags = allTags.toList();
      sortedTags.sort();
      return sortedTags;
    } catch (e) {
      throw Exception('Failed to get all tags: $e');
    }
  }
  
  @override
  Future<List<TipEntity>> getPopularTips({int limit = 10}) async {
    try {
      final favoriteIds = await _localDataSource.getFavoriteTipIds();
      final tips = await _getTips();
      
      // Sort tips by favorite count (simulated popularity)
      final tipsWithPopularity = tips.map((tip) {
        final isFavorite = favoriteIds.contains(tip.id);
        return MapEntry(tip, isFavorite ? 1 : 0);
      }).toList();
      
      tipsWithPopularity.sort((a, b) => b.value.compareTo(a.value));
      
      final popularTips = tipsWithPopularity
          .take(limit)
          .map((entry) => entry.key.toEntity())
          .toList();
      
      return popularTips;
    } catch (e) {
      throw Exception('Failed to get popular tips: $e');
    }
  }
  
  @override
  Future<List<TipEntity>> getRecentTips({int limit = 10}) async {
    try {
      final tips = await _getTips();
      
      // Sort by creation date (newest first)
      final sortedTips = List<TipModel>.from(tips);
      sortedTips.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt) ?? DateTime.now();
        final dateB = DateTime.tryParse(b.createdAt) ?? DateTime.now();
        return dateB.compareTo(dateA);
      });
      
      final recentTips = sortedTips
          .take(limit)
          .map((tip) => tip.toEntity())
          .toList();
      
      return recentTips;
    } catch (e) {
      throw Exception('Failed to get recent tips: $e');
    }
  }
}
