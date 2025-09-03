import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/extensions.dart';

/// Enhanced splash screen with smooth, fluid animations
class MinimalSplashScreen extends StatefulWidget {
  const MinimalSplashScreen({super.key});

  @override
  State<MinimalSplashScreen> createState() => _MinimalSplashScreenState();
}

class _MinimalSplashScreenState extends State<MinimalSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late AnimationController _floatingController;
  
       late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _backgroundOpacity;
  late Animation<double> _backgroundScale;
   late Animation<double> _floatingOffset;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller - 1.2 seconds for 2-second total
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Background animation controller - 0.6 seconds for 2-second total
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Floating animation controller for subtle movement
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Logo animations - ultra-smooth curves
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    _logoScale = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutCubic,
    ));

    // Background animations - ultra-smooth curves
    _backgroundOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundScale = Tween<double>(
      begin: 1.05,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeOutCubic,
    ));

    // Floating animation for subtle movement
    _floatingOffset = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    // Start background first
    _backgroundController.forward();
    
    // Start floating animation
    _floatingController.repeat(reverse: true);
    
    // Wait a bit, then start logo
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      _logoController.forward();
      
      // Keep floating animation running for a moment after logo completes
    await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  @override
  void dispose() {
     _logoController.dispose();
    _backgroundController.dispose();
     _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Transform.scale(
          scale: _backgroundScale.value,
          child: Opacity(
            opacity: _backgroundOpacity.value,
            child: Container(
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
                          Colors.white,
                          Color(0xFFF8F9FA),
                          Color(0xFFE9ECEF),
                        ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    // Subtle floating background elements
                    if (!isDark) _buildLightThemeBackground(),
                    // Main content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TechTips Logo with enhanced animations
                          _buildTechTipsLogo(isDark),
                        ],
                      ),
                    ),
                  ],
              ),
            ),
          ),
        );
      },
      ),
    );
  }

             Widget _buildTechTipsLogo(bool isDark) {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
            child: Opacity(
              opacity: _logoOpacity.value,
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatingOffset.value * context.rh(8) - context.rh(4)),
                  child:                   Container(
                    padding: context.re(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.rbr(20)),
                      boxShadow: isDark 
                        ? [
                        BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : [
                        BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 30,
                              spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: context.responsiveCardAspectRatio * 200,
                      height: context.responsiveCardAspectRatio * 200,
                      fit: BoxFit.contain,
            ),
          ),
        );
      },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLightThemeBackground() {
    return AnimatedBuilder(
      animation: _floatingController,
        builder: (context, child) {
          return Stack(
            children: [
            // Subtle floating circles
              Positioned(
              top: context.rh(100) + _floatingOffset.value * context.rh(20),
              left: context.rw(50),
              child: Container(
                width: context.rw(60),
                height: context.rh(60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE3F2FD).withValues(alpha: 0.3),
                ),
              ),
            ),
              Positioned(
              bottom: context.rh(150) - _floatingOffset.value * context.rh(15),
              right: context.rw(80),
              child: Container(
                width: context.rw(40),
                height: context.rh(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF3E5F5).withValues(alpha: 0.2),
                ),
              ),
            ),
              Positioned(
              top: context.rh(300) + _floatingOffset.value * context.rh(25),
              right: context.rw(120),
              child: Container(
                width: context.rw(80),
                height: context.rh(80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8F5E8).withValues(alpha: 0.25),
                  ),
                ),
              ),
            ],
          );
        },
    );
  }
}
