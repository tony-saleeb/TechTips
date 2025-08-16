import 'package:flutter/foundation.dart';
import '../../domain/entities/tip_entity.dart';
import '../../domain/usecases/get_tips_by_os_usecase.dart';
import '../../domain/usecases/search_tips_usecase.dart';
import '../../domain/usecases/manage_favorites_usecase.dart';

/// ViewModel for managing tips state and operations
class TipsViewModel extends ChangeNotifier {
  final GetTipsByOSUseCase _getTipsByOSUseCase;
  final SearchTipsUseCase _searchTipsUseCase;
  final ManageFavoritesUseCase _manageFavoritesUseCase;
  
  TipsViewModel({
    required GetTipsByOSUseCase getTipsByOSUseCase,
    required SearchTipsUseCase searchTipsUseCase,
    required ManageFavoritesUseCase manageFavoritesUseCase,
  })  : _getTipsByOSUseCase = getTipsByOSUseCase,
        _searchTipsUseCase = searchTipsUseCase,
        _manageFavoritesUseCase = manageFavoritesUseCase;
  
  // State
  List<TipEntity> _tips = [];
  List<TipEntity> _filteredTips = [];
  List<int> _favoriteIds = [];
  bool _isLoading = false;
  String? _error;
  String _currentOS = '';
  String _searchQuery = '';
  
  // Getters
  List<TipEntity> get tips => _filteredTips;
  List<int> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentOS => _currentOS;
  String get searchQuery => _searchQuery;
  bool get hasError => _error != null;
  bool get isEmpty => _filteredTips.isEmpty && !_isLoading;
  
  /// Load tips for specific OS
  Future<void> loadTipsByOS(String os) async {
    if (os == _currentOS && _tips.isNotEmpty) {
      return; // Already loaded for this OS
    }
    
    _setLoading(true);
    _clearError();
    _currentOS = os;
    
    try {
      _tips = await _getTipsByOSUseCase(os);
      _applySearch(); // Apply current search filter
      await _loadFavoriteIds();
    } catch (e) {
      _setError('Failed to load tips: ${e.toString()}');
      _tips = [];
      _filteredTips = [];
    } finally {
      _setLoading(false);
    }
  }
  
  /// Search tips
  Future<void> searchTips(String query) async {
    _searchQuery = query.trim();
    
    if (_searchQuery.isEmpty) {
      _filteredTips = List.from(_tips);
      notifyListeners();
      return;
    }
    
    if (_searchQuery.length < 2) {
      return; // Don't search for queries less than 2 characters
    }
    
    _setLoading(true);
    _clearError();
    
    try {
      if (_currentOS.isNotEmpty) {
        _filteredTips = await _searchTipsUseCase.searchByOS(_searchQuery, _currentOS);
      } else {
        _filteredTips = await _searchTipsUseCase(_searchQuery);
      }
    } catch (e) {
      _setError('Failed to search tips: ${e.toString()}');
      _filteredTips = [];
    } finally {
      _setLoading(false);
    }
  }
  
  /// Clear search and show all tips
  void clearSearch() {
    _searchQuery = '';
    _applySearch();
  }
  
  /// Toggle favorite status of a tip
  Future<void> toggleFavorite(int tipId) async {
    try {
      final newFavoriteStatus = await _manageFavoritesUseCase.toggleFavorite(tipId);
      
      if (newFavoriteStatus) {
        if (!_favoriteIds.contains(tipId)) {
          _favoriteIds.add(tipId);
        }
      } else {
        _favoriteIds.remove(tipId);
      }
      
      notifyListeners();
    } catch (e) {
      // Don't show error for favorite toggle failures, just log it
      debugPrint('Failed to toggle favorite: $e');
    }
  }
  
  /// Check if tip is favorite
  bool isFavorite(int tipId) {
    return _favoriteIds.contains(tipId);
  }
  
  /// Load favorite tips
  Future<void> loadFavoriteTips() async {
    _setLoading(true);
    _clearError();
    _currentOS = 'favorites'; // Special identifier for favorites view
    
    try {
      _tips = await _manageFavoritesUseCase.getFavoriteTips();
      _filteredTips = List.from(_tips);
      await _loadFavoriteIds();
    } catch (e) {
      _setError('Failed to load favorite tips: ${e.toString()}');
      _tips = [];
      _filteredTips = [];
    } finally {
      _setLoading(false);
    }
  }
  
  /// Refresh current tips
  Future<void> refresh() async {
    if (_currentOS == 'favorites') {
      await loadFavoriteTips();
    } else if (_currentOS.isNotEmpty) {
      // Clear cache and reload
      _tips.clear();
      _filteredTips.clear();
      await loadTipsByOS(_currentOS);
    }
  }
  
  /// Load favorite IDs
  Future<void> _loadFavoriteIds() async {
    try {
      _favoriteIds = await _manageFavoritesUseCase.getFavoriteIds();
      notifyListeners();
    } catch (e) {
      // Don't show error for favorites loading failure
      debugPrint('Failed to load favorite IDs: $e');
    }
  }
  
  /// Apply current search filter to tips
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredTips = List.from(_tips);
    } else {
      _filteredTips = _tips.where((tip) {
        final query = _searchQuery.toLowerCase();
        return tip.title.toLowerCase().contains(query) ||
               tip.description.toLowerCase().contains(query) ||
               tip.steps.any((step) => step.toLowerCase().contains(query)) ||
               tip.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }
    notifyListeners();
  }
  
  /// Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }
  
  /// Set error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  /// Clear error state
  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
  
  /// Get tip by ID
  TipEntity? getTipById(int id) {
    try {
      return _tips.firstWhere((tip) => tip.id == id);
    } catch (e) {
      return null;
    }
  }
}
