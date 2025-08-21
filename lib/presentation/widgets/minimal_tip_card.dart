import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/tip_entity.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/utils/extensions.dart';
import '../viewmodels/tips_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';

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
    
    return Consumer<TipsViewModel>(
        builder: (context, tipsViewModel, _) {
          final isFavorite = tipsViewModel.isFavorite(widget.tip.id);
          
          return Container(
          margin: context.rse(horizontal: 20, vertical: 12),
          child: GestureDetector(
            onTap: _onTap,
                        child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.rbr(28)),
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                ],
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
    return Consumer<SettingsViewModel>(
      builder: (context, settingsViewModel, _) {
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(context.rbr(40))),
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
              // Handle bar indicator
              Container(
                margin: context.ro(top: 24),
                width: context.rw(80),
                height: context.rh(8),
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
                  borderRadius: BorderRadius.circular(context.rbr(6)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
              
              // Premium header container with enhanced design
              Container(
                margin: context.re(28),
                padding: context.re(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                      ? [
                          AppColors.accentDark.withValues(alpha: 0.1),
                          AppColors.accentDark.withValues(alpha: 0.05),
                          AppColors.surfaceDark.withValues(alpha: 0.8),
                        ]
                      : [
                          AppColors.accentDark.withValues(alpha: 0.08),
                          AppColors.accentDark.withValues(alpha: 0.03),
                          AppColors.neutral50.withValues(alpha: 0.9),
                        ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                                    borderRadius: BorderRadius.circular(context.rbr(24)),
                  border: Border.all(
                    color: isDark 
                      ? AppColors.accentDark.withValues(alpha: 0.3)
                      : AppColors.accentDark.withValues(alpha: 0.2),
                    width: context.rw(2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                        ? AppColors.accentDark.withValues(alpha: 0.2)
                        : AppColors.accentDark.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: isDark 
                        ? Colors.black.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // OS Badge with enhanced design
                    Row(
                      children: [
                        // Enhanced OS Icon Container
                        Container(
                          padding: context.re(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                                AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.rbr(16)),
                            border: Border.all(
                              color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.4),
                              width: context.rw(2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                                                     child: Icon(
                             AppIcons.getOSIcon(widget.tip.os),
                             size: context.ri(24),
                             color: AppColors.getOSColor(widget.tip.os),
                           ),
                        ),
                        context.rsb(width: 16),
                        // Enhanced OS Name Badge
                        Container(
                          padding: context.rse(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.15),
                                AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(context.rbr(20)),
                            border: Border.all(
                              color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.4),
                              width: context.rw(1.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            _getOSDisplayName(widget.tip.os),
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.getOSColor(widget.tip.os),
                              fontWeight: FontWeight.w800,
                              fontSize: context.rs(14),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Tip Type Indicator
                        Container(
                          padding: context.rse(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark 
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.8),
                                                        borderRadius: BorderRadius.circular(context.rbr(12)),
                            border: Border.all(
                              color: isDark 
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.6),
                              width: context.rw(1),
                            ),
      ),
                          child: Text(
                            'Tip',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isDark 
                                ? Colors.white.withValues(alpha: 0.8)
                                : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: context.rs(11),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    context.rsb(height: 20),
                    // Enhanced Title
                    Text(
                      widget.tip.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: isDark 
                          ? Colors.white
                          : AppColors.textPrimary,
                        fontSize: context.rs(22),
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    context.rsb(height: 8),
                    // Subtitle with step count
                    Row(
        children: [
                        Icon(
                          Icons.format_list_numbered_rounded,
                          size: context.ri(16),
                          color: isDark 
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppColors.textSecondary,
                        ),
                        context.rsb(width: 8),
          Text(
                          '${widget.tip.steps.length} steps to master',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark 
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: context.rs(14),
                            letterSpacing: 0.2,
                          ),
          ),
        ],
      ),
                  ],
                ),
              ),
              
              // Ultra-premium content with enhanced animations
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: context.rse(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                             // Premium description card
                       Container(
                         margin: context.ro(bottom: 36),
                         padding: context.re(28),
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
                           borderRadius: BorderRadius.circular(context.rbr(25)),
                           border: Border.all(
                             color: AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.25),
                             width: context.rw(1.5),
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
                                  padding: context.re(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.getOSColor(widget.tip.os),
                                        AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(context.rbr(10)),
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
                                    size: context.ri(18),
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
                         margin: context.ro(bottom: 36),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Container(
                               padding: context.re(20),
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
                                 borderRadius: BorderRadius.circular(context.rbr(20)),
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
                                     padding: context.re(12),
                                     decoration: BoxDecoration(
                                       color: Colors.white.withValues(alpha: 0.2),
                                       borderRadius: BorderRadius.circular(context.rbr(15)),
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
                                         size: context.ri(24),
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
                                         fontSize: context.rs(22),
                                         letterSpacing: -0.5,
                                       ),
                                     ),
                                   ),
                                   Container(
                                     padding: context.rse(horizontal: 12, vertical: 6),
                                     decoration: BoxDecoration(
                                       color: Colors.white.withValues(alpha: 0.2),
                                       borderRadius: BorderRadius.circular(context.rbr(12)),
                                     ),
                                     child: Text(
                                       '${widget.tip.steps.length}',
                                       style: TextStyle(
                                         color: Colors.white,
                                         fontWeight: FontWeight.w900,
                                         fontSize: context.rs(16),
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             context.rsb(height: 28),
                            ...widget.tip.steps.asMap().entries.map(
                              (entry) => _buildUltraPremiumStep(context, entry.key, entry.value, isDark),
                            ),
                          ],
                        ),
                      ),
                      
                      // Premium tags section
                      if (widget.tip.tags.isNotEmpty) ...[
                        Container(
                          margin: context.ro(bottom: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: context.re(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.getOSColor(widget.tip.os),
                                          AppColors.getOSColor(widget.tip.os).withValues(alpha: 0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(context.rbr(10)),
                                    ),
                                                                          child: Icon(
                                        Icons.label_rounded,
                                        size: context.ri(18),
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
                         margin: context.ro(bottom: 50),
                         padding: context.re(28),
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
                           borderRadius: BorderRadius.circular(context.rbr(25)),
                           border: Border.all(
                             color: isDark
                               ? Colors.white.withValues(alpha: 0.15)
                               : Colors.white.withValues(alpha: 0.4),
                             width: context.rw(1.5),
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
                                  size: context.ri(20),
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Share',
                                                                    style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: context.rs(16),
                                  ),
                                ),
                                                                 style: ElevatedButton.styleFrom(
                                   backgroundColor: AppColors.getOSColor(widget.tip.os),
                                   foregroundColor: Colors.white,
                                   padding: const EdgeInsets.symmetric(vertical: 18),
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(context.rbr(18)),
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
                                  size: context.ri(20),
                                  color: AppColors.getOSColor(widget.tip.os),
                                ),
                                label: Text(
                                  'Copy',
                                  style: TextStyle(
                                    color: AppColors.getOSColor(widget.tip.os),
                                    fontWeight: FontWeight.w700,
                                    fontSize: context.rs(16),
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
      },
    );
  }

  /// Build ultra-premium step with enhanced design
  Widget _buildUltraPremiumStep(BuildContext context, int index, String step, bool isDark) {
    return Container(
      margin: context.ro(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ultra-premium step number with glow effect
          Container(
            width: context.rw(48),
            height: context.rh(48),
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: context.rs(20),
                  letterSpacing: -0.8,
                ),
              ),
            ),
          ),
          context.rsb(width: 24),
          // Ultra-premium step content
          Expanded(
            child: Container(
              padding: context.re(24),
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
                borderRadius: BorderRadius.circular(context.rbr(22)),
                border: Border.all(
                  color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.4),
                  width: context.rw(1.5),
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
                  fontSize: context.rs(17),
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
              padding: context.re(12),
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
                borderRadius: BorderRadius.circular(context.rbr(16)),
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
                    size: context.ri(24),
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

