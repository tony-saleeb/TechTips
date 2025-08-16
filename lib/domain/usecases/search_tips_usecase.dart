import '../entities/tip_entity.dart';
import '../repositories/tip_repository.dart';

/// Use case for searching tips
class SearchTipsUseCase {
  final TipRepository _repository;
  
  const SearchTipsUseCase(this._repository);
  
  /// Search tips globally
  Future<List<TipEntity>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    
    if (query.trim().length < 2) {
      throw ArgumentError('Search query must be at least 2 characters long');
    }
    
    try {
      final tips = await _repository.searchTips(query.trim());
      
      // Sort by relevance (title matches first, then description matches)
      tips.sort((a, b) {
        final queryLower = query.toLowerCase();
        final aTitleMatch = a.title.toLowerCase().contains(queryLower);
        final bTitleMatch = b.title.toLowerCase().contains(queryLower);
        
        if (aTitleMatch && !bTitleMatch) return -1;
        if (!aTitleMatch && bTitleMatch) return 1;
        
        // If both or neither match title, sort by creation date
        return b.createdAt.compareTo(a.createdAt);
      });
      
      return tips;
    } catch (e) {
      throw Exception('Failed to search tips: $e');
    }
  }
  
  /// Search tips within specific OS
  Future<List<TipEntity>> searchByOS(String query, String os) async {
    if (query.trim().isEmpty) {
      return [];
    }
    
    if (query.trim().length < 2) {
      throw ArgumentError('Search query must be at least 2 characters long');
    }
    
    if (os.isEmpty) {
      throw ArgumentError('OS parameter cannot be empty');
    }
    
    try {
      final tips = await _repository.searchTipsByOS(query.trim(), os.toLowerCase());
      
      // Sort by relevance
      tips.sort((a, b) {
        final queryLower = query.toLowerCase();
        final aTitleMatch = a.title.toLowerCase().contains(queryLower);
        final bTitleMatch = b.title.toLowerCase().contains(queryLower);
        
        if (aTitleMatch && !bTitleMatch) return -1;
        if (!aTitleMatch && bTitleMatch) return 1;
        
        return b.createdAt.compareTo(a.createdAt);
      });
      
      return tips;
    } catch (e) {
      throw Exception('Failed to search tips for $os: $e');
    }
  }
}
