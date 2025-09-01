import 'package:flutter/foundation.dart';
import '../../domain/entities/tip_entity.dart';
import '../../domain/usecases/get_tips_by_os_usecase.dart';
import '../../domain/usecases/manage_favorites_usecase.dart';

/// Optimized ViewModel for managing tips state and operations
class TipsViewModel extends ChangeNotifier {
  final GetTipsByOSUseCase _getTipsByOSUseCase;
  final ManageFavoritesUseCase _manageFavoritesUseCase;
  
  TipsViewModel({
    required GetTipsByOSUseCase getTipsByOSUseCase,
    required ManageFavoritesUseCase manageFavoritesUseCase,
  })  : _getTipsByOSUseCase = getTipsByOSUseCase,
        _manageFavoritesUseCase = manageFavoritesUseCase;
  
  // State - optimized for minimal rebuilds
  List<TipEntity> _tips = [];
  List<TipEntity> _filteredTips = [];
  Set<int> _favoriteIds = {}; // Changed to Set for O(1) lookup
  bool _isLoading = false;
  String? _error;
  String _currentOS = '';
  String _searchQuery = '';
  
  // Enhanced cache for instant tab switching
  final Map<String, List<TipEntity>> _tipsCache = {};
  bool _isInitialized = false;
  bool _isInitializing = false; // Prevent multiple simultaneous initializations
  
  // Getters - optimized for performance
  List<TipEntity> get tips => _filteredTips;
  Set<int> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentOS => _currentOS;
  String get searchQuery => _searchQuery;
  bool get hasError => _error != null;
  bool get isEmpty => _filteredTips.isEmpty && !_isLoading;
  bool get hasTips => _tips.isNotEmpty;
  
  /// Initialize and preload all tips for instant switching - Ultra performance optimized
  Future<void> initializeTips() async {
    if (_isInitialized || _isInitializing) return;
    
    _isInitializing = true;
    _setLoading(true);
    
    try {
      // Load all OS tips concurrently for maximum performance
      final futures = await Future.wait([
        _getTipsByOSUseCase('windows'),
        _getTipsByOSUseCase('macos'),
        _getTipsByOSUseCase('linux'),
      ], eagerError: true); // Fail fast if any request fails
      
      // Cache tips by OS for instant access
      _tipsCache['windows'] = futures[0];
      _tipsCache['macos'] = futures[1];
      _tipsCache['linux'] = futures[2];
      
      _isInitialized = true;
      
      // Load favorites in parallel for better performance
      await _loadFavoriteIds();
      
      // Set default OS (Windows) as current tips to display
      _tips = futures[0];
      _currentOS = 'windows';
      _filteredTips = futures[0];
      
      // Single notifyListeners call for optimal performance
      notifyListeners();
    } catch (e) {
      debugPrint('Tips initialization error: $e');
      _setError('Unable to initialize tips. Please restart the app.');
    } finally {
      _setLoading(false);
      _isInitializing = false;
    }
  }
  
  /// Load tips for specific OS (instant from cache) - Ultra performance optimized
  Future<void> loadTipsByOS(String os) async {
    if (os == _currentOS && _tips.isNotEmpty) {
      return; // Already loaded, no need to reload
    }
    
    // If not initialized, initialize first
    if (!_isInitialized) {
      await initializeTips();
      // After initialization, load the requested OS
      if (_tipsCache.containsKey(os)) {
        _tips = _tipsCache[os]!;
        _currentOS = os;
        _filteredTips = _tips;
        notifyListeners();
      }
      return;
    }
    
    // Check if we have cached tips for this OS
    if (_tipsCache.containsKey(os)) {
      // Ultra-fast loading from cache with minimal operations
      _tips = _tipsCache[os]!;
      _currentOS = os;
      _filteredTips = _tips;
      
      // Single notifyListeners call
      notifyListeners();
      return;
    }
    
    // Fallback: load from repository if not in cache
    debugPrint('🔄 Loading from repository for $os...');
    _setLoading(true);
    _clearError();
    _currentOS = os;
    
    try {
      _tips = await _getTipsByOSUseCase(os);
      _tipsCache[os] = _tips; // Cache for next time
      debugPrint('✅ Loaded ${_tips.length} tips for $os');
      
      _filteredTips = _tips;
    } catch (e) {
      debugPrint('❌ Error loading tips for $os: $e');
      _setError('Unable to load tips at the moment. Please try again.');
      _tips = [];
      _filteredTips = [];
    } finally {
      _setLoading(false);
    }
  }
  
