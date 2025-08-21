import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tip_model.dart';
import '../../core/constants/app_constants.dart';

/// Local data source for tips and app data
class LocalDataSource {
  static const String _tipsAssetPath = 'assets/data/tips.json';
  
  /// Load tips from local JSON asset
  Future<List<TipModel>> loadTipsFromAsset() async {
    try {
      debugPrint('🔍 DataSource: Loading tips from asset: $_tipsAssetPath');
      final String jsonString = await rootBundle.loadString(_tipsAssetPath);
              debugPrint('🔍 DataSource: JSON string length: ${jsonString.length}');
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
              debugPrint('🔍 DataSource: JSON parsed successfully');
      
      if (jsonData['tips'] == null) {
        debugPrint('❌ DataSource: No tips found in JSON data');
        throw Exception('No tips found in JSON data');
      }
      
      final List<dynamic> tipsJson = jsonData['tips'];
              debugPrint('🔍 DataSource: Found ${tipsJson.length} tips in JSON');
      
      final tips = tipsJson.map((json) => TipModel.fromJson(json)).toList();
              debugPrint('🔍 DataSource: Successfully parsed ${tips.length} tip models');
      
              // Print first few tips for debugging
        for (int i = 0; i < tips.take(3).length; i++) {
          debugPrint('🔍 DataSource: Tip ${i + 1}: ${tips[i].title} (${tips[i].os})');
        }
      
      return tips;
    } catch (e) {
      debugPrint('❌ DataSource: Failed to load tips from asset: $e');
      throw Exception('Failed to load tips from asset: $e');
    }
  }
  
  /// Get favorite tip IDs from SharedPreferences
  Future<List<int>> getFavoriteTipIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? favoriteIds = prefs.getStringList(AppConstants.favoritesKey);
      
      if (favoriteIds == null) {
        return [];
      }
      
      return favoriteIds
          .map((id) => int.tryParse(id))
          .where((id) => id != null)
          .cast<int>()
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorite tip IDs: $e');
    }
  }
  
  /// Save favorite tip IDs to SharedPreferences
  Future<void> saveFavoriteTipIds(List<int> tipIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> favoriteIds = tipIds.map((id) => id.toString()).toList();
      await prefs.setStringList(AppConstants.favoritesKey, favoriteIds);
    } catch (e) {
      throw Exception('Failed to save favorite tip IDs: $e');
    }
  }
  
  /// Add tip ID to favorites
  Future<void> addToFavorites(int tipId) async {
    try {
      final currentFavorites = await getFavoriteTipIds();
      if (!currentFavorites.contains(tipId)) {
        currentFavorites.add(tipId);
        await saveFavoriteTipIds(currentFavorites);
      }
    } catch (e) {
      throw Exception('Failed to add tip to favorites: $e');
    }
  }
  
  /// Remove tip ID from favorites
  Future<void> removeFromFavorites(int tipId) async {
    try {
      final currentFavorites = await getFavoriteTipIds();
      currentFavorites.remove(tipId);
      await saveFavoriteTipIds(currentFavorites);
    } catch (e) {
      throw Exception('Failed to remove tip from favorites: $e');
    }
  }
  
  /// Check if tip is in favorites
  Future<bool> isFavorite(int tipId) async {
    try {
      final favorites = await getFavoriteTipIds();
      return favorites.contains(tipId);
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }
  
  /// Get theme mode from SharedPreferences
  Future<String?> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.themeKey);
    } catch (e) {
      throw Exception('Failed to get theme mode: $e');
    }
  }
  
  /// Save theme mode to SharedPreferences
  Future<void> saveThemeMode(String themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.themeKey, themeMode);
    } catch (e) {
      throw Exception('Failed to save theme mode: $e');
    }
  }
  
  /// Get font size from SharedPreferences
  Future<double?> getFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(AppConstants.fontSizeKey);
    } catch (e) {
      throw Exception('Failed to get font size: $e');
    }
  }
  
  /// Save font size to SharedPreferences
  Future<void> saveFontSize(double fontSize) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(AppConstants.fontSizeKey, fontSize);
    } catch (e) {
      throw Exception('Failed to save font size: $e');
    }
  }
  
  /// Get appearance size from SharedPreferences
  Future<double?> getAppearanceSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble('appearance_size');
    } catch (e) {
      throw Exception('Failed to get appearance size: $e');
    }
  }
  
  /// Save appearance size to SharedPreferences
  Future<void> saveAppearanceSize(double appearanceSize) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('appearance_size', appearanceSize);
    } catch (e) {
      throw Exception('Failed to save appearance size: $e');
    }
  }
  
  /// Clear all stored preferences
  Future<void> clearAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Failed to clear preferences: $e');
    }
  }
  
  /// Get all preferences as a map
  Future<Map<String, dynamic>> getAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final Map<String, dynamic> preferences = {};
      
      for (final key in keys) {
        final value = prefs.get(key);
        preferences[key] = value;
      }
      
      return preferences;
    } catch (e) {
      throw Exception('Failed to get all preferences: $e');
    }
  }
  
  /// Set preferences from a map
  Future<void> setAllPreferences(Map<String, dynamic> preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      for (final entry in preferences.entries) {
        final key = entry.key;
        final value = entry.value;
        
        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        }
      }
    } catch (e) {
      throw Exception('Failed to set preferences: $e');
    }
  }
}
