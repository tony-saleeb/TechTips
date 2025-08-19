import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/tip_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/utils/extensions.dart';
import '../viewmodels/tips_viewmodel.dart';

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

class _MinimalTipCardState extends State<MinimalTipCard>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _hoverController;
  late AnimationController _tapController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _borderAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 50), // Ultra-fast
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 100), // Fast
      vsync: this,
    );
    
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 50), // Ultra-fast
      vsync: this,
    );

    // Instant entrance animations
    _fadeAnimation = Tween<double>(
      begin: 1.0, // Start fully visible
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.linear,
    ));
    
    _slideAnimation = Tween<double>(
      begin: 0.0, // No slide
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.linear,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0, // No scale
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.linear,
    ));
    
    // Fast hover animations
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
    
    _borderAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    // Instant entrance animation
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _tapController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _tapController.reverse();
    HapticFeedback.lightImpact();
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      _navigateToDetails(context);
    }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _tapController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _hoverController, _tapController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value * (_isPressed ? 0.98 : 1.0),
            child: FadeTransition(
      opacity: _fadeAnimation,
      child: Consumer<TipsViewModel>(
        builder: (context, tipsViewModel, _) {
          final isFavorite = tipsViewModel.isFavorite(widget.tip.id);
          
          return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: MouseRegion(
                      onEnter: (_) => _onHover(true),
                      onExit: (_) => _onHover(false),
                      child: GestureDetector(
                        onTapDown: _onTapDown,
                        onTapUp: _onTapUp,
                        onTapCancel: _onTapCancel,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              // Base shadow
                              BoxShadow(
                                color: isDark 
                                  ? Colors.black.withValues(alpha: 0.4)
                                  : Colors.black.withValues(alpha: 0.08),
                                blurRadius: 20 + (_glowAnimation.value * 15),
                                offset: Offset(0, 8 + (_glowAnimation.value * 4)),
                                spreadRadius: _glowAnimation.value * 2,
                              ),
                              // Glow effect
                              if (_isHovered) ...[
                                BoxShadow(
                                  color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.3 * _glowAnimation.value),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: AppColors.accentDark.withValues(alpha: 0.2 * _glowAnimation.value),
                                  blurRadius: 40,
                                  offset: const Offset(0, 15),
                                  spreadRadius: 8,
                                ),
                              ],
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Container(
                              padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                ? [
                                        Colors.white.withValues(alpha: 0.08),
                                        Colors.white.withValues(alpha: 0.05),
                                        Colors.white.withValues(alpha: 0.02),
                                      ]
                                    : [
                                        Colors.white.withValues(alpha: 0.9),
                                        Colors.white.withValues(alpha: 0.7),
                                        Colors.white.withValues(alpha: 0.5),
                                  ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                                borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                                color: isDark 
                                    ? Colors.white.withValues(alpha: 0.1 + (_borderAnimation.value * 0.1))
                                    : Colors.white.withValues(alpha: 0.3 + (_borderAnimation.value * 0.2)),
                                  width: 1.5 + (_borderAnimation.value * 0.5),
                                ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                  // Premium header with OS badge and favorite
                              Row(
                                children: [
                                      _buildPremiumOSBadge(context),
                                  const Spacer(),
                                      _buildPremiumFavoriteButton(context, isFavorite, tipsViewModel),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Ultra-premium title with gradient
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: isDark
                                        ? [
                                            Colors.white,
                                            Colors.white.withValues(alpha: 0.9),
                                          ]
                                        : [
                                            AppColors.textPrimary,
                                            AppColors.textPrimary.withValues(alpha: 0.8),
                                          ],
                                    ).createShader(bounds),
                                child: Text(
                                  widget.tip.title,
                                  style: context.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        height: 1.2,
                                        letterSpacing: -0.8,
                                        fontSize: 24,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                                  const SizedBox(height: 20),
                              
                                  // Premium description with enhanced typography
                              Text(
                                widget.tip.description,
                                style: context.textTheme.bodyLarge?.copyWith(
                                      color: isDark 
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : AppColors.textSecondary,
                                      height: 1.8,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                      letterSpacing: 0.3,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                                  const SizedBox(height: 24),
                              
                                  // Premium tags with glassmorphism
                              if (widget.tip.tags.isNotEmpty) ...[
                                Wrap(
                                      spacing: 10,
                                      runSpacing: 8,
                                      children: widget.tip.tags.take(3).map((tag) => _buildPremiumTag(context, tag)).toList(),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                  
                                  // Fancy and sophisticated footer
                              Container(
                                    padding: const EdgeInsets.all(20),
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
                                      borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                        color: isDark 
                                          ? Colors.white.withValues(alpha: 0.2)
                                          : AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.25),
                                        width: 1.5,
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
                                    // Fancy steps icon with gradient
                                    Container(
                                          padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.25),
                                                AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.15),
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
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                      ),
                                      child: Icon(
                                            Icons.format_list_numbered_rounded,
                                            size: 18,
                                        color: AppColors.getOSColor(widget.tip.os),
                                      ),
                                    ),
                                        const SizedBox(width: 14),
                                    // Fancy steps text with gradient
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
                                                fontSize: 15,
                                                letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Fancy arrow button with premium styling
                                    Container(
                                          padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColors.getOSColor(widget.tip.os),
                                                AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.9),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
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
                                      child: const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
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
            ),
          );
        },
    );
  }

  /// Build premium OS badge with glassmorphism
  Widget _buildPremiumOSBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
        borderRadius: BorderRadius.circular(18),
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
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              AppIcons.getOSIcon(widget.tip.os),
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _getOSDisplayName(widget.tip.os),
            style: context.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Text(
        tag,
        style: context.textTheme.labelSmall?.copyWith(
          color: isDark
            ? Colors.white.withValues(alpha: 0.8)
            : AppColors.textSecondary,
          fontSize: 12,
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

  /// Navigate to tip details with premium bottom sheet
  void _navigateToDetails(BuildContext context) {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildPremiumTipDetailsSheet(context),
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

  /// Build premium tip details bottom sheet
  Widget _buildPremiumTipDetailsSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.8,
      maxChildSize: 0.99,
      builder: (context, scrollController) {
    return Container(
      decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                ? [
                    AppColors.backgroundDark,
                    AppColors.surfaceDark.withValues(alpha: 0.9),
                    AppColors.backgroundDark.withValues(alpha: 0.95),
                    AppColors.surfaceDark.withValues(alpha: 0.7),
                    AppColors.backgroundDark,
                  ]
                : [
                    AppColors.backgroundLight,
                    AppColors.neutral50,
                    AppColors.backgroundLight.withValues(alpha: 0.99),
                    AppColors.neutral50.withValues(alpha: 0.8),
                    AppColors.backgroundLight,
                  ],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 50,
                offset: const Offset(0, -20),
                spreadRadius: 10,
              ),
              BoxShadow(
                color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.15),
                blurRadius: 80,
                offset: const Offset(0, -30),
                spreadRadius: 20,
              ),
              BoxShadow(
                color: AppColors.accentDark.withValues(alpha: 0.1),
                blurRadius: 100,
                offset: const Offset(0, -40),
                spreadRadius: 30,
              ),
            ],
          ),
          child: Column(
            children: [
              // Ultra-premium handle bar with glow effect
              Container(
                margin: const EdgeInsets.only(top: 24),
                width: 80,
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.getOSColor(widget.tip.os),
                      AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
                      AppColors.accentDark,
                      AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.6),
                      AppColors.accentDark.withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: AppColors.accentDark.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              
              // Ultra-premium header with glassmorphism
              Container(
                margin: const EdgeInsets.all(28),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                      ? [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.05),
                          Colors.white.withValues(alpha: 0.02),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.95),
                          Colors.white.withValues(alpha: 0.85),
                          Colors.white.withValues(alpha: 0.7),
                          Colors.white.withValues(alpha: 0.6),
                        ],
                    stops: const [0.0, 0.33, 0.66, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(30),
        border: Border.all(
                    color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                        ? Colors.black.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.1),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                      spreadRadius: 5,
                    ),
                  ],
      ),
      child: Row(
        children: [
                    _buildPremiumOSBadge(context),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                                                     ShaderMask(
                             shaderCallback: (bounds) => LinearGradient(
                               begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                               colors: isDark
                                 ? [
                                     Colors.white,
                                     Colors.white.withValues(alpha: 0.95),
                                     Colors.white.withValues(alpha: 0.9),
                                     Colors.white.withValues(alpha: 0.85),
                                   ]
                                 : [
                                     AppColors.textPrimary,
                                     AppColors.textPrimary.withValues(alpha: 0.9),
                                     AppColors.textPrimary.withValues(alpha: 0.8),
                                     AppColors.textPrimary.withValues(alpha: 0.7),
                                   ],
                               stops: const [0.0, 0.33, 0.66, 1.0],
                             ).createShader(bounds),
                             child: Text(
                               widget.tip.title,
                               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                 fontWeight: FontWeight.w900,
                                 color: Colors.white,
                                 height: 1.2,
                                 letterSpacing: -1.0,
                                 fontSize: 24,
                               ),
                             ),
                           ),
                          const SizedBox(height: 8),
          Text(
                            '${widget.tip.steps.length} steps to master',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark 
                                ? Colors.white.withValues(alpha: 0.7)
                                : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
                    ),
                  ],
                ),
              ),
              
              // Ultra-premium content with enhanced animations
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                             // Premium description card
                       Container(
                         margin: const EdgeInsets.only(bottom: 36),
                         padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
                           gradient: LinearGradient(
                             begin: Alignment.topLeft,
                             end: Alignment.bottomRight,
                             colors: [
                               AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.15),
                               AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.08),
                               AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.05),
                               AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.02),
                             ],
                             stops: const [0.0, 0.33, 0.66, 1.0],
                           ),
                           borderRadius: BorderRadius.circular(25),
                           border: Border.all(
                             color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.25),
                             width: 1.5,
                           ),
                           boxShadow: [
                             BoxShadow(
                               color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.15),
                               blurRadius: 25,
                               offset: const Offset(0, 8),
                               spreadRadius: 3,
                             ),
                             BoxShadow(
                               color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.05),
                               blurRadius: 40,
                               offset: const Offset(0, 15),
                               spreadRadius: 5,
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
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.getOSColor(widget.tip.os),
                                        AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.info_outline_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
          Text(
                                  'Description',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.getOSColor(widget.tip.os),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
            ),
          ),
        ],
      ),
                            const SizedBox(height: 16),
                            Text(
                              widget.tip.description,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                                height: 1.8,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                                             // Ultra-premium steps section
                       Container(
                         margin: const EdgeInsets.only(bottom: 36),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Container(
                               padding: const EdgeInsets.all(20),
                               decoration: BoxDecoration(
                                 gradient: LinearGradient(
                                   begin: Alignment.topLeft,
                                   end: Alignment.bottomRight,
                                   colors: [
                                     AppColors.accentDark,
                                     AppColors.accentDark.withValues(alpha: 0.9),
                                     AppColors.accentDark.withValues(alpha: 0.8),
                                     AppColors.accentDark.withValues(alpha: 0.7),
                                   ],
                                   stops: const [0.0, 0.33, 0.66, 1.0],
                                 ),
                                 borderRadius: BorderRadius.circular(20),
                                 boxShadow: [
                                   BoxShadow(
                                     color: AppColors.accentDark.withValues(alpha: 0.4),
                                     blurRadius: 20,
                                     offset: const Offset(0, 8),
                                     spreadRadius: 3,
                                   ),
                                   BoxShadow(
                                     color: AppColors.accentDark.withValues(alpha: 0.2),
                                     blurRadius: 35,
                                     offset: const Offset(0, 15),
                                     spreadRadius: 5,
                                   ),
                                 ],
                               ),
      child: Row(
        children: [
                                   Container(
                                     padding: const EdgeInsets.all(12),
                                     decoration: BoxDecoration(
                                       color: Colors.white.withValues(alpha: 0.2),
                                       borderRadius: BorderRadius.circular(15),
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.white.withValues(alpha: 0.1),
                                           blurRadius: 10,
                                           offset: const Offset(0, 3),
                                         ),
                                       ],
                                     ),
                                     child: Icon(
                                       Icons.format_list_numbered_rounded,
                                       size: 24,
                                       color: Colors.white,
                                     ),
                                   ),
                                   const SizedBox(width: 16),
                                   Expanded(
                                     child: Text(
                                       'Step-by-Step Master Guide',
                                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                         color: Colors.white,
                                         fontWeight: FontWeight.w900,
                                         fontSize: 22,
                                         letterSpacing: -0.5,
                                       ),
                                     ),
                                   ),
                                   Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                     decoration: BoxDecoration(
                                       color: Colors.white.withValues(alpha: 0.2),
                                       borderRadius: BorderRadius.circular(12),
                                     ),
                                     child: Text(
                                       '${widget.tip.steps.length}',
                                       style: const TextStyle(
                                         color: Colors.white,
                                         fontWeight: FontWeight.w900,
                                         fontSize: 16,
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             const SizedBox(height: 28),
                            ...widget.tip.steps.asMap().entries.map(
                              (entry) => _buildUltraPremiumStep(context, entry.key, entry.value, isDark),
                            ),
                          ],
                        ),
                      ),
                      
                      // Premium tags section
                      if (widget.tip.tags.isNotEmpty) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.getOSColor(widget.tip.os),
                                          AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.label_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
          Text(
                                    'Tags',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.getOSColor(widget.tip.os),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 12,
                                runSpacing: 10,
                                children: widget.tip.tags.map((tag) => _buildPremiumTag(context, tag)).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                                             // Ultra-premium footer with action buttons
                       Container(
                         margin: const EdgeInsets.only(bottom: 50),
                         padding: const EdgeInsets.all(28),
                         decoration: BoxDecoration(
                           gradient: LinearGradient(
                             begin: Alignment.topLeft,
                             end: Alignment.bottomRight,
                             colors: isDark
                               ? [
                                   Colors.white.withValues(alpha: 0.12),
                                   Colors.white.withValues(alpha: 0.08),
                                   Colors.white.withValues(alpha: 0.05),
                                   Colors.white.withValues(alpha: 0.02),
                                 ]
                               : [
                                   Colors.white.withValues(alpha: 0.9),
                                   Colors.white.withValues(alpha: 0.8),
                                   Colors.white.withValues(alpha: 0.7),
                                   Colors.white.withValues(alpha: 0.6),
                                 ],
                             stops: const [0.0, 0.33, 0.66, 1.0],
                           ),
                           borderRadius: BorderRadius.circular(25),
                           border: Border.all(
                             color: isDark
                               ? Colors.white.withValues(alpha: 0.15)
                               : Colors.white.withValues(alpha: 0.4),
                             width: 1.5,
                           ),
                           boxShadow: [
                             BoxShadow(
                               color: isDark 
                                 ? Colors.black.withValues(alpha: 0.2)
                                 : Colors.black.withValues(alpha: 0.1),
                               blurRadius: 20,
                               offset: const Offset(0, 8),
                               spreadRadius: 3,
                             ),
                           ],
                         ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Share functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Sharing ${widget.tip.title}...'),
                                      backgroundColor: AppColors.accentDark,
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.share_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Share',
                                  style: TextStyle(
                                    color: Colors.white,
              fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: AppColors.getOSColor(widget.tip.os),
                                   foregroundColor: Colors.white,
                                   padding: const EdgeInsets.symmetric(vertical: 18),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(18),
                                   ),
                                   elevation: 12,
                                   shadowColor: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.5),
                                 ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Copy functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied to clipboard!'),
                                      backgroundColor: AppColors.accentDark,
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.copy_rounded,
                                  size: 20,
                                  color: AppColors.getOSColor(widget.tip.os),
                                ),
                                label: Text(
                                  'Copy',
                                  style: TextStyle(
                                    color: AppColors.getOSColor(widget.tip.os),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: Colors.transparent,
                                   foregroundColor: AppColors.getOSColor(widget.tip.os),
                                   padding: const EdgeInsets.symmetric(vertical: 18),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(18),
                                     side: BorderSide(
                                       color: AppColors.getOSColor(widget.tip.os),
                                       width: 2.5,
                                     ),
                                   ),
                                   elevation: 0,
                                 ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ],
      ),
        );
      },
    );
  }

  /// Build ultra-premium step with enhanced design
  Widget _buildUltraPremiumStep(BuildContext context, int index, String step, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ultra-premium step number with glow effect
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accentDark,
                  AppColors.accentDark.withValues(alpha: 0.9),
                  AppColors.accentDark.withValues(alpha: 0.8),
                  AppColors.getOSColor(widget.tip.os),
                  AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentDark.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: AppColors.accentDark.withValues(alpha: 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: -0.8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Ultra-premium step content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                    ? [
                        Colors.white.withValues(alpha: 0.12),
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.05),
                        Colors.white.withValues(alpha: 0.02),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.85),
                        Colors.white.withValues(alpha: 0.75),
                        Colors.white.withValues(alpha: 0.65),
                      ],
                  stops: const [0.0, 0.33, 0.66, 1.0],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                      ? Colors.black.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                step,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                  height: 1.8,
                  fontSize: 17,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium favorite button with sophisticated animations
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
  late AnimationController _tapController;
  late AnimationController _favoriteController;
  late AnimationController _glowController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _favoriteScaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeInOut,
    ));

    _favoriteScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.elasticOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeOutCubic,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _tapController.dispose();
    _favoriteController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_PremiumFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      if (widget.isFavorite) {
        _favoriteController.forward();
        _glowController.forward();
      } else {
        _favoriteController.reverse();
        _glowController.reverse();
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
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_tapController, _favoriteController, _glowController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isFavorite
                    ? [
                        AppColors.favoriteRed.withValues(alpha: 0.1),
                        AppColors.favoriteRed.withValues(alpha: 0.05),
                      ]
                    : [
                        Colors.transparent,
                        Colors.transparent,
                      ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.isFavorite ? [
                  BoxShadow(
                    color: AppColors.favoriteRed.withValues(alpha: 0.3 * _glowAnimation.value),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
              child: Transform.scale(
                scale: _favoriteScaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 3.14159 * 2,
                child: Icon(
                    widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 24,
                  color: widget.isFavorite 
                    ? AppColors.favoriteRed 
                    : (Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white.withValues(alpha: 0.7)
                        : Colors.grey.shade600),
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

