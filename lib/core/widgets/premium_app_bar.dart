import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/animation_extensions.dart';

/// Premium app bar with glassmorphism and gradient effects
class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Gradient? gradient;
  final double elevation;
  final bool showBlur;
  
  const PremiumAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.gradient,
    this.elevation = 0,
    this.showBlur = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark 
          ? AppColors.backgroundDark 
          : AppColors.backgroundLight,
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: showBlur 
            ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: AppBar(
            title: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ).createShader(bounds),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            centerTitle: centerTitle,
            backgroundColor: isDark 
                      ? Colors.black.withValues(alpha: 0.1)
        : Colors.white.withValues(alpha: 0.1),
            elevation: elevation,
            leading: leading,
            actions: actions?.map((action) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                              Colors.white.withValues(alpha: 0.1),
        Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: action,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Premium floating action button with gradient and glow
class PremiumFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String? tooltip;
  final String? heroTag;
  final Gradient? gradient;
  final bool extended;
  final String? label;
  final Widget? icon;
  
  const PremiumFAB({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
    this.heroTag,
    this.gradient,
    this.extended = false,
    this.label,
    this.icon,
  });
  
  const PremiumFAB.extended({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.tooltip,
    this.heroTag,
    this.gradient,
  }) : child = const SizedBox(),
       extended = true;
  
  @override
  State<PremiumFAB> createState() => _PremiumFABState();
}

class _PremiumFABState extends State<PremiumFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.primary;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (mounted) {
                _controller.safeForward();
              }
            },
            onTapUp: (_) {
              if (mounted) {
                _controller.safeReverse();
              }
              widget.onPressed();
            },
            onTapCancel: () {
              if (mounted) {
                _controller.safeReverse();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(widget.extended ? 28 : 28),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withValues(alpha: _glowAnimation.value * 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: backgroundColor.withValues(alpha: _glowAnimation.value * 0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: widget.extended
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.icon ?? const SizedBox(),
                        const SizedBox(width: 12),
                        Text(
                          widget.label ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: widget.child,
                  ),
            ),
          ),
        );
      },
    );
  }
}
