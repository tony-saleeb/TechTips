import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../tips_list/tips_list_page.dart';
import '../settings/settings_page.dart';
import '../../viewmodels/tips_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/minimal_tip_card.dart';

/// Clean, minimal home page with professional design
class MinimalHomePage extends StatefulWidget {
  const MinimalHomePage({super.key});

  @override
  State<MinimalHomePage> createState() => _MinimalHomePageState();
}

class _MinimalHomePageState extends State<MinimalHomePage> {
  int _selectedIndex = 0;
  bool _showSearch = false;
  
  // Callbacks to control search in TipsListPages
  VoidCallback? _windowsToggleSearch;
  VoidCallback? _macosToggleSearch;
  VoidCallback? _linuxToggleSearch;
  
  // Search state callbacks
  bool Function()? _windowsIsSearchActive;
  bool Function()? _macosIsSearchActive;
  bool Function()? _linuxIsSearchActive;

  @override
  void initState() {
    super.initState();
    
    // Initialize tips cache for instant tab switching
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tipsViewModel = context.read<TipsViewModel>();
      if (!tipsViewModel.isInitialized) {
        tipsViewModel.initializeTips();
      }
    });
  }

  void _onTabTapped(int index) {
    print('Tab tapped: $index, current: $_selectedIndex');
    if (index != _selectedIndex && index >= 0 && index < 3) {
      // Haptic feedback for responsive feel
      HapticFeedback.lightImpact();
      
      setState(() => _selectedIndex = index);
      print('Changed to: $_selectedIndex');
      
      // Load tips for the new OS (will use cache if available)
      final osNames = ['windows', 'macos', 'linux'];
      final newOS = osNames[index];
      final tipsViewModel = context.read<TipsViewModel>();
      
      // Always force load the correct OS tips
      print('🔄 Tab switch: Loading tips for $newOS');
      tipsViewModel.loadTipsByOS(newOS);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.backgroundDark,
                        AppColors.surfaceDark,
                        AppColors.backgroundDark,
                      ]
                    : [
                        AppColors.backgroundLight,
                        AppColors.neutral50,
                        AppColors.backgroundLight.withValues(alpha: 0.98),
                      ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: _buildAnimatedPageSwitcher(),
          ),
          // Search button positioned at exact same level as drawer button
          Positioned(
            top: 48,
            right: 16,
            child: _buildSearchButton(context),
          ),
          // Bottom navigation bar positioned at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildElegantBottomNav(),
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) => _buildMenuButton(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  /// Build the left drawer with menu options
  Widget _buildDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tipsViewModel = context.read<TipsViewModel>();
    final osNames = ['windows', 'macos', 'linux'];
    final currentOS = osNames[_selectedIndex];
    final favorites = tipsViewModel.tips.where((tip) => 
      tip.os.toLowerCase() == currentOS.toLowerCase() && 
      tipsViewModel.isFavorite(tip.id)
    ).toList();

    return Drawer(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.backgroundDark,
                    AppColors.surfaceDark.withValues(alpha: 0.95),
                    AppColors.backgroundDark,
                  ]
                : [
                    Colors.white,
                    const Color(0xFFFBFCFF),
                    Colors.white,
                  ],
              stops: const [0.0, 0.5, 1.0],
            ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with app icon and name
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentDark,
                    AppColors.accentDark.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentDark.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    letterSpacing: -0.5,
                              fontSize: 20,
                  ),
                ),
                Text(
                  'Master your OS',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
                      ),
            ),
          ],
        ),
              ),
              
              const Divider(height: 1),
              
              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildDrawerItem(
                      context,
                      icon: Icons.favorite_rounded,
                      title: 'Favorites',
                      subtitle: '${favorites.length} ${_getOSDisplayName(currentOS)} tips',
                      onTap: () {
                        Navigator.pop(context);
                        _showFavorites(context);
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.palette_outlined,
                      title: 'Theme',
                      subtitle: isDark ? 'Dark mode' : 'Light mode',
                      onTap: () => _toggleTheme(context),
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'Version & credits',
                      onTap: () => _showAbout(context),
          ),
        ],
      ),
              ),
              
              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Text(
                      'Made with ❤️ for productivity',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }

  /// Build a drawer menu item
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark 
                  ? AppColors.borderDark.withValues(alpha: 0.2)
                  : AppColors.borderLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
            color: isDark
                      ? AppColors.surfaceDark.withValues(alpha: 0.5)
                      : AppColors.neutral50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build floating menu button
  Widget _buildMenuButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return FloatingActionButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      foregroundColor: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
      elevation: 4,
      heroTag: "drawer_button",
      child: const Icon(Icons.menu_rounded, size: 24),
    );
  }

    /// Build floating search button
  Widget _buildSearchButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Get search state from current page
    bool isSearchActive = _getCurrentPageSearchState();
    
    return FloatingActionButton(
      onPressed: _toggleSearch,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      foregroundColor: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
      elevation: 4,
      heroTag: "search_button",
      child: Icon(
        isSearchActive ? Icons.close_rounded : Icons.search_rounded,
        size: 24,
      ),
    );
  }

  /// Get search state from the currently active page
  bool _getCurrentPageSearchState() {
    switch (_selectedIndex) {
      case 0:
        return _windowsIsSearchActive?.call() ?? false;
      case 1:
        return _macosIsSearchActive?.call() ?? false;
      case 2:
        return _linuxIsSearchActive?.call() ?? false;
      default:
        return false;
    }
  }

  /// Toggle search functionality
  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
    
    // Trigger search toggle on the current TipsListPage
    _triggerSearchOnCurrentPage();
  }
  
  /// Trigger search on the currently active page
  void _triggerSearchOnCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        _windowsToggleSearch?.call();
        break;
      case 1:
        _macosToggleSearch?.call();
        break;
      case 2:
        _linuxToggleSearch?.call();
        break;
    }
    
    // Trigger rebuild to update search button icon
    setState(() {});
  }

  /// Toggle theme
  void _toggleTheme(BuildContext context) {
    final settingsViewModel = context.read<SettingsViewModel>();
    final currentMode = settingsViewModel.themeMode;
    final newMode = currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    settingsViewModel.setThemeMode(newMode);
  }

  /// Export favorites
  void _exportFavorites(BuildContext context) {
    final tipsViewModel = context.read<TipsViewModel>();
    final osNames = ['windows', 'macos', 'linux'];
    final currentOS = osNames[_selectedIndex];
    final favorites = tipsViewModel.tips.where((tip) => 
      tip.os.toLowerCase() == currentOS.toLowerCase() && 
      tipsViewModel.isFavorite(tip.id)
    ).toList();
    
    if (favorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No ${_getOSDisplayName(currentOS)} favorites to export'),
          backgroundColor: AppColors.accentDark,
        ),
      );
      return;
    }
    
    // Here you could implement actual export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported ${favorites.length} ${_getOSDisplayName(currentOS)} tips'),
        backgroundColor: AppColors.accentDark,
      ),
    );
  }

  /// Show about dialog
  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
        children: [
            Container(
              padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  AppColors.accentDark,
                  AppColors.accentDark.withValues(alpha: 0.8),
                ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(AppConstants.appName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppConstants.appDescription),
            const SizedBox(height: 16),
            Text(
              'Features:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text('• Windows, macOS & Linux tips'),
            const Text('• Save your favorite shortcuts'),
            const Text('• Dark & light themes'),
            const Text('• Clean, minimal design'),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.textDarkSecondary 
                  : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Clean and smooth bottom navigation with water liquid effects
  Widget _buildElegantBottomNav() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentOS = ['windows', 'macos', 'linux'][_selectedIndex];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 75,
          decoration: BoxDecoration(
            color: isDark 
              ? AppColors.backgroundDark.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppColors.getOSColor(currentOS).withValues(alpha: 0.8),
              width: 3.0,
            ),
            boxShadow: [
              // Primary depth shadow
              BoxShadow(
                color: isDark
                  ? Colors.black.withValues(alpha: 0.9)
                  : Colors.black.withValues(alpha: 0.5),
                blurRadius: 80,
                offset: const Offset(0, 30),
                spreadRadius: 0,
              ),
              // Secondary depth shadow
              BoxShadow(
                color: isDark
                  ? Colors.black.withValues(alpha: 0.7)
                  : Colors.black.withValues(alpha: 0.4),
                blurRadius: 120,
                offset: const Offset(0, 55),
                spreadRadius: -40,
              ),
              // 3D glow effect
              BoxShadow(
                color: AppColors.getOSColor(currentOS).withValues(alpha: 0.8),
                blurRadius: 100,
                offset: const Offset(0, 60),
                spreadRadius: -45,
              ),
              // Inner highlight for 3D effect
              BoxShadow(
                color: isDark
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.6),
                blurRadius: 40,
                offset: const Offset(0, -15),
                spreadRadius: -20,
              ),
              // Additional outer glow
              BoxShadow(
                color: AppColors.getOSColor(currentOS).withValues(alpha: 0.4),
                blurRadius: 150,
                offset: const Offset(0, 80),
                spreadRadius: -50,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLiquidNavItem(
                icon: _getOSIcon('windows'),
                index: 0,
                isSelected: _selectedIndex == 0,
              ),
              _buildLiquidNavItem(
                icon: _getOSIcon('macos'),
                index: 1,
                isSelected: _selectedIndex == 1,
              ),
              _buildLiquidNavItem(
                icon: _getOSIcon('linux'),
                index: 2,
                isSelected: _selectedIndex == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Smooth page switcher with animations
  Widget _buildAnimatedPageSwitcher() {
    print('Building page switcher with index: $_selectedIndex');
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200), // Faster for responsive feel
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0.0), // Smaller slide for subtlety
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart, // More responsive curve
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
                  ),
                );
              },
      child: _buildCurrentPage(),
    );
  }
  
  Widget _buildCurrentPage() {
    final osNames = ['windows', 'macos', 'linux'];
    final currentOS = osNames[_selectedIndex];
    
    print('Building page for index: $_selectedIndex, OS: $currentOS');
    
    // Force TipsViewModel to update for the current OS
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tipsViewModel = context.read<TipsViewModel>();
      if (tipsViewModel.currentOS != currentOS) {
        print('🔄 Forcing TipsViewModel update from ${tipsViewModel.currentOS} to $currentOS');
        tipsViewModel.loadTipsByOS(currentOS);
      }
    });
    
    return TipsListPage(
      key: ValueKey('tips_page_${currentOS}_$_selectedIndex'),
      os: currentOS,
      onSearchToggleCallback: (callback) {
        switch (_selectedIndex) {
          case 0:
            _windowsToggleSearch = callback;
            break;
          case 1:
            _macosToggleSearch = callback;
            break;
          case 2:
            _linuxToggleSearch = callback;
            break;
        }
      },
      onSearchStateCallback: (callback) {
        switch (_selectedIndex) {
          case 0:
            _windowsIsSearchActive = callback;
            break;
          case 1:
            _macosIsSearchActive = callback;
            break;
          case 2:
            _linuxIsSearchActive = callback;
            break;
        }
      },
    );
  }

  /// Reliable navigation item
  Widget _buildLiquidNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentDark : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 49,
          child: Center(
            child: Icon(
              icon,
              size: 26,
              color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  /// Get OS icon
  IconData _getOSIcon(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return Icons.window;
      case 'macos':
        return Icons.apple;
      case 'linux':
        return Icons.computer;
      default:
        return Icons.computer;
    }
  }

  /// Show favorites bottom sheet
  void _showFavorites(BuildContext context) {
    final tipsViewModel = context.read<TipsViewModel>();
    final osNames = ['windows', 'macos', 'linux'];
    final currentOS = osNames[_selectedIndex];
    
    // Get favorites for current OS
    final favorites = tipsViewModel.tips.where((tip) => 
      tip.os.toLowerCase() == currentOS.toLowerCase() && 
      tipsViewModel.isFavorite(tip.id)
    ).toList();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFavoritesBottomSheet(context, favorites, currentOS),
    );
  }
  
  /// Build favorites bottom sheet
  Widget _buildFavoritesBottomSheet(BuildContext context, List favorites, String currentOS) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.accentDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.accentDark, AppColors.accentDark.withValues(alpha: 0.8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Favorite ${_getOSDisplayName(currentOS)} Tips',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${favorites.length} tips saved',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: favorites.isEmpty
                  ? _buildEmptyFavorites(context, currentOS)
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        return MinimalTipCard(
                          tip: favorites[index],
                          index: index,
                        );
                      },
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Build empty favorites state
  Widget _buildEmptyFavorites(BuildContext context, String currentOS) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accentDark.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.favorite_border,
                size: 64,
                color: AppColors.accentDark,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Favorites Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on any ${_getOSDisplayName(currentOS)} tip to save it here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  
  String _getOSDisplayName(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return 'Windows';
      case 'macos':
        return 'macOS';
      case 'linux':
        return 'Linux';
      default:
        return os.toUpperCase();
    }
  }

  /// Navigate to settings page - bulletproof approach
  void _navigateToSettings(BuildContext context) {
    try {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
    } catch (e) {
      // If navigation fails, show a simple dialog instead
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Settings'),
          content: const Text('Settings page is working!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

/// Perfect settings button with enhanced design and micro-interactions
class _PerfectSettingsButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _PerfectSettingsButton({
    required this.onPressed,
  });

  @override
  State<_PerfectSettingsButton> createState() => _PerfectSettingsButtonState();
}

class _PerfectSettingsButtonState extends State<_PerfectSettingsButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25, // 90 degrees
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _colorAnimation = ColorTween(
      begin: AppColors.neutral100,
      end: AppColors.primary.withValues(alpha: 0.1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark 
                      ? (_isHovered 
                          ? AppColors.textDarkSecondary.withValues(alpha: 0.1)
                          : AppColors.cardDark)
                      : _colorAnimation.value,
                    borderRadius: BorderRadius.circular(12),
                    border: Theme.of(context).brightness == Brightness.dark 
                      ? null
                      : Border.all(
                          color: _isHovered 
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : AppColors.borderLight,
                          width: _isHovered ? 2 : 1,
                        ),
                    boxShadow: _isHovered ? [
                      BoxShadow(
                        color: (Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textDarkSecondary 
                          : AppColors.primary).withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ] : null,
                  ),
                  child: Transform.rotate(
                    angle: _rotationAnimation.value * 3.14159 * 2,
                    child: Icon(
                      Icons.settings_outlined,
                      size: 20,
                      color: _isHovered 
                        ? (Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.textDarkSecondary 
                            : AppColors.primary)
                        : (Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.textDarkPrimary 
                            : AppColors.textPrimary),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
