import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../viewmodels/settings_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';

/// Premium Modern Theme Selector
class CreativeThemeSelector extends StatefulWidget {
  const CreativeThemeSelector({super.key});

  @override
  State<CreativeThemeSelector> createState() => _CreativeThemeSelectorState();
}

class _CreativeThemeSelectorState extends State<CreativeThemeSelector>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _iconAnimationController;
  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutQuart,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutQuart,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutQuart,
    ));

    _slideController.forward();
    _fadeController.forward();
    _scaleController.forward();
    _iconAnimationController.repeat(reverse: false);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: Listenable.merge([_slideAnimation, _fadeAnimation, _scaleAnimation]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: (size.width * 0.85).clamp(300.0, 500.0), // 85% of screen width, min 300px, max 500px
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.lightBlue.withValues(alpha: 0.7),
                      width: 2.5,
                    ),
                    boxShadow: [
                      // Light blue ambient glow
                      BoxShadow(
                        color: Colors.lightBlue.withValues(alpha: 0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 0),
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(21.5), // Slightly smaller to account for border
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.cardDark,
                              AppColors.surfaceDark.withValues(alpha: 0.8),
                              AppColors.cardDark,
                              AppColors.surfaceDark.withValues(alpha: 0.6),
                            ]
                          : [
                              AppColors.cardLight,
                              AppColors.neutral50.withValues(alpha: 0.9),
                              AppColors.cardLight,
                              AppColors.neutral100.withValues(alpha: 0.7),
                            ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(context, isDark),
                            _buildThemeOptions(context, isDark),
                            _buildFooter(context, isDark),
                          ],
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.fromLTRB(40, 24, 40, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark 
              ? [
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                  AppColors.cardDark.withValues(alpha: 0.7),
                  AppColors.surfaceDark.withValues(alpha: 0.5),
                ]
              : [
                  AppColors.neutral50.withValues(alpha: 0.95),
                  AppColors.cardLight.withValues(alpha: 0.8),
                  AppColors.neutral100.withValues(alpha: 0.6),
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border(
          bottom: BorderSide(
            color: isDark 
                ? AppColors.accentDark.withValues(alpha: 0.3)
                : AppColors.accentDark.withValues(alpha: 0.15),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your preferred appearance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: GestureDetector(
                  onTapDown: (_) => HapticFeedback.lightImpact(),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
                    width: 48,
                    height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark 
                      ? [
                                AppColors.surfaceDark.withValues(alpha: 0.9),
                                AppColors.cardDark.withValues(alpha: 0.7),
                                AppColors.surfaceDark.withValues(alpha: 0.5),
                        ]
                      : [
                                Colors.white.withValues(alpha: 0.95),
                                AppColors.neutral50.withValues(alpha: 0.8),
                                Colors.white.withValues(alpha: 0.6),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                ),
                      borderRadius: BorderRadius.circular(24),
                border: Border.all(
                        color: AppColors.accentDark.withValues(alpha: 0.3),
                        width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                          color: AppColors.accentDark.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                        // Inner highlight
                  BoxShadow(
                          color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.3),
                          blurRadius: 4,
                          offset: const Offset(-1, -1),
                          spreadRadius: -2,
                  ),
                ],
              ),
              child: Icon(
                Icons.close_rounded,
                      size: 24,
                      color: AppColors.accentDark,
              ),
            ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOptions(BuildContext context, bool isDark) {
    return Consumer<SettingsViewModel>(
      builder: (context, settingsVM, child) {
        final currentTheme = settingsVM.themeMode;
        
        return Padding(
          padding: const EdgeInsets.fromLTRB(40, 36, 40, 24),
          child: Column(
            children: [
              _buildThemeOption(
                context,
                isDark,
                ThemeMode.system,
                'System',
                'Follow system setting',
                Icons.brightness_auto,
                currentTheme == ThemeMode.system,
                () => _selectTheme(context, settingsVM, ThemeMode.system),
              ),
              const SizedBox(height: 20),
              _buildThemeOption(
                context,
                isDark,
                ThemeMode.light,
                'Light',
                'Always light mode',
                Icons.light_mode,
                currentTheme == ThemeMode.light,
                () => _selectTheme(context, settingsVM, ThemeMode.light),
              ),
              const SizedBox(height: 20),
              _buildThemeOption(
                context,
                isDark,
                ThemeMode.dark,
                'Dark',
                'Always dark mode',
                Icons.dark_mode,
                currentTheme == ThemeMode.dark,
                () => _selectTheme(context, settingsVM, ThemeMode.dark),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    bool isDark,
    ThemeMode themeMode,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                          AppColors.accentDark,
                          AppColors.accentDark.withValues(alpha: 0.9),
                    AppColors.accentDark.withValues(alpha: 0.8),
                          AppColors.accentDark.withValues(alpha: 0.7),
                        ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark 
                      ? [
                          AppColors.surfaceDark.withValues(alpha: 0.8),
                          AppColors.cardDark.withValues(alpha: 0.6),
                          AppColors.surfaceDark.withValues(alpha: 0.4),
                          AppColors.cardDark.withValues(alpha: 0.3),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.95),
                          AppColors.neutral50.withValues(alpha: 0.8),
                          Colors.white.withValues(alpha: 0.6),
                          AppColors.neutral50.withValues(alpha: 0.4),
                        ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppColors.accentDark.withValues(alpha: 0.8)
                : AppColors.accentDark.withValues(alpha: 0.2),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.accentDark.withValues(alpha: 0.5),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: 3,
            ),
            BoxShadow(
              color: AppColors.accentDark.withValues(alpha: 0.3),
              blurRadius: 50,
              offset: const Offset(0, 0),
              spreadRadius: 8,
            ),
            // Inner glow
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(-2, -2),
              spreadRadius: -4,
            ),
          ] : [
            BoxShadow(
              color: AppColors.accentDark.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
            // Subtle inner highlight for unselected
            BoxShadow(
              color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.3),
              blurRadius: 4,
              offset: const Offset(-1, -1),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                // Special black starry background for selected dark theme moon
                gradient: (isSelected && icon == Icons.dark_mode)
                    ? null
                    : (isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    Colors.white.withValues(alpha: 0.9),
                                    Colors.white.withValues(alpha: 0.7),
                                    Colors.white.withValues(alpha: 0.5),
                                  ]
                                : [
                                    Colors.white,
                                    Colors.white.withValues(alpha: 0.95),
                                    Colors.white.withValues(alpha: 0.9),
                                  ],
                            stops: const [0.0, 0.5, 1.0],
                          )
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark 
                                ? [
                                    AppColors.surfaceDark.withValues(alpha: 0.8),
                                    AppColors.cardDark.withValues(alpha: 0.6),
                                    AppColors.surfaceDark.withValues(alpha: 0.4),
                                  ]
                                : [
                                    AppColors.neutral100.withValues(alpha: 0.8),
                                    AppColors.neutral200.withValues(alpha: 0.6),
                                    AppColors.neutral100.withValues(alpha: 0.4),
                                  ],
                            stops: const [0.0, 0.5, 1.0],
                          )),
                // Black background for selected dark theme moon
                color: (isSelected && icon == Icons.dark_mode) ? Colors.black : null,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.3)
                      : (isDark 
                          ? AppColors.borderDark.withValues(alpha: 0.2)
                          : AppColors.borderLight.withValues(alpha: 0.3)),
                  width: isSelected ? 2 : 1.5,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: AppColors.accentDark.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ] : [
                  BoxShadow(
                    color: AppColors.shadowDark.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: _buildAnimatedIcon(
                icon,
                isSelected,
                isDark,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? (isDark ? Colors.white : AppColors.textPrimary)
                          : (isDark ? AppColors.textDarkPrimary : AppColors.textPrimary),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? (isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black)
                          : (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.white.withValues(alpha: 0.95),
                      Colors.white.withValues(alpha: 0.9),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accentDark.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: AppColors.accentDark.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 22,
                  color: AppColors.accentDark,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.fromLTRB(40, 28, 40, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
              ? [
                  AppColors.surfaceDark.withValues(alpha: 0.8),
                  AppColors.cardDark.withValues(alpha: 0.6),
                ]
              : [
                  AppColors.neutral50.withValues(alpha: 0.9),
                  AppColors.cardLight.withValues(alpha: 0.7),
                ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        border: Border(
          top: BorderSide(
            color: isDark 
                ? AppColors.accentDark.withValues(alpha: 0.2)
                : AppColors.accentDark.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 400),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.9 + (0.1 * value),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark 
                            ? [
                                AppColors.surfaceDark.withValues(alpha: 0.8),
                                AppColors.cardDark.withValues(alpha: 0.6),
                                AppColors.surfaceDark.withValues(alpha: 0.4),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.9),
                                AppColors.neutral50.withValues(alpha: 0.7),
                                Colors.white.withValues(alpha: 0.5),
                              ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accentDark.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentDark.withValues(alpha: 0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Center(
              child: Text(
                'Cancel',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.9 + (0.1 * value),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accentDark,
                          AppColors.accentDark.withValues(alpha: 0.8),
                          AppColors.accentDark.withValues(alpha: 0.9),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentDark.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.accentDark.withValues(alpha: 0.2),
                          blurRadius: 40,
                          offset: const Offset(0, 0),
                          spreadRadius: 5,
                        ),
                        // Inner highlight
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(-1, -1),
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                'Done',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  void _selectTheme(BuildContext context, SettingsViewModel settingsVM, ThemeMode themeMode) async {
    // Add smooth transition animation
    HapticFeedback.mediumImpact();
    
    // Add a slight delay to prevent glitching during theme transition
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Set the theme mode with smooth transition
    await settingsVM.setThemeMode(themeMode);
    
    // Small delay to allow theme to fully apply before any UI updates
    await Future.delayed(const Duration(milliseconds: 50));
  }

  Widget _buildAnimatedIcon(IconData icon, bool isSelected, bool isDark) {
    if (icon == Icons.dark_mode) {
      return _buildAnimatedMoon(isSelected, isDark);
    } else if (icon == Icons.light_mode) {
      return _buildAnimatedSun(isSelected, isDark);
    } else if (icon == Icons.brightness_auto) {
      return _buildAnimatedSystem(isSelected, isDark);
    }
    
    // Fallback for other icons
    return Icon(
      icon,
      size: 32,
      color: isSelected
          ? AppColors.accentDark
          : (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
    );
  }

  Widget _buildAnimatedMoon(bool isSelected, bool isDark) {
    return AnimatedBuilder(
      animation: _iconAnimationController,
      builder: (context, child) {
        if (isSelected) {
          // When selected: Animated stars and floating moon over the black button background
          return Stack(
            children: [
              // Small white stars scattered across the square with twinkling animation
              ...List.generate(25, (index) {
                final starPositions = [
                  const Offset(0.13, 0.13), const Offset(0.87, 0.20), const Offset(0.25, 0.75),
                  const Offset(0.80, 0.58), const Offset(0.42, 0.33), const Offset(0.58, 0.13),
                  const Offset(0.20, 0.50), const Offset(0.75, 0.42), const Offset(0.33, 0.83),
                  const Offset(0.67, 0.25), const Offset(0.13, 0.58), const Offset(0.92, 0.67),
                  const Offset(0.30, 0.13), const Offset(0.70, 0.13), const Offset(0.20, 0.80),
                  const Offset(0.83, 0.33), const Offset(0.13, 0.37), const Offset(0.63, 0.75),
                  const Offset(0.47, 0.20), const Offset(0.20, 0.70), const Offset(0.75, 0.13),
                  const Offset(0.37, 0.63), const Offset(0.80, 0.50), const Offset(0.25, 0.30),
                  const Offset(0.58, 0.70),
                ];
                final starSizes = [1.0, 1.2, 0.8, 1.1, 0.9, 1.3, 0.7, 1.0, 1.4, 0.6,
                                  1.2, 0.8, 1.1, 0.9, 1.3, 0.7, 1.0, 1.4, 0.6, 1.2,
                                  0.8, 1.1, 0.9, 1.3, 0.7];
                final position = starPositions[index % starPositions.length];
                final size = starSizes[index % starSizes.length];
                
                // Twinkling animation for each star
                final twinkle = (math.sin(_iconAnimationController.value * 2 * math.pi + index * 0.5) + 1) / 2;
                final twinkleAlpha = 0.3 + (twinkle * 0.7);
                
                return Positioned(
                  left: position.dx * 60 - size / 2,
                  top: position.dy * 60 - size / 2,
                  child: Transform.scale(
                    scale: 0.8 + (twinkle * 0.4),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: twinkleAlpha),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: twinkleAlpha * 0.5),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              // Animated floating white moon with dark stains
              Center(
                child: Transform.translate(
                  offset: Offset(
                    0,
                    math.sin(_iconAnimationController.value * 2 * math.pi) * 2,
                  ),
                  child: Transform.rotate(
                    angle: _iconAnimationController.value * 0.5,
                    child: Transform.scale(
                      scale: 1.0 + 0.05 * math.sin(_iconAnimationController.value * 3 * math.pi),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Dark lunar stains/maria with subtle animation
                            Transform.rotate(
                              angle: _iconAnimationController.value * 0.3,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.grey.shade700.withValues(alpha: 0.4),
                                      Colors.grey.shade800.withValues(alpha: 0.6),
                                      Colors.grey.shade900.withValues(alpha: 0.8),
                                    ],
                                    stops: const [0.0, 0.4, 0.7, 1.0],
                                    center: const Alignment(0.3, -0.2),
                                    radius: 0.8,
                                  ),
                                ),
                              ),
                            ),
                            // Subtle inner glow
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.7],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        
        // When not selected: Original dark moon with glow
        return Transform.scale(
          scale: 1.0 + 0.15 * math.sin(_iconAnimationController.value * 3 * math.pi),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer mystical glow
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary).withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Main moon body for unselected state
              Transform.rotate(
                angle: _iconAnimationController.value * 2.5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Moon surface - dark when unselected
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSun(bool isSelected, bool isDark) {
    return AnimatedBuilder(
      animation: _iconAnimationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Fusion core with plasma layers
            Transform.scale(
              scale: 1.0 + 0.15 * math.sin(_iconAnimationController.value * 3 * math.pi),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer plasma ring
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: isSelected
                            ? [
                                Colors.red.withValues(alpha: 0.4),
                                Colors.orange.withValues(alpha: 0.3),
                                Colors.yellow.withValues(alpha: 0.2),
                                Colors.transparent,
                              ]
                            : [
                                (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary).withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                      ),
                    ),
                  ),
                  // Main fusion core
                  Transform.rotate(
                    angle: _iconAnimationController.value * 2.5,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: isSelected
                              ? [
                                  Colors.yellow.withValues(alpha: 0.95),
                                  Colors.orange.withValues(alpha: 0.8),
                                  Colors.red.withValues(alpha: 0.6),
                                  Colors.transparent,
                                ]
                              : [
                                  (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary).withValues(alpha: 0.9),
                                  (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary).withValues(alpha: 0.5),
                                  (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary).withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                          stops: const [0.0, 0.3, 0.6, 1.0],
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.5),
                            blurRadius: 25,
                            spreadRadius: 4,
                          ),
                          BoxShadow(
                            color: Colors.orange.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                          BoxShadow(
                            color: Colors.yellow.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ] : null,
                      ),
                      child: Icon(
                        Icons.wb_sunny_rounded,
                        size: 18,
                        color: isSelected
                            ? AppColors.accentDark
                            : (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
                      ),
                    ),
                  ),
                  // Inner plasma core
                  Transform.scale(
                    scale: 0.5 + 0.3 * math.sin(_iconAnimationController.value * 4 * math.pi),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: isSelected
                              ? [
                                  Colors.white,
                                  Colors.yellow.withValues(alpha: 0.8),
                                  Colors.transparent,
                                ]
                              : [
                                  (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary).withValues(alpha: 0.9),
                                  Colors.transparent,
                                ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Quantum energy rays with particle effects
            ...List.generate(16, (index) {
              final angle = (index * math.pi / 8 + _iconAnimationController.value * (2.5 + index * 0.05)) * 2;
              final radius = 28.0 + (index % 4) * 3.0;
              final x = radius * math.cos(angle);
              final y = radius * math.sin(angle);
              final rayLength = 10.0 + (index % 5) * 2.0;
              
              return Positioned(
                left: x + 30,
                top: y + 30,
                child: Transform.rotate(
                  angle: angle,
                  child: Container(
                    width: 2.5,
                    height: rayLength,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isSelected
                            ? [
                                Colors.white.withValues(alpha: 0.9),
                                Colors.yellow.withValues(alpha: 0.8),
                                Colors.orange.withValues(alpha: 0.6),
                                Colors.red.withValues(alpha: 0.3),
                                Colors.transparent,
                              ]
                            : [
                                (isDark ? AppColors.textDarkTertiary : AppColors.textTertiary).withValues(alpha: 0.8),
                                (isDark ? AppColors.textDarkTertiary : AppColors.textTertiary).withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                      ),
                      borderRadius: BorderRadius.circular(1.25),
                    ),
                  ),
                ),
              );
            }),
            // Plasma flares with energy streams
            ...List.generate(4, (index) {
              final flareAngle = (index * math.pi / 2 + _iconAnimationController.value * 1.8) * 2;
              final flareRadius = 40.0 + (index % 2) * 5.0;
              final x = flareRadius * math.cos(flareAngle);
              final y = flareRadius * math.sin(flareAngle);
              
              return Positioned(
                left: x + 30,
                top: y + 30,
                child: Transform.rotate(
                  angle: flareAngle + math.pi / 2,
                  child: Opacity(
                    opacity: (0.2 + 0.8 * math.sin(_iconAnimationController.value * 4 * math.pi + index * 1.5)).clamp(0.0, 1.0),
                    child: Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? [
                                  Colors.white.withValues(alpha: 0.9),
                                  Colors.yellow.withValues(alpha: 0.7),
                                  Colors.orange.withValues(alpha: 0.5),
                                  Colors.red.withValues(alpha: 0.3),
                                  Colors.transparent,
                                ]
                              : [
                                  (isDark ? AppColors.textDarkTertiary : AppColors.textTertiary).withValues(alpha: 0.7),
                                  (isDark ? AppColors.textDarkTertiary : AppColors.textTertiary).withValues(alpha: 0.4),
                                  Colors.transparent,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              );
            }),
            // Energy particles orbiting the sun
            ...List.generate(6, (index) {
              final particleAngle = (index * math.pi / 3 + _iconAnimationController.value * (1.2 + index * 0.3)) * 2;
              final particleRadius = 45.0 + index * 2.0;
              final x = particleRadius * math.cos(particleAngle);
              final y = particleRadius * math.sin(particleAngle);
              final particleSize = 2.0 + (index % 3) * 1.0;
              
              return Positioned(
                left: x + 30,
                top: y + 30,
                child: Opacity(
                  opacity: (0.3 + 0.7 * (1.0 + math.sin(particleAngle * 2 + _iconAnimationController.value * 6)) / 2).clamp(0.0, 1.0),
                  child: Container(
                    width: particleSize,
                    height: particleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: isSelected
                            ? [
                                Colors.white.withValues(alpha: 0.9),
                                Colors.yellow.withValues(alpha: 0.6),
                                Colors.transparent,
                              ]
                            : [
                                (isDark ? AppColors.textDarkTertiary : AppColors.textTertiary).withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.yellow.withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ] : null,
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedSystem(bool isSelected, bool isDark) {
    return AnimatedBuilder(
      animation: _iconAnimationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Main gear (larger, slower rotation)
            Transform.rotate(
              angle: _iconAnimationController.value * 2.0, // Slower rotation
              child: Icon(
                Icons.settings_rounded,
                size: 28,
                color: isSelected
                    ? Colors.grey.shade800 // Realistic dark grey when selected
                    : Colors.grey.shade600, // Regular grey when unselected
              ),
            ),
            // Secondary gear (smaller, faster rotation, opposite direction)
            Positioned(
              right: 6,
              top: 6,
              child: Transform.rotate(
                angle: -_iconAnimationController.value * 3.0, // Faster, opposite rotation
                child: Icon(
                  Icons.settings_rounded,
                  size: 16,
                  color: isSelected 
                      ? Colors.grey.shade700 // Realistic dark grey when selected
                      : Colors.grey.shade500, // Regular grey when unselected
                ),
              ),
            ),
            // Third gear (smallest, medium speed)
            Positioned(
              left: 8,
              bottom: 8,
              child: Transform.rotate(
                angle: _iconAnimationController.value * 2.5, // Medium speed
                child: Icon(
                  Icons.settings_rounded,
                  size: 12,
                  color: isSelected
                      ? Colors.grey.shade600 // Realistic dark grey when selected
                      : Colors.grey.shade400, // Regular grey when unselected
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}