  /// Search tips - Ultra optimized for performance
  Future<void> searchTips(String query) async {
    final trimmedQuery = query.trim();
    
    if (trimmedQuery == _searchQuery) {
      return; // Same query, no need to search again
    }
    
    _searchQuery = trimmedQuery;
    
    if (_searchQuery.isEmpty) {
      _filteredTips = _tips;
      notifyListeners();
      return;
    }
    
    if (_searchQuery.length < 2) {
      _filteredTips = _tips; // Show all tips for short queries
      notifyListeners();
      return;
    }
    
    // Simple local search for better performance
    _filteredTips = _tips.where((tip) {
      final title = tip.title.toLowerCase();
      final description = tip.description.toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      
      return title.contains(searchLower) || description.contains(searchLower);
    }).toList();
    
    notifyListeners();
  }
  
  /// Clear search and show all tips
  void clearSearch() {
    if (_searchQuery.isEmpty) return; // Already cleared
    
    _searchQuery = '';
    _filteredTips = _tips;
    notifyListeners();
  }
  
  /// Toggle favorite status of a tip - ultra optimized
  Future<void> toggleFavorite(int tipId) async {
    try {
      final newFavoriteStatus = await _manageFavoritesUseCase.toggleFavorite(tipId);
      
      if (newFavoriteStatus) {
        _favoriteIds.add(tipId);
      } else {
        _favoriteIds.remove(tipId);
      }
      
      // Only notify if the state actually changed
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to toggle favorite: $e');
    }
  }
  
  /// Check if tip is favorite - O(1) lookup
  bool isFavorite(int tipId) {
    return _favoriteIds.contains(tipId);
  }
  
  /// Load favorite tips
  Future<void> loadFavoriteTips() async {
    _setLoading(true);
    _clearError();
    _currentOS = 'favorites';
    
    try {
      _tips = await _manageFavoritesUseCase.getFavoriteTips();
      _filteredTips = List.from(_tips);
      await _loadFavoriteIds();
    } catch (e) {
      _setError('Unable to load favorite tips at the moment. Please try again.');
      _tips = [];
      _filteredTips = [];
    } finally {
      _setLoading(false);
    }
  }
  
  /// Refresh tips - optimized
  Future<void> refresh() async {
    debugPrint('🔄 Refreshing tips for $_currentOS');
    
    // Clear cache to force reload
    _tipsCache.clear();
    _isInitialized = false;
    
    // Reload current OS tips
    await loadTipsByOS(_currentOS);
  }
  
  /// Load favorite IDs - optimized
  Future<void> _loadFavoriteIds() async {
    try {
      final favoriteIds = await _manageFavoritesUseCase.getFavoriteIds();
      _favoriteIds = Set<int>.from(favoriteIds);
    } catch (e) {
      debugPrint('Failed to load favorite IDs: $e');
      _favoriteIds = {};
    }
  }
  
  /// Set loading state - optimized to reduce rebuilds
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }
  
  /// Set error state - optimized to reduce rebuilds
  void _setError(String error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }
  
  /// Clear error state - optimized to reduce rebuilds
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
  
  /// Check if tips are cached for an OS
  bool hasCachedTips(String os) {
    return _tipsCache.containsKey(os) && _tipsCache[os]!.isNotEmpty;
  }
  
  /// Get cached tips count for an OS
  int getCachedTipsCount(String os) {
    return _tipsCache[os]?.length ?? 0;
  }
  
  /// Check if tips are initialized
  bool get isInitialized => _isInitialized;
}

