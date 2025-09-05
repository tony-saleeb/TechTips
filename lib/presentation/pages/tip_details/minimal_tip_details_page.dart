import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/tip_entity.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/utils/extensions.dart';
import '../../viewmodels/tips_viewmodel.dart';

/// Awesome Tip Details Page - Premium Design with Main Screen Spirit
class MinimalTipDetailsPage extends StatefulWidget {
  final TipEntity tip;
  
  const MinimalTipDetailsPage({
    super.key,
    required this.tip,
  });
  
  @override
  State<MinimalTipDetailsPage> createState() => _MinimalTipDetailsPageState();
}

class _MinimalTipDetailsPageState extends State<MinimalTipDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _floatingController;
  late AnimationController _glowController;
  late AnimationController _slideController;
  
  late Animation<double> _heroAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _glowAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutCubic,
    );
    
    _floatingAnimation = CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    );
    
    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    _heroController.forward();
    _floatingController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
    _slideController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _floatingController.dispose();
    _glowController.dispose();
    _slideController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildAwesomeAppBar(isDark),
      body: Stack(
        children: [
          // Awesome background effects
          _buildAwesomeBackground(isDark),
          
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Awesome hero section with animations
                _buildAwesomeHeroSection(isDark),
                
                const SizedBox(height: 24),
                
                // Description section with slide animation
                if (widget.tip.description.isNotEmpty) ...[
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _heroAnimation,
                      child: _buildAwesomeDescriptionSection(isDark),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Steps section with slide animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _heroAnimation,
                    child: _buildAwesomeStepsSection(isDark),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Awesome copy button
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _heroAnimation,
                    child: _buildAwesomeCopyButton(isDark),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                  AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.18),
                  Colors.white.withValues(alpha: 0.12),
                ]
              : [
                  Colors.white.withValues(alpha: 0.9),
                  AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.12),
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
              ? AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.5)
              : AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.35),
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
                // Back button
                _buildBackButton(isDark),
                
                const SizedBox(width: 12),
                
                // Title
                Expanded(
                  child: Center(
                    child: _buildModernTitle(isDark),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Favorite button
                _buildFavoriteButton(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build modern title with OS-specific styling - matches main screen exactly
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
            : AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.4),
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
            color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.3),
            blurRadius: 35,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
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
              AppIcons.getOSIcon(widget.tip.os),
              color: Colors.white,
              size: 18,
            ),
          ),
          
          const SizedBox(width: 12),
          
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
                    AppColors.getOSColor(widget.tip.os),
                    AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.9),
                    AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
                  ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds),
            child: Text(
              'Tip Details',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwesomeBackground(bool isDark) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatingController,
        _glowController,
      ]),
      builder: (context, child) {
        return CustomPaint(
          painter: _AwesomeBackgroundPainter(
            floatingAnimation: _floatingAnimation.value,
            glowAnimation: _glowAnimation.value,
            isDark: isDark,
            osColor: AppColors.getOSColor(widget.tip.os),
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildAwesomeHeroSection(bool isDark) {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (_heroAnimation.value * 0.1),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                  ? [
                      AppColors.cardDark,
                      AppColors.surfaceDark,
                      AppColors.cardDark,
                    ]
                  : [
                      AppColors.cardLight,
                      AppColors.surfaceLight,
                      AppColors.cardLight,
                    ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Awesome OS Badge with floating animation
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatingAnimation.value * 2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                              AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                AppIcons.getOSIcon(widget.tip.os),
                                size: 18,
                                color: AppColors.getOSColor(widget.tip.os),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.tip.os,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.getOSColor(widget.tip.os),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Awesome Tip Title with gradient text
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                      AppColors.getOSColor(widget.tip.os),
                      isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    widget.tip.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.8,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAwesomeDescriptionSection(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                AppColors.cardDark,
                AppColors.surfaceDark,
                AppColors.cardDark,
              ]
            : [
                AppColors.cardLight,
                AppColors.surfaceLight,
                AppColors.cardLight,
              ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.description_rounded,
                  size: 20,
                  color: AppColors.getOSColor(widget.tip.os),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Container(
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
            child: Text(
              widget.tip.description,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwesomeStepsSection(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                AppColors.cardDark,
                AppColors.surfaceDark,
                AppColors.cardDark,
              ]
            : [
                AppColors.cardLight,
                AppColors.surfaceLight,
                AppColors.cardLight,
              ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.list_alt_rounded,
                  size: 20,
                  color: AppColors.getOSColor(widget.tip.os),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Steps',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          ...widget.tip.steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            
            return Padding(
              padding: EdgeInsets.only(bottom: index < widget.tip.steps.length - 1 ? 16 : 0),
              child: _buildAwesomeStepItem(step, index + 1, isDark),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAwesomeStepItem(String step, int stepNumber, bool isDark) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Awesome step number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                  AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getOSColor(widget.tip.os),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Step text
          Expanded(
            child: Text(
              step,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAwesomeCopyButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.getOSColor(widget.tip.os),
            AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _copySteps(),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.copy_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Copy Steps',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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

  void _copySteps() {
    HapticFeedback.lightImpact();
    
    final StringBuffer buffer = StringBuffer();
    buffer.writeln(widget.tip.title);
    buffer.writeln();
    buffer.writeln('Steps:');
    
    for (int i = 0; i < widget.tip.steps.length; i++) {
      buffer.writeln('${i + 1}. ${widget.tip.steps[i]}');
    }
    
    Clipboard.setData(ClipboardData(text: buffer.toString()));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Steps copied to clipboard!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.getOSColor(widget.tip.os),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Build back button - styled for app bar
  Widget _buildBackButton(bool isDark) {
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
            : AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.6),
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
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 18,
                color: isDark 
                  ? Colors.white.withValues(alpha: 0.95) 
                  : AppColors.getOSColor(widget.tip.os),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build favorite button - styled for app bar
  Widget _buildFavoriteButton(bool isDark) {
    return Consumer<TipsViewModel>(
      builder: (context, tipsViewModel, _) {
        final isFavorite = tipsViewModel.favoriteIds.contains(widget.tip.id);
        
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
                : AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.6),
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
                tipsViewModel.toggleFavorite(widget.tip.id);
              },
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 18,
                    color: isFavorite 
                      ? AppColors.favoriteRed
                      : (isDark 
                          ? Colors.white.withValues(alpha: 0.95) 
                          : AppColors.getOSColor(widget.tip.os)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Awesome background painter with floating particles and glow effects
class _AwesomeBackgroundPainter extends CustomPainter {
  final double floatingAnimation;
  final double glowAnimation;
  final bool isDark;
  final Color osColor;

  _AwesomeBackgroundPainter({
    required this.floatingAnimation,
    required this.glowAnimation,
    required this.isDark,
    required this.osColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 15; i++) {
      final x = (size.width * (i * 0.08)) % size.width;
      final y = (size.height * (i * 0.12) + floatingAnimation * 50) % size.height;
      final radius = 1.5 + (floatingAnimation * 2);
      
      paint.color = osColor.withValues(alpha: 0.05 + (floatingAnimation * 0.1));
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw glow effects
    for (int i = 0; i < 3; i++) {
      final x = size.width * (0.2 + i * 0.3);
      final y = size.height * (0.3 + i * 0.2);
      final radius = 30 + (glowAnimation * 20);
      
      paint.color = osColor.withValues(alpha: 0.03 + (glowAnimation * 0.05));
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw subtle gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
          ? [
              osColor.withValues(alpha: 0.02),
              Colors.transparent,
              osColor.withValues(alpha: 0.01),
            ]
          : [
              osColor.withValues(alpha: 0.01),
              Colors.transparent,
              osColor.withValues(alpha: 0.005),
            ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
