import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Premium glassmorphism container with blur effects and gradients
class GlassmorphismContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final double blur;
  final double opacity;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  
  const GlassmorphismContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradient,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.border,
    this.boxShadow,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: gradient ?? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark 
                    ? Colors.white.withOpacity(opacity)
                    : Colors.white.withOpacity(opacity + 0.1),
                  isDark
                    ? Colors.white.withOpacity(opacity * 0.5)
                    : Colors.white.withOpacity(opacity * 0.8),
                ],
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              border: border ?? Border.all(
                color: isDark 
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: boxShadow ?? [
                BoxShadow(
                  color: isDark 
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Premium floating card with glassmorphism effects
class PremiumCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final bool animated;
  final Gradient? gradient;
  
  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation = 8.0,
    this.animated = true,
    this.gradient,
  });
  
  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
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
    
    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation * 1.5,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: widget.margin ?? const EdgeInsets.all(8),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.animated ? _scaleAnimation.value : 1.0,
            child: GestureDetector(
              onTapDown: widget.animated ? (_) => _controller.forward() : null,
              onTapUp: (_) {
                if (widget.animated) _controller.reverse();
                widget.onTap?.call();
              },
              onTapCancel: widget.animated ? () => _controller.reverse() : null,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: widget.gradient ?? (isDark 
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A1A2E),
                          Color(0xFF16213E),
                        ],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Color(0xFFF8FAFC),
                        ],
                      )),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                        ? Colors.black.withOpacity(0.4)
                        : AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                    BoxShadow(
                      color: isDark
                        ? AppColors.secondary.withValues(alpha: 0.1)
                        : AppColors.secondary.withValues(alpha: 0.05),
                      blurRadius: _elevationAnimation.value * 2,
                      offset: Offset(0, _elevationAnimation.value),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(16),
                    child: widget.child,
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
