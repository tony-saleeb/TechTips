import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/extensions.dart';

/// Modern, Clean, and Satisfying About Page
/// Simple yet creative design that focuses on content and user experience
class ModernAboutPage extends StatefulWidget {
  const ModernAboutPage({super.key});

  @override
  State<ModernAboutPage> createState() => _ModernAboutPageState();
}

class _ModernAboutPageState extends State<ModernAboutPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _iconController;
  late AnimationController _pulseController;
  late AnimationController _surpriseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _iconColorAnimation;
  late Animation<double> _surpriseAnimation;
  
  bool _showSurprise = false;
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    // Main content animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    // Icon animation
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Surprise animation
    _surpriseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutQuart),
    ));

    _slideAnimation = Tween<double>(
      begin: 40.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));

    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _iconColorAnimation = ColorTween(
      begin: AppColors.accentDark,
      end: AppColors.accentDark.withValues(alpha:0.7),
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _surpriseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _surpriseController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
    
    // Start icon animation after a slight delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _iconController.forward();
    });

    // Start pulse animation and repeat
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _pulseController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _iconController.dispose();
    _pulseController.dispose();
    _surpriseController.dispose();
    super.dispose();
  }

  void _handleIconTap() {
    setState(() {
      _tapCount++;
    });
    
    if (_tapCount >= 5 && !_showSurprise) {
      setState(() {
        _showSurprise = true;
      });
      _surpriseController.forward();
      HapticFeedback.heavyImpact();
      
      // Show a delightful message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.celebration, color: Colors.white),
              SizedBox(width: 8),
              Text('🎉 You found the easter egg! You\'re awesome!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: Duration(seconds: 4),
        ),
      );
    } else if (_tapCount < 5) {
      HapticFeedback.lightImpact();
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildPremiumAppBar(context, isDark),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: SingleChildScrollView(
                padding: context.re(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Header Section - First to appear
                    _buildAnimatedSection(
                      delay: 0,
                      child: _buildAppHeader(context, isDark),
                    ),
                    
                    SizedBox(height: context.rsp(32)),
                    
                    // Features Grid - Staggered animation
                    _buildAnimatedSection(
                      delay: 200,
                      child: _buildFeaturesGrid(context, isDark),
                    ),
                    
                    SizedBox(height: context.rsp(32)),
                    
                    // Stats Section
                    _buildAnimatedSection(
                      delay: 400,
                      child: _buildStatsSection(context, isDark),
                    ),
                    
                    SizedBox(height: context.rsp(32)),
                    
                    // About Description
                    _buildAnimatedSection(
                      delay: 600,
                      child: _buildAboutDescription(context, isDark),
                    ),
                    
                    SizedBox(height: context.rsp(32)),
                    
                    // Tech Stack
                    _buildAnimatedSection(
                      delay: 800,
                      child: _buildTechStack(context, isDark),
                    ),
                    
                    SizedBox(height: context.rsp(40)),
                    
                    // Footer - Last to appear
                    _buildAnimatedSection(
                      delay: 1000,
                      child: _buildFooter(context, isDark),
                    ),
                    
                    SizedBox(height: context.rsp(20)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: _showSurprise 
          ? null 
          : FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _showSurprise = true;
                });
                _surpriseController.forward();
                HapticFeedback.heavyImpact();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.white),
                        SizedBox(width: 8),
                        Text('✨ Surprise mode activated! Tap the icon! ✨'),
                      ],
                    ),
                    backgroundColor: Colors.purple,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              backgroundColor: AppColors.accentDark,
              foregroundColor: Colors.white,
              icon: Icon(Icons.auto_awesome),
              label: Text('Surprise!'),
            ),
    );
  }

  PreferredSizeWidget _buildPremiumAppBar(BuildContext context, bool isDark) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: isDark 
          ? SystemUiOverlayStyle.light 
          : SystemUiOverlayStyle.dark,
      leading: Container(
        margin: EdgeInsets.only(
          left: context.rsp(12),
          top: context.rsp(8),
          bottom: context.rsp(8),
        ),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(context.rbr(14)),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentDark.withValues(alpha:0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(context.rbr(14)),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: context.rw(44),
                      height: context.rh(44),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        size: context.ri(18),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      title: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        curve: Curves.easeOutQuart,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: Opacity(
              opacity: value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Accent indicator
                  Container(
                    width: context.rw(3),
                    height: context.rh(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.accentDark,
                          AppColors.accentDark.withValues(alpha:0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(context.rbr(2)),
                    ),
                  ),
                  
                  SizedBox(width: context.rsp(12)),
                  
                  // Title text
                  Text(
                    'About',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: EdgeInsets.only(
            right: context.rsp(16),
            top: context.rsp(12),
            bottom: context.rsp(12),
          ),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: context.rse(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentDark.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(context.rbr(8)),
                    border: Border.all(
                      color: AppColors.accentDark.withValues(alpha:0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: context.rw(6),
                        height: context.rh(6),
                        decoration: BoxDecoration(
                          color: AppColors.accentDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: context.rsp(6)),
                      Text(
                        'v1.0',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.accentDark,
                          fontWeight: FontWeight.w600,
                          fontSize: context.rs(10),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedSection({
    required int delay,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutQuart,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildAppHeader(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.cardDark.withValues(alpha:0.8),
                  AppColors.cardDark,
                  AppColors.cardDark.withValues(alpha:0.9),
                ]
              : [
                  AppColors.cardLight,
                  AppColors.cardLight.withValues(alpha:0.95),
                  AppColors.cardLight,
                ],
        ),
        borderRadius: BorderRadius.circular(context.rbr(24)),
        border: Border.all(
          color: isDark 
              ? AppColors.borderDark.withValues(alpha:0.5)
              : AppColors.borderLight.withValues(alpha:0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withValues(alpha:0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.accentDark.withValues(alpha:0.05),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top section with icon and main title
          Container(
            padding: context.re(28),
            child: Column(
              children: [
                // Interactive Hero App Icon with Surprise
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Main icon
                    GestureDetector(
                      onTap: _handleIconTap,
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _iconScaleAnimation,
                          _iconRotationAnimation,
                          _pulseAnimation,
                          _iconColorAnimation,
                          _surpriseAnimation,
                        ]),
                        builder: (context, child) {
                          final surpriseScale = _showSurprise ? 1.0 + (_surpriseAnimation.value * 0.3) : 1.0;
                          final surpriseRotation = _showSurprise ? _surpriseAnimation.value * 2 * 3.14159 : 0.0;
                          
                          return Transform.scale(
                            scale: _iconScaleAnimation.value * _pulseAnimation.value * surpriseScale,
                            child: Transform.rotate(
                              angle: _iconRotationAnimation.value * 0.05 + surpriseRotation,
                              child: Container(
                                width: context.rw(100),
                                height: context.rh(100),
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: _showSurprise
                                        ? [
                                            Colors.purple.withValues(alpha:0.8),
                                            Colors.pink.withValues(alpha:0.6),
                                            Colors.orange.withValues(alpha:0.4),
                                            Colors.transparent,
                                          ]
                                        : [
                                            (_iconColorAnimation.value ?? AppColors.accentDark),
                                            (_iconColorAnimation.value ?? AppColors.accentDark).withValues(alpha:0.7),
                                            (_iconColorAnimation.value ?? AppColors.accentDark).withValues(alpha:0.4),
                                          ],
                                    stops: _showSurprise 
                                        ? const [0.0, 0.5, 0.8, 1.0]
                                        : const [0.0, 0.7, 1.0],
                                  ),
                                  borderRadius: BorderRadius.circular(context.rbr(28)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _showSurprise
                                          ? Colors.purple.withValues(alpha:0.6 * _surpriseAnimation.value)
                                          : (_iconColorAnimation.value ?? AppColors.accentDark).withValues(alpha:0.4),
                                      blurRadius: (30 + (_showSurprise ? 20 * _surpriseAnimation.value : 0)) * _pulseAnimation.value,
                                      offset: const Offset(0, 10),
                                      spreadRadius: (5 + (_showSurprise ? 10 * _surpriseAnimation.value : 0)) * _pulseAnimation.value,
                                    ),
                                    if (_showSurprise) ...[
                                      BoxShadow(
                                        color: Colors.pink.withValues(alpha:0.4 * _surpriseAnimation.value),
                                        blurRadius: 60,
                                        offset: const Offset(0, 0),
                                        spreadRadius: 15,
                                      ),
                                      BoxShadow(
                                        color: Colors.orange.withValues(alpha:0.3 * _surpriseAnimation.value),
                                        blurRadius: 80,
                                        offset: const Offset(0, 0),
                                        spreadRadius: 20,
                                      ),
                                    ],
                                    BoxShadow(
                                      color: (_iconColorAnimation.value ?? AppColors.accentDark).withValues(alpha:0.2),
                                      blurRadius: 50,
                                      offset: const Offset(0, 20),
                                    ),
                                    // Inner glow
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha:isDark ? 0.1 : 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(-2, -2),
                                      spreadRadius: -5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _showSurprise ? Icons.celebration : Icons.terminal_rounded,
                                  size: context.ri(50),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Floating particles when surprise is active
                    if (_showSurprise)
                      ...List.generate(8, (index) {
                        return AnimatedBuilder(
                          animation: _surpriseAnimation,
                          builder: (context, child) {
                            final angle = (index * 45.0) * (3.14159 / 180);
                            final distance = 80 * _surpriseAnimation.value;
                            final x = distance * math.cos(angle);
                            final y = distance * math.sin(angle);
                            
                            return Transform.translate(
                              offset: Offset(x, y),
                              child: Transform.scale(
                                scale: _surpriseAnimation.value,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        [Colors.purple, Colors.pink, Colors.orange, Colors.cyan, Colors.lime, Colors.amber, Colors.red, Colors.blue][index],
                                        Colors.transparent,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                  ],
                ),
                
                SizedBox(height: context.rsp(24)),
                
                // App Name with Enhanced Typography
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                      (isDark ? AppColors.textDarkPrimary : AppColors.textPrimary).withValues(alpha:0.8),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    AppConstants.appName,
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1.2,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                SizedBox(height: context.rsp(8)),
                
                // Enhanced Tagline
                Text(
                  'Master Every Shortcut, Boost Your Productivity',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.accentDark,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: context.rsp(16)),
                
                // Feature Pills Row
                Wrap(
                  spacing: context.rsp(8),
                  runSpacing: context.rsp(8),
                  alignment: WrapAlignment.center,
                  children: [
                    _buildFeaturePill(context, isDark, '100+ Tips', Icons.lightbulb_rounded),
                    _buildFeaturePill(context, isDark, '3 OS', Icons.computer_rounded),
                    _buildFeaturePill(context, isDark, 'Free', Icons.favorite_rounded),
                  ],
                ),
              ],
            ),
          ),
          
          // Bottom section with version info
          Container(
            padding: context.rse(horizontal: 28, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha:0.03),
                        Colors.white.withValues(alpha:0.01),
                      ]
                    : [
                        Colors.black.withValues(alpha:0.02),
                        Colors.black.withValues(alpha:0.005),
                      ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(context.rbr(24)),
                bottomRight: Radius.circular(context.rbr(24)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated version badge
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: context.rse(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.success.withValues(alpha:0.2),
                              AppColors.success.withValues(alpha:0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(context.rbr(20)),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha:0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withValues(alpha:0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: context.ri(16),
                              color: AppColors.success,
                            ),
                            SizedBox(width: context.rsp(6)),
                            Text(
                              'Version 1.0.0',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(BuildContext context, bool isDark, String text, IconData icon) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: context.rse(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentDark.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(context.rbr(16)),
              border: Border.all(
                color: AppColors.accentDark.withValues(alpha:0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: context.ri(14),
                  color: AppColors.accentDark,
                ),
                SizedBox(width: context.rsp(4)),
                Text(
                  text,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.accentDark,
                    fontWeight: FontWeight.w600,
                    fontSize: context.rs(11),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesGrid(BuildContext context, bool isDark) {
    final features = [
      {
        'icon': Icons.speed_rounded,
        'title': 'Fast',
        'description': 'Instant access',
        'color': AppColors.info,
      },
      {
        'icon': Icons.search_rounded,
        'title': 'Smart Search',
        'description': 'Find tips quickly',
        'color': AppColors.success,
      },
      {
        'icon': Icons.favorite_rounded,
        'title': 'Favorites',
        'description': 'Save your best tips',
        'color': AppColors.favoriteRed,
      },
      {
        'icon': Icons.palette_rounded,
        'title': 'Themes',
        'description': 'Light & dark modes',
        'color': AppColors.warning,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
          ),
        ),
        
        SizedBox(height: context.rsp(16)),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: context.rsp(16),
            mainAxisSpacing: context.rsp(16),
            childAspectRatio: 1.2,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return _buildFeatureCard(
              context,
              isDark,
              icon: feature['icon'] as IconData,
              title: feature['title'] as String,
              description: feature['description'] as String,
              color: feature['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 1.0, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) => setState(() {}),
            onTapUp: (_) => setState(() {}),
            onTapCancel: () => setState(() {}),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: context.re(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(context.rbr(16)),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha:0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced icon container with subtle animation
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: Container(
                          width: context.rw(44),
                          height: context.rh(44),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                color.withValues(alpha:0.15),
                                color.withValues(alpha:0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.rbr(12)),
                            border: Border.all(
                              color: color.withValues(alpha:0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha:0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            size: context.ri(24),
                            color: color,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: context.rsp(12)),
                  
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    ),
                  ),
                  
                  SizedBox(height: context.rsp(4)),
                  
                  Text(
                    description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(BuildContext context, bool isDark) {
    return Container(
      padding: context.re(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(context.rbr(20)),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'By the Numbers',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: context.rsp(20)),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  isDark,
                  number: '100+',
                  label: 'Tips Available',
                  color: AppColors.info,
                ),
              ),
              
              SizedBox(width: context.rsp(16)),
              
              Expanded(
                child: _buildStatItem(
                  context,
                  isDark,
                  number: '3',
                  label: 'OS Supported',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          
          SizedBox(height: context.rsp(16)),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  isDark,
                  number: '100%',
                  label: 'Free Forever',
                  color: AppColors.favoriteRed,
                ),
              ),
              
              SizedBox(width: context.rsp(16)),
              
              Expanded(
                child: _buildStatItem(
                  context,
                  isDark,
                  number: '0',
                  label: 'Ads or Tracking',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    bool isDark, {
    required String number,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: context.re(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(context.rbr(12)),
        border: Border.all(
          color: color.withValues(alpha:0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          
          SizedBox(height: context.rsp(4)),
          
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutDescription(BuildContext context, bool isDark) {
    return Container(
      padding: context.re(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(context.rbr(20)),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is TechTips?',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: context.rsp(12)),
          
          Text(
            AppConstants.appDescription,
            style: context.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: context.rsp(16)),
          
          Text(
            'Whether you\'re a developer, designer, or power user, TechTips helps you master keyboard shortcuts and productivity techniques across Windows, macOS, and Linux. Simple, fast, and completely free.',
            style: context.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechStack(BuildContext context, bool isDark) {
    final techItems = [
      {'name': 'Flutter', 'icon': '📱'},
      {'name': 'Dart', 'icon': '🎯'},
      {'name': 'Provider', 'icon': '⚡'},
      {'name': 'Clean Architecture', 'icon': '🏗️'},
    ];

    return Container(
      padding: context.re(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(context.rbr(20)),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Built With',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: context.rsp(16)),
          
          Wrap(
            spacing: context.rsp(12),
            runSpacing: context.rsp(12),
            children: techItems.map((tech) {
              return Container(
                padding: context.rse(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accentDark.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(context.rbr(20)),
                  border: Border.all(
                    color: AppColors.accentDark.withValues(alpha:0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tech['icon']!,
                      style: TextStyle(fontSize: context.rs(16)),
                    ),
                    SizedBox(width: context.rsp(8)),
                    Text(
                      tech['name']!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: context.re(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(context.rbr(20)),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Made with ❤️ by Antony Saleeb',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: context.rsp(16)),
          
          // Enhanced close button with satisfying interaction
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 200),
            tween: Tween<double>(begin: 1.0, end: 1.0),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: GestureDetector(
                  onTapDown: (_) {
                    // Trigger scale animation on tap
                    setState(() {});
                  },
                  onTapUp: (_) {
                    HapticFeedback.mediumImpact();
                    Navigator.of(context).pop();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: double.infinity,
                    height: context.rh(52),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accentDark,
                          AppColors.accentDark.withValues(alpha:0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(context.rbr(16)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentDark.withValues(alpha:0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.accentDark.withValues(alpha:0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(context.rbr(16)),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: context.ri(20),
                                color: Colors.white,
                              ),
                              SizedBox(width: context.rsp(8)),
                              Text(
                                'Got it, thanks!',
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
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
        ],
      ),
    );
  }
}
