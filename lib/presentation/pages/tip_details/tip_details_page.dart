import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../../domain/entities/tip_entity.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../viewmodels/tips_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';

/// Ultra-Premium Modern Tip Details Interface - The Pinnacle of Design Excellence
class TipDetailsPage extends StatefulWidget {
  final TipEntity tip;
  
  const TipDetailsPage({
    super.key,
    required this.tip,
  });
  
  @override
  State<TipDetailsPage> createState() => _TipDetailsPageState();
}

class _TipDetailsPageState extends State<TipDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _floatingController;
  late AnimationController _particleController;
  late AnimationController _buttonController;
  late AnimationController _morphController;
  
  late Animation<double> _heroAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _morphController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _heroAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutQuart,
    ));
    
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOutSine,
    ));
    
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));
    
    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutBack,
    ));
    
    _morphAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _morphController,
      curve: Curves.elasticOut,
    ));
    
    // Start animations with premium timing
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _floatingController.repeat(reverse: true);
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _particleController.repeat();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _morphController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _floatingController.dispose();
    _particleController.dispose();
    _buttonController.dispose();
    _morphController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<TipsViewModel, SettingsViewModel>(
      builder: (context, tipsViewModel, settingsViewModel, child) {
        final isFavorite = tipsViewModel.favoriteIds.contains(widget.tip.id);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFFAFAFA),
          appBar: _buildUltraPremiumAppBar(context, isFavorite, tipsViewModel, isDark),
          body: Stack(
            children: [
              // Premium Background
              _buildPremiumBackground(context, isDark),
              
              // Main Content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                    const SizedBox(height: 20),
                        
                        // Hero Section
                        _buildUltraPremiumHeroSection(context, isDark),
                        
                        const SizedBox(height: 40),
                        
                        // Description Section
                        _buildUltraPremiumDescriptionSection(context, isDark),
                        
                        const SizedBox(height: 40),
                        
                        // Steps Section
                        _buildUltraPremiumStepsSection(context, isDark),
                        
                        const SizedBox(height: 40),
                        
                        // Tags Section
                        
                        const SizedBox(height: 40),
                        
                        // Action Buttons
                        _buildUltraPremiumActionSection(context, isDark),
                        
                        const SizedBox(height: 100),
                  ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildPremiumBackground(BuildContext context, bool isDark) {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                ? [
                    const Color(0xFF000000),
                    const Color(0xFF1A0033),
                    const Color(0xFF2D1B69),
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F172A),
                  ]
                : [
                    const Color(0xFFFFFFFF),
                    const Color(0xFFF0F4FF),
                    const Color(0xFFE6F0FF),
                    const Color(0xFFD1E7FF),
                    const Color(0xFFB8D4FF),
                    const Color(0xFF9CC5FF),
                  ],
              stops: [
                0.0,
                (0.2 + _particleAnimation.value * 0.1).clamp(0.0, 1.0),
                (0.4 + _particleAnimation.value * 0.1).clamp(0.0, 1.0),
                (0.6 + _particleAnimation.value * 0.1).clamp(0.0, 1.0),
                (0.8 + _particleAnimation.value * 0.1).clamp(0.0, 1.0),
                1.0,
              ],
            ),
          ),
          child: CustomPaint(
            painter: _UltraPremiumBackgroundPainter(
              progress: _particleAnimation.value,
              isDark: isDark,
            ),
          ),
        );
      },
    );
  }
  
  PreferredSizeWidget _buildUltraPremiumAppBar(BuildContext context, bool isFavorite, TipsViewModel tipsViewModel, bool isDark) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(130),
      child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                  const Color(0xFF000000),
                  const Color(0xFF1A0033),
                  const Color(0xFF2D1B69),
                  const Color(0xFF1A1A2E),
                  const Color(0xFF16213E),
                  const Color(0xFF0F172A),
                ]
              : [
                  const Color(0xFFFFFFFF),
                  const Color(0xFFF0F4FF),
                  const Color(0xFFE6F0FF),
                  const Color(0xFFD1E7FF),
                  const Color(0xFFB8D4FF),
                  const Color(0xFF9CC5FF),
                ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
              color: isDark ? Colors.purple.withValues(alpha: 0.4) : Colors.blue.withValues(alpha: 0.3),
              blurRadius: 40,
              offset: const Offset(0, 12),
            spreadRadius: 2,
          ),
          BoxShadow(
              color: isDark ? Colors.purple.withValues(alpha: 0.3) : Colors.purple.withValues(alpha: 0.2),
              blurRadius: 25,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                // Back Button - Enhanced Futuristic Design
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        isDark ? Colors.purple[400]!.withValues(alpha: 0.4) : Colors.blue[400]!.withValues(alpha: 0.3),
                        isDark ? Colors.purple[500]!.withValues(alpha: 0.2) : Colors.blue[500]!.withValues(alpha: 0.2),
                        isDark ? Colors.purple[600]!.withValues(alpha: 0.1) : Colors.blue[600]!.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark ? Colors.purple[300]!.withValues(alpha: 0.5) : Colors.blue[300]!.withValues(alpha: 0.4),
                      width: 2,
                    ),
                            boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.purple[400]!.withValues(alpha: 0.2) : Colors.blue[400]!.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: isDark ? Colors.white : Colors.grey[800],
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Title - Enhanced Modern Typography
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        isDark ? Colors.purple[400]!.withValues(alpha: 0.2) : Colors.blue[300]!.withValues(alpha: 0.15),
                        isDark ? Colors.purple[500]!.withValues(alpha: 0.15) : Colors.blue[400]!.withValues(alpha: 0.12),
                        isDark ? Colors.purple[600]!.withValues(alpha: 0.1) : Colors.blue[500]!.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: isDark ? Colors.purple[300]!.withValues(alpha: 0.4) : Colors.blue[200]!.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.purple[400]!.withValues(alpha: 0.15) : Colors.blue[300]!.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                        spreadRadius: 0,
                      ),
                    ],
      ),
                  child: Text(
                    'TIP DETAILS',
                    style: TextStyle(
                      color: isDark ? Colors.purple[100] : Colors.blue[700],
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: isDark ? Colors.purple[400]!.withValues(alpha: 0.3) : Colors.blue[300]!.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Favorite Button - Enhanced Futuristic Design
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: isFavorite
                        ? [
                            Colors.red[300]!.withValues(alpha: 0.5),
                            Colors.red[500]!.withValues(alpha: 0.3),
                            Colors.red[700]!.withValues(alpha: 0.2),
                            Colors.transparent,
                          ]
                        : [
                            isDark ? Colors.purple[400]!.withValues(alpha: 0.4) : Colors.blue[400]!.withValues(alpha: 0.3),
                            isDark ? Colors.purple[500]!.withValues(alpha: 0.2) : Colors.blue[500]!.withValues(alpha: 0.2),
                            isDark ? Colors.purple[600]!.withValues(alpha: 0.1) : Colors.blue[600]!.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isFavorite
                        ? Colors.red[200]!.withValues(alpha: 0.6)
                        : (isDark ? Colors.purple[300]!.withValues(alpha: 0.5) : Colors.blue[300]!.withValues(alpha: 0.4)),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isFavorite
                          ? Colors.red[300]!.withValues(alpha: 0.2)
                          : (isDark ? Colors.purple[400]!.withValues(alpha: 0.2) : Colors.blue[400]!.withValues(alpha: 0.15)),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () => _toggleFavorite(context, tipsViewModel),
                      child: Center(
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFavorite ? Colors.red[500] : (isDark ? Colors.white : Colors.grey[800]),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUltraPremiumHeroSection(BuildContext context, bool isDark) {
    final osColor = AppColors.getOSColor(widget.tip.os);
    
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (60 * (1 - _heroAnimation.value)).clamp(-100.0, 100.0)),
          child: Opacity(
            opacity: _heroAnimation.value.clamp(0.0, 1.0),
        child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
                  // Ultra-Premium Floating OS Icon
                  AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      final floatOffset = 8 * math.sin(_floatingAnimation.value * 2 * math.pi).clamp(-1.0, 1.0);
                      final rotation = _floatingAnimation.value * 0.1;
                      final scale = 1.0 + 0.05 * math.sin(_floatingAnimation.value * 3 * math.pi).clamp(-1.0, 1.0);
                      
                      return Transform.translate(
                        offset: Offset(0, floatOffset),
                        child: Transform.scale(
                          scale: scale,
                          child: Transform.rotate(
                            angle: rotation,
                            child: Container(
                              width: 120,
                              height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
                                  colors: [
                                    isDark 
                                      ? Colors.white.withValues(alpha: 0.25)
                                      : Colors.white,
                                    isDark 
                                      ? Colors.white.withValues(alpha: 0.18)
                                      : Colors.grey[50]!,
                                    isDark 
                                      ? Colors.white.withValues(alpha: 0.12)
                                      : Colors.grey[100]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark 
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : Colors.grey[200]!,
                                  width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
                                      ? Colors.black.withValues(alpha: 0.3)
                                      : Colors.grey.withValues(alpha: 0.2),
                                    blurRadius: 40,
                                    offset: const Offset(0, 15),
                                  ),
                                  BoxShadow(
                                    color: isDark 
                                      ? Colors.purple[500]!.withValues(alpha: 0.2)
                                      : Colors.blue[500]!.withValues(alpha: 0.2),
                                    blurRadius: 30,
                                    offset: const Offset(0, 0),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: isDark 
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.blue[100]!.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 0),
                                    spreadRadius: 1,
          ),
        ],
      ),
                              child: Stack(
            children: [
                                  // Animated background pattern
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: RadialGradient(
                                          center: Alignment.topLeft,
                                          radius: 1.5,
                                          colors: [
                                            isDark 
                                              ? Colors.purple[500]!.withValues(alpha: 0.1)
                                              : Colors.blue[500]!.withValues(alpha: 0.1),
                                            isDark 
                                              ? Colors.purple[500]!.withValues(alpha: 0.05)
                                              : Colors.blue[500]!.withValues(alpha: 0.05),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Glowing ring effect
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: isDark 
                                            ? Colors.purple[500]!.withValues(alpha: 0.2)
                                            : Colors.blue[500]!.withValues(alpha: 0.2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Main icon container
                                  Center(
                                    child: Container(
                                      width: 60,
                                      height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                          ? [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white.withValues(alpha: 0.15),
                              Colors.white.withValues(alpha: 0.1),
                            ]
                          : [
                          osColor.withValues(alpha: 0.2),
                              osColor.withValues(alpha: 0.15),
                          osColor.withValues(alpha: 0.1),
                        ],
                      ),
                                        borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark 
                          ? Colors.white.withValues(alpha: 0.4)
                          : Colors.blue[500]!.withValues(alpha: 0.4),
                                          width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.blue[500]!.withValues(alpha: 0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                          BoxShadow(
                                            color: isDark 
                                              ? Colors.white.withValues(alpha: 0.1)
                                              : Colors.blue[500]!.withValues(alpha: 0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 0),
                                            spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                                        AppIcons.getOSIcon(widget.tip.os),
                                        size: 32,
                      color: isDark ? Colors.white : osColor,
                    ),
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
                  
                  const SizedBox(height: 40),
                  
                  // Ultra-Premium Title
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          isDark ? Colors.white.withValues(alpha: 0.15) : Colors.white,
                          isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[50]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.25) : Colors.grey[200]!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 60,
                          offset: const Offset(0, 30),
                        ),
                        BoxShadow(
                          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.blue[100]!.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      widget.tip.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.purple[100] : Colors.blue[700],
                        fontSize: 28,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Ultra-Premium OS Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                          ? [
                              const Color(0xFF1A0033).withValues(alpha: 0.8),
                              const Color(0xFF2D1B69).withValues(alpha: 0.6),
                              const Color(0xFF1A1A2E).withValues(alpha: 0.4),
                              const Color(0xFF16213E).withValues(alpha: 0.2),
                            ]
                          : [
                              Colors.white,
                              Colors.grey[50]!,
                              Colors.grey[100]!,
                              Colors.grey[200]!,
                            ],
                      ),
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: isDark 
                          ? Colors.white.withValues(alpha: 0.25)
                          : Colors.grey[200]!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                        color: isDark 
                            ? Colors.purple[500]!.withValues(alpha: 0.15)
                            : Colors.blue[500]!.withValues(alpha: 0.15),
                          blurRadius: 25,
                          offset: const Offset(0, 0),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                        color: isDark 
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.blue[100]!.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 0),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Premium OS Icon
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                isDark 
                                  ? Colors.purple[500]!.withValues(alpha: 0.2)
                                  : Colors.blue[500]!.withValues(alpha: 0.2),
                                isDark 
                                  ? Colors.purple[500]!.withValues(alpha: 0.15)
                                  : Colors.blue[500]!.withValues(alpha: 0.15),
                                isDark 
                                  ? Colors.purple[500]!.withValues(alpha: 0.1)
                                  : Colors.blue[500]!.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                  color: isDark 
                                ? Colors.purple[500]!.withValues(alpha: 0.4)
                                : Colors.blue[500]!.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark 
                                  ? Colors.purple[500]!.withValues(alpha: 0.2)
                                  : Colors.blue[500]!.withValues(alpha: 0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                              BoxShadow(
                    color: isDark 
                                  ? Colors.purple[500]!.withValues(alpha: 0.1)
                                  : Colors.blue[500]!.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                                spreadRadius: 1,
                  ),
                ],
              ),
                          child: Icon(
                            AppIcons.getOSIcon(widget.tip.os),
                            size: 18,
                            color: isDark ? Colors.white : Colors.blue[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Premium OS Name
                  Text(
                          _getOSDisplayName(widget.tip.os),
                          style: TextStyle(
                      color: isDark 
                              ? Colors.white.withValues(alpha: 0.95)
                              : Colors.blue[700],
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 1.0,
                            shadows: [
                              Shadow(
                                color: isDark 
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.grey.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                  ),
                ],
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

  Widget _buildUltraPremiumDescriptionSection(BuildContext context, bool isDark) {
    return Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ultra-Premium Section Header
              Row(
                children: [
                      Container(
                        width: 8,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                                                      colors: [
                            isDark ? Colors.purple[600]! : Colors.blue[600]!,
                            isDark ? Colors.purple[400]! : Colors.blue[400]!,
                          ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 20),
                  Text(
                        'Description',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.purple[100] : Colors.blue[700],
                          fontSize: 24,
                          letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
                  
                  const SizedBox(height: 24),
                  
                  // Ultra-Premium Description Content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white,
                          isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[50]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(35),
        border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.grey[200]!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 60,
                          offset: const Offset(0, 30),
                        ),
                        BoxShadow(
                          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.blue[100]!.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 0),
                          spreadRadius: 1,
              ),
            ],
          ),
                    child: Text(
                      widget.tip.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        fontSize: 18,
                        color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.grey[700],
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
      ),
    );
  }
  
  Widget _buildUltraPremiumStepsSection(BuildContext context, bool isDark) {
    return AnimatedBuilder(
      animation: _morphAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (30 * (1 - _morphAnimation.value)).clamp(-50.0, 50.0)),
          child: Opacity(
            opacity: _morphAnimation.value.clamp(0.0, 1.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ultra-Premium Section Header
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                                                      colors: [
                            isDark ? Colors.purple[600]! : Colors.blue[600]!,
                            isDark ? Colors.purple[400]! : Colors.blue[400]!,
                          ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Steps',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.purple[100] : Colors.blue[700],
                          fontSize: 24,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Ultra-Premium Steps Grid
                  ...widget.tip.steps.asMap().entries.map(
                    (entry) => _buildUltraPremiumStepItem(context, entry.key + 1, entry.value, isDark),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Copy Steps Button
                  _buildCopyStepsButton(context, isDark),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUltraPremiumStepItem(BuildContext context, int stepNumber, String stepText, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ultra-Premium Step Number
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark ? Colors.purple[600]!.withValues(alpha: 0.4) : Colors.blue[600]!.withValues(alpha: 0.4),
                  isDark ? Colors.purple[500]!.withValues(alpha: 0.3) : Colors.blue[500]!.withValues(alpha: 0.3),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.purple[500]!.withValues(alpha: 0.6) : Colors.blue[500]!.withValues(alpha: 0.6),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.purple[500]!.withValues(alpha: 0.4) : Colors.blue[500]!.withValues(alpha: 0.4),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
                BoxShadow(
                  color: isDark ? Colors.purple[400]!.withValues(alpha: 0.2) : Colors.blue[400]!.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? Colors.purple[600] : Colors.blue[600],
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 24),
          
          // Ultra-Premium Step Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white,
                    isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[50]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.grey[200]!,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 50,
                    offset: const Offset(0, 25),
                  ),
                  BoxShadow(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.green[100]!.withValues(alpha: 0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 0),
                    spreadRadius: 1,
                  ),
                ],
              ),
            child: Text(
              stepText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.7,
                  fontSize: 17,
                  color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.grey[700],
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCopyStepsButton(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () => _copySteps(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark ? Colors.purple[600]!.withValues(alpha: 0.8) : Colors.blue[600]!.withValues(alpha: 0.8),
                  isDark ? Colors.purple[500]!.withValues(alpha: 0.7) : Colors.blue[500]!.withValues(alpha: 0.7),
                  isDark ? Colors.purple[400]!.withValues(alpha: 0.6) : Colors.blue[400]!.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isDark ? Colors.purple[400]!.withValues(alpha: 0.5) : Colors.blue[400]!.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.purple[500]!.withValues(alpha: 0.3) : Colors.blue[500]!.withValues(alpha: 0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: isDark ? Colors.purple[400]!.withValues(alpha: 0.2) : Colors.blue[400]!.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 0),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copy_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  'Copy Steps',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _copySteps(BuildContext context) {
    final stepsText = widget.tip.steps.asMap().entries
        .map((entry) => '${entry.key + 1}. ${entry.value}')
        .join('\n\n');
    
    final fullText = '${widget.tip.title}\n\n$stepsText';
    
    Clipboard.setData(ClipboardData(text: fullText));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Steps copied to clipboard!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
    
    HapticFeedback.lightImpact();
  }

  Widget _buildUltraPremiumActionSection(BuildContext context, bool isDark) {
    return AnimatedBuilder(
      animation: _buttonAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (30 * (1 - _buttonAnimation.value)).clamp(-50.0, 50.0)),
          child: Opacity(
            opacity: _buttonAnimation.value.clamp(0.0, 1.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Copy Button
                  Expanded(
                    child: _buildUltraPremiumActionButton(
                      context,
                      'Copy Steps',
                      Icons.copy_rounded,
                      Colors.blue[600]!,
                      () => _copyToClipboard(context),
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Share Button
                  Expanded(
                    child: _buildUltraPremiumActionButton(
                      context,
                      'Share',
                      Icons.share_rounded,
                      Colors.green[600]!,
                      () => _shareTip(context),
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

  Widget _buildUltraPremiumActionButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onTap) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return Transform.scale(
          scale: (1.0 - _buttonController.value * 0.05).clamp(0.0, 2.0),
          child: Container(
            height: 60,
      decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.3),
                  color.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: color.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 0),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  if (mounted) {
                    _buttonController.forward().then((_) {
                      if (mounted) _buttonController.reverse();
                    });
                  }
                  onTap();
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: color,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        text,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  void _toggleFavorite(BuildContext context, TipsViewModel tipsViewModel) {
    tipsViewModel.toggleFavorite(widget.tip.id);
    HapticFeedback.lightImpact();
  }
  
  void _copyToClipboard(BuildContext context) {
    // Animate button press
    if (mounted) {
      _buttonController.forward().then((_) {
        if (mounted) _buttonController.reverse();
      });
    }
    
    final stepsText = widget.tip.steps.asMap().entries
        .map((entry) => '${entry.key + 1}. ${entry.value}')
        .join('\n');
    
    final fullText = '''
${widget.tip.title}

${widget.tip.description}

Steps:
$stepsText
''';
    
    Clipboard.setData(ClipboardData(text: fullText));
    
    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Steps copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
    
    HapticFeedback.lightImpact();
  }
  
  void _shareTip(BuildContext context) {
    // Animate button press
    if (mounted) {
      _buttonController.forward().then((_) {
        if (mounted) _buttonController.reverse();
      });
    }
    
    final stepsText = widget.tip.steps.asMap().entries
        .map((entry) => '${entry.key + 1}. ${entry.value}')
        .join('\n');
    
    final fullText = '''
${widget.tip.title}

${widget.tip.description}

Steps:
$stepsText
''';
    
    Clipboard.setData(ClipboardData(text: fullText));
    
    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.share, color: Colors.white),
            const SizedBox(width: 12),
            Text('Tip shared to clipboard!'),
          ],
        ),
        backgroundColor: Colors.blue[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
    
    HapticFeedback.lightImpact();
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
}

/// Ultra-Premium Background Painter
class _UltraPremiumBackgroundPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _UltraPremiumBackgroundPainter({
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.grey[300]!).withValues(alpha: 0.08)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw premium grid pattern
    for (int i = 0; i < size.width; i += 80) {
      final x = (i + progress * 30).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (int i = 0; i < size.height; i += 80) {
      final y = (i + progress * 30).clamp(0.0, size.height);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw floating premium shapes
    final shapePaint = Paint()
      ..color = (isDark ? Colors.white : Colors.grey[400]!).withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    // Floating circles with premium effects
    for (int i = 0; i < 12; i++) {
      final x = ((i * 0.12 + progress * 0.08) * size.width).clamp(0.0, size.width);
      final y = ((i * 0.15 + progress * 0.06) * size.height).clamp(0.0, size.height);
      final radius = 25.0 + progress * 40.0;
      canvas.drawCircle(Offset(x, y), radius, shapePaint);
    }

    // Draw premium accent lines
    final accentPaint = Paint()
      ..color = (isDark ? Colors.blue[400]! : Colors.blue[600]!).withValues(alpha: 0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Diagonal accent lines
    for (int i = 0; i < 5; i++) {
      final startX = ((i * 0.2 + progress * 0.1) * size.width).clamp(0.0, size.width);
      final startY = 0.0;
      final endX = (startX + 200.0).clamp(0.0, size.width);
      final endY = size.height;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), accentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}