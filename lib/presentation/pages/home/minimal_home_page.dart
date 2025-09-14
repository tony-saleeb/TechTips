import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../tips_list/tips_list_page.dart';
import '../../viewmodels/tips_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/minimal_tip_card.dart';
import '../../widgets/creative_theme_selector.dart';
import '../../utils/about_launcher.dart';

/// Optimized home page with smooth performance
class MinimalHomePage extends StatefulWidget {
  const MinimalHomePage({super.key});

  @override
  State<MinimalHomePage> createState() => _MinimalHomePageState();
}

class _MinimalHomePageState extends State<MinimalHomePage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  
  // Callbacks to control search in TipsListPages
  VoidCallback? _windowsToggleSearch;
  VoidCallback? _macosToggleSearch;
  VoidCallback? _linuxToggleSearch;

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
      appBar: _buildAwesomeAppBar(isDark),
      drawer: _buildDrawer(context),
      drawerEdgeDragWidth: 80, // Increase drag area for easier closing
      body: Stack(
        children: [
          // Main content
          PageView.builder(
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

  /// Build clean app bar with proper layout
  PreferredSizeWidget _buildAwesomeAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: false, // Disable default leading
      title: Row(
        children: [
          // Custom drawer button to match search button exactly
          _buildDrawerButton(isDark),
          
          // Spacer to center the title
          const Expanded(child: SizedBox()),
          
          // Centered title
          _buildModernTitle(isDark),
          
          // Spacer to balance
          const Expanded(child: SizedBox()),
          
          // Search button
          _buildAppBarSearchButton(isDark),
        ],
      ),
    );
  }

  /// Build clean title for app bar
  Widget _buildModernTitle(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getOSIcon(['windows', 'macos', 'linux'][_selectedIndex]),
          color: isDark 
            ? Colors.white 
            : AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          '${_getOSDisplayName(['windows', 'macos', 'linux'][_selectedIndex])} Tips',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark 
              ? Colors.white 
              : AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]),
            letterSpacing: -0.3,
          ),
        ),
      ],
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
                          _showCreativeThemeSelector(context);
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
                          AboutLauncher.showAbout(context);
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




  /// Show creative theme selector dialog
  void _showCreativeThemeSelector(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  // Premium Backdrop with Multiple Layers
                  Container(
                width: double.infinity,
                height: double.infinity,
                 decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.2,
                     colors: [
                          AppColors.accentDark.withValues(alpha: 0.15),
                          AppColors.accentDark.withValues(alpha: 0.10),
                          AppColors.accentDark.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.7),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        stops: const [0.0, 0.3, 0.5, 0.8, 1.0],
                      ),
                    ),
                  ),
                  
                  // Animated Blur Circles
                  ...List.generate(6, (index) {
                    final positions = [
                      Alignment.topLeft,
                      Alignment.topRight,
                      Alignment.centerLeft,
                      Alignment.centerRight,
                      Alignment.bottomLeft,
                      Alignment.bottomRight,
                    ];
                    final colors = [
                      AppColors.accentDark.withValues(alpha: 0.1),
                      AppColors.accentDark.withValues(alpha: 0.08),
                      AppColors.accentDark.withValues(alpha: 0.06),
                      AppColors.accentDark.withValues(alpha: 0.05),
                      AppColors.accentDark.withValues(alpha: 0.04),
                      AppColors.accentDark.withValues(alpha: 0.03),
                    ];
                    final sizes = [200.0, 150.0, 180.0, 160.0, 140.0, 120.0];
                    
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        final animatedOpacity = animation.value * (0.3 + (index * 0.1));
                        final animatedScale = 0.8 + (animation.value * 0.4);
                        
                        return Positioned(
                          left: positions[index] == Alignment.topLeft || positions[index] == Alignment.centerLeft || positions[index] == Alignment.bottomLeft 
                              ? -50 : null,
                          right: positions[index] == Alignment.topRight || positions[index] == Alignment.centerRight || positions[index] == Alignment.bottomRight 
                              ? -50 : null,
                          top: positions[index] == Alignment.topLeft || positions[index] == Alignment.topRight 
                              ? 100 : positions[index] == Alignment.centerLeft || positions[index] == Alignment.centerRight 
                              ? 300 : null,
                          bottom: positions[index] == Alignment.bottomLeft || positions[index] == Alignment.bottomRight 
                              ? 100 : null,
                          child: Transform.scale(
                            scale: animatedScale,
        child: Container(
                              width: sizes[index],
                              height: sizes[index],
          decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    colors[index].withValues(alpha: animatedOpacity),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 1.0],
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  
                  // Glass Morphism Effect
              Container(
                    width: double.infinity,
                    height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                          colors: [
                          Colors.white.withValues(alpha: 0.05),
                          Colors.white.withValues(alpha: 0.02),
                          Colors.white.withValues(alpha: 0.01),
                          Colors.black.withValues(alpha: 0.1),
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                  
                  // Main Content
                  Center(
                child: SingleChildScrollView(
                      child: CreativeThemeSelector(),
                    ),
                  ),
                ],
        ),
      ),
    );
        },
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
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
      isDismissible: true,
      enableDrag: true,
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              // Prevent tap from propagating to parent
            },
            child: _buildFavoritesBottomSheet(context, favorites, currentOS),
          ),
        ),
      ),
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
            // Modern Creative Heart Icon
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 2000),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Container(
                  width: 120,
                  height: 120,
              decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.8,
                      colors: [
                        AppColors.accentDark.withValues(alpha: 0.15),
                        AppColors.accentDark.withValues(alpha: 0.08),
                        AppColors.accentDark.withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: AppColors.accentDark.withValues(alpha: 0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                color: AppColors.accentDark.withValues(alpha: 0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: AppColors.accentDark.withValues(alpha: 0.05),
                        blurRadius: 60,
                        offset: const Offset(0, 0),
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Breathing pulse effect
                      Transform.scale(
                        scale: 1.0 + (0.1 * (1.0 + math.sin(value * 4 * math.pi)) / 2),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                AppColors.accentDark.withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 1.0],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      
                      // Main heart icon with subtle rotation and scale
                      Transform.rotate(
                        angle: math.sin(value * 2 * math.pi) * 0.05,
                        child: Transform.scale(
                          scale: 1.0 + (0.05 * (1.0 + math.sin(value * 6 * math.pi)) / 2),
              child: Icon(
                            Icons.favorite_border_rounded,
                            size: 48,
                color: AppColors.accentDark,
              ),
                        ),
                      ),
                      
                      // Floating sparkle effects
                      ...List.generate(6, (index) {
                        final angle = (index * 60.0) * (math.pi / 180);
                        final distance = 35 + (5 * math.sin(value * 3 * math.pi + index));
                        final sparkleOpacity = (1.0 + math.sin(value * 4 * math.pi + index * 0.5)) / 2;
                        
                        return Transform.translate(
                          offset: Offset(
                            distance * math.cos(angle + value * math.pi),
                            distance * math.sin(angle + value * math.pi),
                          ),
                          child: Transform.scale(
                            scale: 0.3 + (0.4 * sparkleOpacity),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.accentDark.withValues(alpha: sparkleOpacity * 0.8),
                                    Colors.transparent,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
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

  /// Build drawer button - styled for app bar
  Widget _buildDrawerButton(bool isDark) {
    return Container(
      width: 40,
      height: 40,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark 
            ? Colors.white.withValues(alpha: 0.4)
            : AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.6),
          width: 2.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Builder(
          builder: (BuildContext scaffoldContext) {
            return InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                Scaffold.of(scaffoldContext).openDrawer();
              },
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.menu_rounded,
                    size: 18,
                    color: isDark 
                      ? Colors.white.withValues(alpha: 0.95) 
                      : AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build search button - styled for app bar
  Widget _buildAppBarSearchButton(bool isDark) {
    return Container(
      width: 40,
      height: 40,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark 
            ? Colors.white.withValues(alpha: 0.4)
            : AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.6),
          width: 2.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            // Toggle search for current OS
            final osNames = ['windows', 'macos', 'linux'];
            final currentOS = osNames[_selectedIndex];
            
            if (currentOS == 'windows' && _windowsToggleSearch != null) {
              _windowsToggleSearch!();
            } else if (currentOS == 'macos' && _macosToggleSearch != null) {
              _macosToggleSearch!();
            } else if (currentOS == 'linux' && _linuxToggleSearch != null) {
              _linuxToggleSearch!();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Icon(
                Icons.search_rounded,
                size: 18,
                color: isDark 
                  ? Colors.white.withValues(alpha: 0.95) 
                  : AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
