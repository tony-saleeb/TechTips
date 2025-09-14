import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/tip_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/utils/extensions.dart';
import '../viewmodels/tips_viewmodel.dart';
import '../pages/tip_details/minimal_tip_details_page.dart';

/// The most beautiful tip card ever created - Premium Glassmorphism Design
class MinimalTipCard extends StatefulWidget {
  final TipEntity tip;
  final VoidCallback? onTap;
  final int index;

  const MinimalTipCard({
    super.key,
    required this.tip,
    this.onTap,
    required this.index,
  });

  @override
  State<MinimalTipCard> createState() => _MinimalTipCardState();
}

class _MinimalTipCardState extends State<MinimalTipCard> {

  @override
  void initState() {
    super.initState();
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      _navigateToDetails(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return RepaintBoundary(
      child: Consumer<TipsViewModel>(
        builder: (context, tipsViewModel, _) {
          final isFavorite = tipsViewModel.isFavorite(widget.tip.id);
          
          return Container(
          margin: context.rse(horizontal: 20, vertical: 12),
          child: GestureDetector(
            onTap: _onTap,
                        child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.rbr(28)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.rbr(28)),
                child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                ? [
                            Colors.white.withValues(alpha: 0.12),
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.05),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.95),
                            Colors.white.withValues(alpha: 0.9),
                            Colors.white.withValues(alpha: 0.85),
                                  ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                    borderRadius: BorderRadius.circular(context.rbr(28)),
                            border: Border.all(
                                color: isDark 
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.25),
                      width: context.rw(1.5),
                    ),
                  ),
                  child: Padding(
                    padding: context.re(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with OS badge and favorite button
                              Row(
                                children: [
                            _buildPremiumOSBadge(context),
                                  const Spacer(),
                            _buildPremiumFavoriteButton(context, isFavorite, tipsViewModel),
                          ],
                        ),
                        
                        context.rsb(height: 20),
                        
                        // Title
                        Text(
                                  widget.tip.title,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                            fontSize: context.rs(20),
                                    letterSpacing: -0.5,
                                ),
                              ),
                              
                        context.rsb(height: 12),
                              
                        // Description
                              Text(
                                widget.tip.description,
                          style: context.textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: context.rs(15),
                            height: 1.5,
                          ),
                        ),
                        
                        context.rsb(height: 20),
                        
                        // Steps preview
                              Container(
                          padding: context.re(20),
                                decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                ? [
                                    Colors.white.withValues(alpha: 0.12),
                                    Colors.white.withValues(alpha: 0.08),
                                    Colors.white.withValues(alpha: 0.05),
                                  ]
                                : [
                                    Colors.white.withValues(alpha: 0.95),
                                    Colors.white.withValues(alpha: 0.9),
                                    Colors.white.withValues(alpha: 0.85),
                                  ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(context.rbr(18)),
                                  border: Border.all(
                              color: isDark 
                                ? Colors.white.withValues(alpha: 0.2)
                                : AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.25),
                              width: context.rw(1.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark 
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.1),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.15),
                                blurRadius: 25,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                            ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                padding: context.re(10),
                                      decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.25),
                                      AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.15),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(context.rbr(12)),
                                  border: Border.all(
                                    color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.4),
                                    width: context.rw(1.5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                      ),
                                      child: Icon(
                                  Icons.format_list_numbered_rounded,
                                  size: context.ri(18),
                                        color: AppColors.getOSColor(widget.tip.os),
                                      ),
                                    ),
                              context.rsb(width: 14),
                              Expanded(
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isDark
                                      ? [
                                          Colors.white,
                                          Colors.white.withValues(alpha: 0.9),
                                        ]
                                      : [
                                          AppColors.getOSColor(widget.tip.os),
                                          AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
                                        ],
                                  ).createShader(bounds),
                                  child: Text(
                                    '${widget.tip.steps.length} steps to master',
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: context.rs(15),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                                    Container(
                                padding: context.re(10),
                                      decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.getOSColor(widget.tip.os),
                                      AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.9),
                                    ],
                                  ),
                                        borderRadius: BorderRadius.circular(context.rbr(12)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                      spreadRadius: 1,
                                    ),
                                    BoxShadow(
                                      color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                      spreadRadius: 2,
                                    ),
                                  ],
                                      ),
                                      child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: context.ri(16),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        
                        context.rsb(height: 20),
                        
                        // Tags
                        if (widget.tip.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: context.rsp(8),
                            runSpacing: context.rsp(8),
                            children: widget.tip.tags.map((tag) => _buildPremiumTag(context, tag)).toList(),
                          ),
                        ],
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
    );
  }

  /// Build premium OS badge with glassmorphism
  Widget _buildPremiumOSBadge(BuildContext context) {
    return Container(
      padding: context.rse(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.getOSColor(widget.tip.os),
            AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
            AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(context.rbr(18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: context.re(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(context.rbr(10)),
            ),
            child: Icon(
              AppIcons.getOSIcon(widget.tip.os),
              size: context.ri(20),
              color: Colors.white,
            ),
          ),
          context.rsb(width: 10),
          Text(
            _getOSDisplayName(widget.tip.os),
            style: context.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: context.rs(13),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  /// Build premium favorite button with sophisticated animations
  Widget _buildPremiumFavoriteButton(BuildContext context, bool isFavorite, TipsViewModel tipsViewModel) {
    return _PremiumFavoriteButton(
      isFavorite: isFavorite,
      onPressed: () => _toggleFavorite(context, tipsViewModel),
    );
  }

  /// Build premium tag with glassmorphism
  Widget _buildPremiumTag(BuildContext context, String tag) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: context.rse(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ]
            : [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.02),
              ],
        ),
              borderRadius: BorderRadius.circular(context.rbr(14)),
      border: Border.all(
        color: isDark
          ? Colors.white.withValues(alpha: 0.15)
          : Colors.black.withValues(alpha: 0.1),
        width: context.rw(1),
      ),
      ),
      child: Text(
        tag,
        style: context.textTheme.labelSmall?.copyWith(
          color: isDark
            ? Colors.white.withValues(alpha: 0.8)
            : AppColors.textSecondary,
          fontSize: context.rs(12),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  /// Get OS display name
  String _getOSDisplayName(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return 'Windows';
      case 'macos':
        return 'macOS';
      case 'linux':
        return 'Linux';
      default:
        return os;
    }
  }

  /// Toggle favorite status with haptic feedback
  void _toggleFavorite(BuildContext context, TipsViewModel tipsViewModel) {
    try {
      tipsViewModel.toggleFavorite(widget.tip.id);
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  /// Navigate to tip details with futuristic page
  void _navigateToDetails(BuildContext context) {
    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MinimalTipDetailsPage(tip: widget.tip),
        ),
      );
    } catch (e) {
      debugPrint('Error navigating to details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening tip details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


}

/// Revolutionary Modern Favorite Button with Holographic Effects
class _PremiumFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _PremiumFavoriteButton({
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  State<_PremiumFavoriteButton> createState() => _PremiumFavoriteButtonState();
}

class _PremiumFavoriteButtonState extends State<_PremiumFavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _liquidController;
  late AnimationController _hologramController;
  late AnimationController _rippleController;
  late AnimationController _shimmerController;
  late AnimationController _tapController;
  
  late Animation<double> _morphAnimation;
  late Animation<double> _hologramAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _tapAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _morphController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _liquidController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _hologramController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _morphAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _morphController,
      curve: Curves.easeInOutCubic,
    ));


    _hologramAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hologramController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOutQuart,
    ));
    
    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    
    _tapAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _morphController,
      curve: Curves.elasticOut,
    ));

  }

  @override
  void dispose() {
    _morphController.dispose();
    _liquidController.dispose();
    _hologramController.dispose();
    _rippleController.dispose();
    _shimmerController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_PremiumFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      if (widget.isFavorite) {
        _morphController.forward();
        _liquidController.forward();
        _hologramController.repeat();
        _rippleController.forward();
        _shimmerController.repeat();
      } else {
        _morphController.reverse();
        _liquidController.reverse();
        _hologramController.stop();
        _rippleController.reverse();
        _shimmerController.stop();
      }
    }
  }

  void _onTapDown(TapDownDetails details) {
    _tapController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _tapController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _tapController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _morphController,
          _liquidController,
          _hologramController,
          _rippleController,
          _shimmerController,
          _tapController,
        ]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Holographic background effects
              if (widget.isFavorite) ..._buildHolographicEffects(isDark),
              
              // Liquid ripple effects
              if (widget.isFavorite) ..._buildLiquidRipples(isDark),
              
              // Main morphing button
              Transform.scale(
                scale: _tapAnimation.value,
            child: Container(
                  width: 48,
                  height: 48,
              decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                  colors: widget.isFavorite
                        ? isDark
                          ? [
                              const Color(0xFF8B0000).withValues(alpha: 0.9), // Dark red wine
                              const Color(0xFF722F37).withValues(alpha: 0.7), // Wine red
                              const Color(0xFF5D1A1A).withValues(alpha: 0.5), // Deep wine
                              const Color(0xFF4A1414).withValues(alpha: 0.3), // Dark wine
                            ]
                          : [
                              const Color(0xFFB22222).withValues(alpha: 0.9), // Fire brick
                              const Color(0xFF8B0000).withValues(alpha: 0.7), // Dark red
                              const Color(0xFF722F37).withValues(alpha: 0.5), // Wine red
                              const Color(0xFF5D1A1A).withValues(alpha: 0.3), // Deep wine
                            ]
                        : [
                            isDark 
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.grey[200]!.withValues(alpha: 0.3),
                            isDark 
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.grey[300]!.withValues(alpha: 0.2),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                ),
                    boxShadow: [
                      if (widget.isFavorite) ...[
                  BoxShadow(
                          color: isDark
                            ? const Color(0xFF8B0000).withValues(alpha: 0.5 * _morphAnimation.value)
                            : const Color(0xFFB22222).withValues(alpha: 0.5 * _morphAnimation.value),
                          blurRadius: 30,
                          offset: const Offset(0, 0),
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: isDark
                            ? const Color(0xFF722F37).withValues(alpha: 0.4 * _morphAnimation.value)
                            : const Color(0xFF8B0000).withValues(alpha: 0.4 * _morphAnimation.value),
                          blurRadius: 50,
                          offset: const Offset(0, 0),
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: isDark
                            ? const Color(0xFF5D1A1A).withValues(alpha: 0.3 * _morphAnimation.value)
                            : const Color(0xFF722F37).withValues(alpha: 0.3 * _morphAnimation.value),
                          blurRadius: 70,
                          offset: const Offset(0, 0),
                          spreadRadius: 12,
                        ),
                      ] else ...[
                        BoxShadow(
                          color: isDark 
                            ? Colors.black.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                    spreadRadius: 2,
                  ),
                      ],
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Shimmer effect
                      if (widget.isFavorite)
                        _buildShimmerEffect(isDark),
                      
                      // Main icon with smooth transition
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                child: Icon(
                    widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            key: ValueKey(widget.isFavorite),
                            size: 24,
                  color: widget.isFavorite 
                              ? Colors.white
                              : (isDark 
                          ? Colors.white.withValues(alpha: 0.7)
                                  : Colors.grey[600]),
                  ),
                ),
              ),
                    ],
            ),
            ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  List<Widget> _buildHolographicEffects(bool isDark) {
    return List.generate(3, (index) {
      final delay = index * 0.3;
      final animationValue = (_hologramAnimation.value + delay) % 1.0;
      
      return Transform.scale(
        scale: 1.0 + (animationValue * 0.5),
        child: Opacity(
          opacity: (1.0 - animationValue).clamp(0.0, 1.0),
          child: Container(
            width: 60 + (index * 15),
            height: 60 + (index * 15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                  ? [
                      Colors.purple[400]!,
                      Colors.purple[500]!,
                      Colors.indigo[500]!,
                    ][index].withValues(alpha: 0.3)
                  : [
                      Colors.blue[400]!,
                      Colors.blue[500]!,
                      Colors.blue[600]!,
                    ][index].withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ),
        ),
      );
    });
  }
  
  List<Widget> _buildLiquidRipples(bool isDark) {
    return List.generate(4, (index) {
      final delay = index * 0.2;
      final animationValue = (_rippleAnimation.value + delay).clamp(0.0, 1.0);
      final scale = 1.0 + (animationValue * 2.0);
      final opacity = (1.0 - animationValue).clamp(0.0, 1.0);
      
      return Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity * 0.6,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                  ? [
                      Colors.purple[400]!.withValues(alpha: 0.4),
                      Colors.purple[500]!.withValues(alpha: 0.2),
                      Colors.transparent,
                    ]
                  : [
                      Colors.blue[400]!.withValues(alpha: 0.4),
                      Colors.blue[500]!.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
              ),
            ),
          ),
        ),
      );
    });
  }
  
  Widget _buildShimmerEffect(bool isDark) {
    return Transform.rotate(
      angle: _shimmerAnimation.value * 3.14159 * 2,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: isDark
              ? [
                  Colors.transparent,
                  Colors.purple[300]!.withValues(alpha: 0.3),
                  Colors.purple[200]!.withValues(alpha: 0.6),
                  Colors.purple[300]!.withValues(alpha: 0.3),
                  Colors.transparent,
                ]
              : [
                  Colors.transparent,
                  Colors.blue[300]!.withValues(alpha: 0.3),
                  Colors.blue[200]!.withValues(alpha: 0.6),
                  Colors.blue[300]!.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
            stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}

