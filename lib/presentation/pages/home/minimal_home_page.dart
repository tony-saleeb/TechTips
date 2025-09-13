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
import '../../widgets/creative_theme_selector.dart';

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

  /// Build awesome app bar - matches tip details exactly
  PreferredSizeWidget _buildAwesomeAppBar(bool isDark) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120), // Give it proper height to match main screen
      child: Container(
        height: 120, // Explicit height to ensure visibility
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.2),
                  AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.18),
                  Colors.white.withValues(alpha: 0.12),
                ]
              : [
                  Colors.white.withValues(alpha: 0.9),
                  AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.12),
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
              ? AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.5)
              : AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.35),
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
                // Drawer button
                _buildDrawerButton(isDark),
                
                const SizedBox(width: 12),
                
                // Title
                Expanded(
                  child: Center(
                    child: _buildModernTitle(isDark),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Search button
                _buildAppBarSearchButton(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build modern title with OS-specific styling - matches tip details exactly
  Widget _buildModernTitle(bool isDark) {
    
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
            : AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.4),
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
            color: AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.3),
            blurRadius: 35,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.2),
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
              _getOSIcon(['windows', 'macos', 'linux'][_selectedIndex]),
              color: Colors.white,
              size: context.ri(18),
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
                    AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]),
                    AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.9),
                    AppColors.getOSColor(['windows', 'macos', 'linux'][_selectedIndex]).withValues(alpha: 0.8),
                  ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds),
            child: Text(
              '${_getOSDisplayName(['windows', 'macos', 'linux'][_selectedIndex])} Tips',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
                fontSize: context.rs(16),
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
              child: Container(
                width: double.infinity,
                height: double.infinity,
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                     colors: [
                       Colors.black.withValues(alpha: 0.4),
                       Colors.black.withValues(alpha: 0.3),
                       Colors.black.withValues(alpha: 0.2),
                       Colors.black.withValues(alpha: 0.1),
                       Colors.white.withValues(alpha: 0.05),
                     ],
                     stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                   ),
                   borderRadius: BorderRadius.circular(24),
                   border: Border.all(
                     color: Colors.white.withValues(alpha: 0.3),
                     width: 1.5,
                   ),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withValues(alpha: 0.3),
                       blurRadius: 40,
                       offset: const Offset(0, 20),
                       spreadRadius: 10,
                     ),
                     BoxShadow(
                       color: Colors.white.withValues(alpha: 0.1),
                       blurRadius: 20,
                       offset: const Offset(0, -10),
                       spreadRadius: 5,
                     ),
                     BoxShadow(
                       color: AppColors.accentDark.withValues(alpha: 0.2),
                       blurRadius: 60,
                       offset: const Offset(0, 0),
                       spreadRadius: 15,
                     ),
                   ],
                 ),
                child: Center(
                  child: SingleChildScrollView(
                    child: CreativeThemeSelector(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Show creative modern about dialog
  void _showAbout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                ? [
                    Colors.black.withValues(alpha: 0.95),
                    Color(0xFF1A1A2E).withValues(alpha: 0.98),
                    Colors.black.withValues(alpha: 0.95),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.98),
                    Color(0xFFF8F9FA).withValues(alpha: 0.95),
                    Colors.white.withValues(alpha: 0.98),
                  ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark 
                ? Colors.cyan.withValues(alpha: 0.3)
                : Colors.cyan.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark 
                  ? Colors.black.withValues(alpha: 0.5)
                  : Colors.black.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Creative header with animated icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                      ? [
                          Colors.cyan.withValues(alpha: 0.2),
                          Colors.blue.withValues(alpha: 0.1),
                          Colors.cyan.withValues(alpha: 0.15),
                        ]
                      : [
                          Colors.cyan.withValues(alpha: 0.1),
                          Colors.blue.withValues(alpha: 0.05),
                          Colors.cyan.withValues(alpha: 0.08),
                        ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Animated app icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.cyan.withValues(alpha: 0.3),
                            Colors.blue.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.terminal_rounded,
                        size: 40,
                        color: Colors.cyan,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // App name with gradient text
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.cyan, Colors.blue],
                      ).createShader(bounds),
                      child: Text(
                        AppConstants.appName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Tagline
                    Text(
                      'Your Ultimate Tech Shortcuts Companion',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark 
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.black.withValues(alpha: 0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Content section
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark 
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark 
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          AppConstants.appDescription,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark 
                              ? Colors.white.withValues(alpha: 0.9)
                              : Colors.black.withValues(alpha: 0.8),
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Features section
                      Text(
                        '✨ Key Features',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Feature cards
                      _buildFeatureCard(
                        context,
                        icon: Icons.computer,
                        title: 'Multi-OS Support',
                        description: 'Windows, macOS & Linux tips',
                        isDark: isDark,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildFeatureCard(
                        context,
                        icon: Icons.favorite,
                        title: 'Smart Favorites',
                        description: 'Save and organize your shortcuts',
                        isDark: isDark,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildFeatureCard(
                        context,
                        icon: Icons.palette,
                        title: 'Theme Engine',
                        description: 'Dark & light themes with smooth transitions',
                        isDark: isDark,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildFeatureCard(
                        context,
                        icon: Icons.design_services,
                        title: 'Modern Design',
                        description: 'Clean, minimal, and responsive interface',
                        isDark: isDark,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Version info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                              ? [
                                  Colors.cyan.withValues(alpha: 0.1),
                                  Colors.blue.withValues(alpha: 0.05),
                                ]
                              : [
                                  Colors.cyan.withValues(alpha: 0.05),
                                  Colors.blue.withValues(alpha: 0.02),
                                ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.cyan.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.cyan,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Version 1.0.0 • Built with Flutter',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.cyan.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Close button
              Container(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Colors.cyan.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Got it!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Build feature card for about dialog
  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
          ? Colors.white.withValues(alpha: 0.03)
          : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark 
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan, Colors.blue],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark 
                      ? Colors.white.withValues(alpha: 0.9)
                      : Colors.black.withValues(alpha: 0.8),
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark 
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
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
