import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/tip_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/utils/extensions.dart';
import '../viewmodels/tips_viewmodel.dart';

/// Enhanced professional tip card with subtle visual elements
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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Staggered entrance animation
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Consumer<TipsViewModel>(
        builder: (context, tipsViewModel, _) {
          final isFavorite = tipsViewModel.isFavorite(widget.tip.id);
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isHovered ? _scaleAnimation.value : 1.0,
                    child: Material(
                      color: Colors.transparent,
                      elevation: _isHovered ? 8 : 0,
                      borderRadius: BorderRadius.circular(16),
                      shadowColor: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                      child: InkWell(
                        onTap: widget.onTap ?? () => _navigateToDetails(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                ? [
                                    AppColors.cardDark,
                                    const Color(0xFF2A2A35),
                                    AppColors.cardDark.withValues(alpha: 0.9),
                                  ]
                                : [
                                    Colors.white,
                                    const Color(0xFFFBFBFD),
                                    const Color(0xFFF8F9FC),
                                  ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _isHovered 
                                ? AppColors.accentDark.withValues(alpha: 0.6)
                                : (isDark 
                                    ? const Color(0xFF404050) 
                                    : const Color(0xFFE8E9F3)),
                              width: _isHovered ? 3 : 1.5,
                            ),
                            boxShadow: [
                              // Main elevated shadow
                              BoxShadow(
                                color: isDark 
                                  ? Colors.black.withValues(alpha: 0.6)
                                  : const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                                blurRadius: _isHovered ? 32 : 16,
                                offset: Offset(0, _isHovered ? 12 : 6),
                                spreadRadius: _isHovered ? 4 : 0,
                              ),
                              // Accent glow when hovered
                              if (_isHovered) ...[
                                BoxShadow(
                                  color: AppColors.accentDark.withValues(alpha: 0.4),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),

                              ],

                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with OS badge and favorite button
                              Row(
                                children: [
                                  _buildEnhancedOSBadge(context),
                                  const Spacer(),
                                  _buildEnhancedFavoriteButton(context, isFavorite, tipsViewModel),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Ultra-premium title
                              Container(
                                padding: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      (isDark ? AppColors.textDarkPrimary : AppColors.textPrimary).withValues(alpha: 0.1),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Text(
                                  widget.tip.title,
                                  style: context.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                                    height: 1.1,
                                    letterSpacing: -0.5,
                                    fontSize: 22,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Premium description
                              Text(
                                widget.tip.description,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                                  height: 1.7,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Enhanced tags
                              if (widget.tip.tags.isNotEmpty) ...[
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: widget.tip.tags.take(3).map((tag) => _buildEnhancedTag(context, tag)).toList(),
                                ),
                                const SizedBox(height: 16),
                              ],
                              
                              // Enhanced footer with better visual hierarchy
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.getOSLightColor(widget.tip.os),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.format_list_bulleted,
                                        size: 14,
                                        color: AppColors.getOSColor(widget.tip.os),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${widget.tip.steps.length} steps',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: AppColors.getOSColor(widget.tip.os),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.getOSColor(widget.tip.os),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        size: 12,
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
                  );
                },
              ),
            ),
          );
        },
      ),

    );
  }

  /// Build enhanced OS badge with better visual design
  Widget _buildEnhancedOSBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentDark,
            AppColors.accentDark.withValues(alpha: 0.7),
            AppColors.accentDark.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentDark.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),

        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              AppIcons.getOSIcon(widget.tip.os),
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _getOSDisplayName(widget.tip.os),
            style: context.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Build perfect favorite button with sophisticated animations
  Widget _buildEnhancedFavoriteButton(BuildContext context, bool isFavorite, TipsViewModel tipsViewModel) {
    return _PerfectFavoriteButton(
      isFavorite: isFavorite,
      onPressed: () => _toggleFavorite(context, tipsViewModel),
    );
  }

  /// Build enhanced tag with better visual design
  Widget _buildEnhancedTag(BuildContext context, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.surfaceVariant,
            context.colorScheme.surfaceVariant.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        tag,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w600,
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
      // Add subtle haptic feedback
      // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }





  /// Navigate to tip details
  void _navigateToDetails(BuildContext context) {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildTipDetailsSheet(context),
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

  /// Build tip details bottom sheet
  Widget _buildTipDetailsSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
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
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.accentDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    _buildEnhancedOSBadge(context),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.tip.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tip.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Steps:',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...widget.tip.steps.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.accentDark,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
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
}

/// Perfect favorite button with sophisticated animations and interactions
class _PerfectFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _PerfectFavoriteButton({
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  State<_PerfectFavoriteButton> createState() => _PerfectFavoriteButtonState();
}

class _PerfectFavoriteButtonState extends State<_PerfectFavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController _tapController;
  late AnimationController _favoriteController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _favoriteScaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeInOut,
    ));

    _favoriteScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _tapController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_PerfectFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      if (widget.isFavorite) {
        _favoriteController.forward();
      } else {
        _favoriteController.reverse();
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
        animation: Listenable.merge([_tapController, _favoriteController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Transform.scale(
                scale: _favoriteScaleAnimation.value,
                child: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: widget.isFavorite 
                    ? AppColors.favoriteRed 
                    : (Theme.of(context).brightness == Brightness.dark 
                        ? Colors.white 
                        : Colors.grey.shade600),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

