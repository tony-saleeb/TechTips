import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../tips_list/tips_list_page.dart';

/// Clean, minimal home page with professional design
class MinimalHomePage extends StatefulWidget {
  const MinimalHomePage({super.key});

  @override
  State<MinimalHomePage> createState() => _MinimalHomePageState();
}

class _MinimalHomePageState extends State<MinimalHomePage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Master your OS',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: _PerfectSettingsButton(
              onPressed: () => _navigateToSettings(context),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundLight,
              AppColors.neutral50,
              AppColors.backgroundLight.withValues(alpha: 0.98),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Enhanced header section
            _buildEnhancedHeader(context),
            
            // Main content with page view
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: const [
                  TipsListPage(os: 'windows'),
                  TipsListPage(os: 'macos'),
                  TipsListPage(os: 'linux'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build enhanced header with OS stats and quick info
  Widget _buildEnhancedHeader(BuildContext context) {
    final osNames = ['Windows', 'macOS', 'Linux'];
    final osIcons = [Icons.window, Icons.laptop_mac, Icons.computer];
    
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick OS selector with stats
          Row(
            children: [
              Expanded(
                child: Text(
                  'Choose your OS to explore tips & tricks',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // OS quick access cards
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                final osColor = AppColors.getOSColor(['windows', 'macos', 'linux'][index]);
                
                return Container(
                  margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? osColor.withValues(alpha: 0.1)
                            : AppColors.cardLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                              ? osColor.withValues(alpha: 0.3)
                              : AppColors.borderLight,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: osColor.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ] : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              osIcons[index],
                              size: 20,
                              color: isSelected ? osColor : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              osNames[index],
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: isSelected ? osColor : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to settings page
  void _navigateToSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings page coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isHovered 
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.borderLight,
                      width: _isHovered ? 2 : 1,
                    ),
                    boxShadow: _isHovered ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
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
                      color: _isHovered ? AppColors.primary : AppColors.textPrimary,
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
