import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../tips_list/tips_list_page.dart';
import '../../viewmodels/tips_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/minimal_tip_card.dart';

/// Optimized home page with smooth performance
class MinimalHomePage extends StatefulWidget {
  const MinimalHomePage({super.key});

  @override
  State<MinimalHomePage> createState() => _MinimalHomePageState();
}

class _MinimalHomePageState extends State<MinimalHomePage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showSearch = false;
  late PageController _pageController;
  
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
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _selectedIndex && index >= 0 && index < 3) {
      // Haptic feedback for responsive feel
      HapticFeedback.lightImpact();
      
      // Instant page transition for better performance
      _pageController.jumpToPage(index);
    }
  }

  void _onPageChanged(int index) {
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
      
      // Update tips for the new OS - optimized
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTipsForIndex(index);
      });
    }
  }

  void _updateTipsForIndex(int index) {
    final osNames = ['windows', 'macos', 'linux'];
    final newOS = osNames[index];
    final tipsViewModel = context.read<TipsViewModel>();
    
    tipsViewModel.loadTipsByOS(newOS);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      drawer: _buildDrawer(context),
      drawerEdgeDragWidth: 80, // Increase drag area for easier closing
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // App bar
              _buildStaticAppBar(context),
              
              // PageView for tabs - Optimized for performance
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const ClampingScrollPhysics(), // Better performance than BouncingScrollPhysics
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final os = ['windows', 'macos', 'linux'][index];
                    return RepaintBoundary(
                      child: _buildTipsListPage(index, os),
                    );
                  },
                ),
              ),
            ],
          ),
          
          // Floating buttons - Optimized with RepaintBoundary
          Positioned(
            top: MediaQuery.of(context).padding.top + context.rp(8),
            left: context.rp(16),
            child: RepaintBoundary(
              child: _buildMenuButton(context),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + context.rp(8),
            right: context.rp(16),
            child: RepaintBoundary(
              child: _buildSearchButton(context),
            ),
          ),
          
          // Bottom navigation - Optimized with RepaintBoundary
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RepaintBoundary(
              child: _buildElegantBottomNav(),
            ),
          ),
        ],
      ),
    );
  }

  /// Build static app bar with OS title
  Widget _buildStaticAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentOS = ['windows', 'macos', 'linux'][_selectedIndex];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                Colors.white.withValues(alpha: 0.2),
                AppColors.getOSColor(currentOS).withValues(alpha: 0.18),
                Colors.white.withValues(alpha: 0.12),
              ]
            : [
                Colors.white.withValues(alpha: 0.9),
                AppColors.getOSColor(currentOS).withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.8),
              ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(context.rbr(50)),
          bottomRight: Radius.circular(context.rbr(50)),
        ),
        border: Border.all(
          color: isDark 
            ? AppColors.getOSColor(currentOS).withValues(alpha: 0.5)
            : AppColors.getOSColor(currentOS).withValues(alpha: 0.35),
          width: context.rw(1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
              ? Colors.black.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: context.rse(horizontal: 20, vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              context.rsb(width: 40),
              Expanded(
                child: Center(
                  child: _buildModernTitle(currentOS),
                ),
              ),
              context.rsb(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Build modern title with OS-specific styling
  Widget _buildModernTitle(String currentOS) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: context.rse(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.08),
              ]
            : [
                Colors.white.withValues(alpha: 0.98),
                Colors.white.withValues(alpha: 0.95),
                Colors.white.withValues(alpha: 0.9),
              ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(context.rbr(20)),
        border: Border.all(
          color: isDark 
            ? Colors.white.withValues(alpha: 0.3)
            : AppColors.getOSColor(currentOS).withValues(alpha: 0.4),
          width: context.rw(2.0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
              ? Colors.black.withValues(alpha: 0.4)
              : Colors.black.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.getOSColor(currentOS).withValues(alpha: 0.3),
            blurRadius: 35,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.getOSColor(currentOS).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 0),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                  ? [
                      Colors.grey.shade900,
                      Colors.grey.shade800,
                      Colors.grey.shade900,
                    ]
                  : [
                      Colors.grey.shade800,
                      Colors.grey.shade700,
                      Colors.grey.shade900,
                    ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark 
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: isDark 
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _getOSIcon(currentOS),
              color: Colors.white,
              size: context.ri(20),
            ),
          ),
          
          context.rsb(width: 12),
          
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                ? [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.95),
                    Colors.white.withValues(alpha: 0.9),
                  ]
                : [
                    AppColors.getOSColor(currentOS),
                    AppColors.getOSColor(currentOS).withValues(alpha: 0.9),
                    AppColors.getOSColor(currentOS).withValues(alpha: 0.8),
                  ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds),
            child: Text(
              '${_getOSDisplayName(currentOS)} Tips',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.6,
                fontSize: context.rs(18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build TipsListPage for each OS
  Widget _buildTipsListPage(int index, String os) {
    return TipsListPage(
      key: ValueKey('tips_page_$os'),
      os: os,
      onSearchToggleCallback: (callback) {
        switch (index) {
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
        switch (index) {
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

  /// Build the left drawer with menu options - Optimized for smooth performance
  Widget _buildDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final osNames = ['windows', 'macos', 'linux'];
    final currentOS = osNames[_selectedIndex];
    
        return Drawer(
        backgroundColor: Colors.transparent,
      elevation: 0, // Remove default elevation for smoother animation
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                ? [
                    AppColors.backgroundDark,
                    AppColors.surfaceDark.withValues(alpha: 0.95),
                    AppColors.backgroundDark.withValues(alpha: 0.98),
                  ]
                : [
                    Colors.white,
                    const Color(0xFFFBFCFF),
                    Colors.white.withValues(alpha: 0.98),
                  ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(2, 0),
                spreadRadius: 1,
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
          children: [
                                 // Header - Static content
            Container(
                   margin: const EdgeInsets.all(20),
                   padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                        ? [
                    AppColors.accentDark.withValues(alpha: 0.8),
                            AppColors.accentDark.withValues(alpha: 0.6),
                            AppColors.accentDark.withValues(alpha: 0.7),
                          ]
                        : [
                            AppColors.neutral50.withValues(alpha: 0.9),
                            AppColors.neutral100.withValues(alpha: 0.7),
                            AppColors.neutral50.withValues(alpha: 0.8),
                          ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark 
                        ? AppColors.accentDark.withValues(alpha: 0.5)
                        : AppColors.accentDark.withValues(alpha: 0.3),
                      width: 2,
                    ),
                boxShadow: [
                  BoxShadow(
                        color: isDark 
                          ? AppColors.accentDark.withValues(alpha: 0.2)
                          : AppColors.accentDark.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                        spreadRadius: 0,
                  ),
                ],
              ),
                                     child: Row(
                     children: [
                       Icon(
                         Icons.terminal_rounded,
                         color: isDark 
                           ? Colors.white
                           : AppColors.accentDark,
                         size: 40,
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                               style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                 fontWeight: FontWeight.w800,
                                 color: isDark 
                                   ? Colors.white
                      : AppColors.textPrimary,
                    letterSpacing: -0.5,
                                 fontSize: 20,
                  ),
                ),
                             const SizedBox(height: 4),
                Text(
                  'Master your OS',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                 color: isDark 
                                   ? Colors.white.withValues(alpha: 0.8)
                      : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                                 fontSize: 14,
                  ),
                ),
              ],
                         ),
                       ),
                       // Close button
                       GestureDetector(
                         onTap: () => Navigator.of(context).pop(),
                         child: Container(
                           padding: const EdgeInsets.all(8),
                           decoration: BoxDecoration(
                             color: isDark 
                               ? Colors.white.withValues(alpha: 0.1)
                               : Colors.black.withValues(alpha: 0.05),
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child: Icon(
                             Icons.close_rounded,
                             size: 20,
                             color: isDark 
                               ? Colors.white.withValues(alpha: 0.8)
                               : Colors.black.withValues(alpha: 0.6),
                           ),
                         ),
            ),
          ],
        ),
                ),
                
                // Menu items - Only favorites count updates
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    children: [
                      // Favorites item with optimized rebuild
                      _buildFavoritesDrawerItem(context, currentOS),
                      _buildPremiumDrawerItem(
                        context,
                        icon: Icons.palette_outlined,
                        title: 'Theme',
                        subtitle: 'Light, dark, or system',
                        onTap: () {
                          Navigator.of(context).pop(); // Close drawer first
                          _toggleTheme(context);
                        },
                      ),
                      _buildAppearanceSizeDrawerItem(context),
                      _buildPremiumDrawerItem(
                        context,
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'Version & credits',
                        onTap: () {
                          Navigator.of(context).pop(); // Close drawer first
                          _showAbout(context);
                        },
          ),
        ],
      ),
                ),
                
                // Footer - Static content
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
                      colors: isDark
                        ? [
                            AppColors.surfaceDark.withValues(alpha: 0.8),
                            AppColors.surfaceDark.withValues(alpha: 0.6),
                            AppColors.surfaceDark.withValues(alpha: 0.7),
                          ]
                        : [
                            AppColors.neutral50.withValues(alpha: 0.9),
                            AppColors.neutral100.withValues(alpha: 0.7),
                            AppColors.neutral50.withValues(alpha: 0.8),
                ],
            stops: const [0.0, 0.5, 1.0],
          ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark 
                        ? AppColors.borderDark.withValues(alpha: 0.4)
                        : AppColors.accentDark.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Made with ❤️ By Antony Saleeb',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark 
                            ? Colors.white.withValues(alpha: 0.95)
                            : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          fontSize: 14,
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
      ),
    );
  }

  /// Build optimized floating menu button - No animations for smooth performance
  Widget _buildMenuButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentOS = ['windows', 'macos', 'linux'][_selectedIndex];
    
    return Builder(
      builder: (BuildContext context) {
    return Container(
          width: context.rw(56),
          height: context.rh(56),
      decoration: BoxDecoration(
        gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
          colors: isDark
            ? [
                    Colors.white.withValues(alpha: 0.35),
                    Colors.white.withValues(alpha: 0.25),
                    Colors.white.withValues(alpha: 0.15),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.98),
                Colors.white.withValues(alpha: 0.95),
                    Colors.white.withValues(alpha: 0.9),
              ],
          stops: const [0.0, 0.5, 1.0],
        ),
            borderRadius: BorderRadius.circular(context.rbr(20)),
            border: Border.all(
              color: isDark 
                ? Colors.white.withValues(alpha: 0.4)
                : AppColors.getOSColor(currentOS).withValues(alpha: 0.6),
              width: context.rw(2.0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                Scaffold.of(context).openDrawer();
              },
              borderRadius: BorderRadius.circular(context.rbr(20)),
              child: SizedBox(
                width: context.rw(56),
                height: context.rh(56),
                child: Center(
                  child: Icon(
                    Icons.menu_rounded,
                    size: context.ri(26),
                    color: isDark 
                      ? Colors.white.withValues(alpha: 0.95) 
                      : AppColors.getOSColor(currentOS),
                  ),
                ),
          ),
        ),
      ),
        );
      },
    );
  }

  /// Build optimized floating search button - Minimal animations for smooth performance
  Widget _buildSearchButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentOS = ['windows', 'macos', 'linux'][_selectedIndex];
    
    bool isSearchActive = _getCurrentPageSearchState();
    
    return Container(
      width: context.rw(56),
      height: context.rh(56),
        decoration: BoxDecoration(
        gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
          colors: isDark
            ? [
                Colors.white.withValues(alpha: 0.35),
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.15),
              ]
            : [
                Colors.white.withValues(alpha: 0.98),
                Colors.white.withValues(alpha: 0.95),
                Colors.white.withValues(alpha: 0.9),
              ],
          stops: const [0.0, 0.5, 1.0],
        ),
          borderRadius: BorderRadius.circular(context.rbr(20)),
          border: Border.all(
          color: isDark 
            ? Colors.white.withValues(alpha: 0.4)
            : AppColors.getOSColor(currentOS).withValues(alpha: 0.6),
          width: context.rw(2.0),
        ),
        boxShadow: [
                BoxShadow(
            color: isDark 
              ? Colors.black.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _toggleSearch();
          },
          borderRadius: BorderRadius.circular(context.rbr(20)),
                      child: SizedBox(
              width: context.rw(56),
              height: context.rh(56),
              child: Center(
                child: Icon(
                  isSearchActive ? Icons.close_rounded : Icons.search_rounded,
                  size: context.ri(26),
                  color: isSearchActive 
                    ? AppColors.getOSColor(currentOS)
                    : (isDark ? Colors.white.withValues(alpha: 0.95) : AppColors.getOSColor(currentOS)),
                ),
              ),
          ),
        ),
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
    
    setState(() {});
  }

  /// Toggle theme
  void _toggleTheme(BuildContext context) {
    final settingsViewModel = context.read<SettingsViewModel>();
    final currentMode = settingsViewModel.themeMode;
    final newMode = currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    settingsViewModel.setThemeMode(newMode);
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

  /// Clean and smooth bottom navigation
  Widget _buildElegantBottomNav() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentOS = ['windows', 'macos', 'linux'][_selectedIndex];
    
    return Padding(
      padding: context.rse(horizontal: 20, vertical: 16),
              child: Center(
          child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: context.rh(75),
          decoration: BoxDecoration(
            color: isDark 
              ? AppColors.backgroundDark.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(context.rbr(40)),
            border: Border.all(
              color: AppColors.getOSColor(currentOS).withValues(alpha: 0.8),
              width: context.rw(3.0),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.2),
                blurRadius: 25,
                offset: const Offset(0, 12),
                spreadRadius: 0,
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
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.accentDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
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

  /// Navigation item
  Widget _buildLiquidNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentOS = ['windows', 'macos', 'linux'][_selectedIndex];
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: Container(
          margin: context.re(8),
          decoration: BoxDecoration(
            color: isSelected 
              ? (isDark 
                  ? AppColors.backgroundDark.withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.95))
              : Colors.transparent,
            borderRadius: BorderRadius.circular(context.rbr(32)),
            border: isSelected ? Border.all(
              color: AppColors.getOSColor(currentOS).withValues(alpha: 0.6),
              width: context.rw(2.0),
            ) : null,
            boxShadow: isSelected ? [
              BoxShadow(
                color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
                spreadRadius: 0,
              ),
            ] : null,
          ),
          height: context.rh(49),
          child: Center(
                      child: Icon(
            icon,
            size: context.ri(26),
            color: isSelected
              ? AppColors.getOSColor(currentOS)
              : (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
          ),
          ),
        ),
      ),
    );
  }

  /// Build appearance size drawer item with slider
  Widget _buildAppearanceSizeDrawerItem(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentOS = ['windows', 'macos', 'linux'][_selectedIndex];
    
    return Consumer<SettingsViewModel>(
      builder: (context, settingsVM, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark 
                  ? AppColors.surfaceDark.withValues(alpha: 0.8)
                  : AppColors.neutral50.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark 
                    ? AppColors.borderDark.withValues(alpha: 0.6)
                    : AppColors.borderLight.withValues(alpha: 0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark 
                            ? AppColors.accentDark.withValues(alpha: 0.3)
                            : AppColors.accentDark.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark 
                              ? AppColors.accentDark.withValues(alpha: 0.5)
                              : AppColors.accentDark.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.zoom_in_rounded,
                          size: 24,
                          color: isDark 
                            ? AppColors.accentDark 
                            : AppColors.accentDark,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appearance Size',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark 
                                  ? AppColors.textDarkPrimary 
                                  : AppColors.textPrimary,
                                fontSize: 17,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Adjust app element sizes',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark 
                                  ? AppColors.textDarkSecondary
                                  : AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Slider
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Small',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark 
                                ? AppColors.textDarkSecondary
                                : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(settingsVM.appearanceSize * 100).round()}%',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.getOSColor(currentOS),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Large',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark 
                                ? AppColors.textDarkSecondary
                                : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.getOSColor(currentOS),
                          inactiveTrackColor: isDark 
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.1),
                          thumbColor: AppColors.getOSColor(currentOS),
                          overlayColor: AppColors.getOSColor(currentOS).withValues(alpha: 0.2),
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                        ),
                        child: Slider(
                          value: settingsVM.appearanceSize,
                          min: 0.5,
                          max: 1.2,
                          divisions: 7, // 0.1 increments (0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2)
                          onChanged: (value) {
                            settingsVM.setAppearanceSize(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build optimized favorites drawer item with minimal rebuilds
  Widget _buildFavoritesDrawerItem(BuildContext context, String currentOS) {
    return Consumer<TipsViewModel>(
      builder: (context, tipsVM, child) {
        // Only count favorites for current OS
        final favoritesCount = tipsVM.tips.where((tip) => 
          tip.os.toLowerCase() == currentOS.toLowerCase() && 
          tipsVM.isFavorite(tip.id)
        ).length;
        
        return _buildPremiumDrawerItem(
          context,
          icon: Icons.favorite_rounded,
          title: 'Favorites',
          subtitle: '$favoritesCount ${_getOSDisplayName(currentOS)} tips',
          onTap: () {
            Navigator.of(context).pop(); // Close drawer first
            _showFavorites(context);
          },
        );
      },
    );
  }

  /// Build a premium drawer menu item - Optimized for smooth interactions
  Widget _buildPremiumDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
            child: Material(
              color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
              child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.transparent, // Remove splash effect
          highlightColor: Colors.transparent, // Remove highlight effect
          enableFeedback: false, // Disable haptic feedback for smoother interaction
                child: Container(
            padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
              color: isDark 
                ? AppColors.surfaceDark.withValues(alpha: 0.8)
                : AppColors.neutral50.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark 
                  ? AppColors.borderDark.withValues(alpha: 0.6)
                  : AppColors.borderLight.withValues(alpha: 0.8),
                width: 2,
              ),
              boxShadow: [
                      BoxShadow(
                  color: isDark 
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                        offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark 
                      ? AppColors.accentDark.withValues(alpha: 0.3)
                      : AppColors.accentDark.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark 
                        ? AppColors.accentDark.withValues(alpha: 0.5)
                        : AppColors.accentDark.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                    child: Icon(
                    icon,
                    size: 24,
                    color: isDark 
                            ? AppColors.accentDark 
                      : AppColors.accentDark,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark 
                            ? AppColors.textDarkPrimary 
                            : AppColors.textPrimary,
                          fontSize: 17,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark 
                            ? AppColors.textDarkSecondary
                            : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark 
                      ? AppColors.surfaceDark.withValues(alpha: 0.6)
                      : AppColors.neutral100.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark 
                        ? AppColors.borderDark.withValues(alpha: 0.4)
                        : AppColors.borderLight.withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                    child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isDark 
                            ? AppColors.textDarkSecondary 
                      : AppColors.textSecondary,
                    ),
                  ),
              ],
                ),
              ),
            ),
      ),
    );
  }
}
