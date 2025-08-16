import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Smart action button with different styles and optional badge
class SmartActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;
  final ActionButtonStyle style;
  final int? badge;

  const SmartActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
    required this.style,
    this.badge,
  });

  @override
  State<SmartActionButton> createState() => _SmartActionButtonState();
}

class _SmartActionButtonState extends State<SmartActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: widget.style == ActionButtonStyle.filled
                      ? widget.color
                      : widget.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: widget.style == ActionButtonStyle.outlined
                      ? Border.all(
                          color: widget.color.withValues(alpha: 0.3),
                          width: 1,
                        )
                      : null,
                    boxShadow: widget.style == ActionButtonStyle.filled ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.3 * _shadowAnimation.value),
                        blurRadius: 8 * _shadowAnimation.value,
                        offset: Offset(0, 4 * _shadowAnimation.value),
                      ),
                    ] : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon,
                        size: 18,
                        color: widget.style == ActionButtonStyle.filled
                          ? Colors.white
                          : widget.color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.label,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: widget.style == ActionButtonStyle.filled
                            ? Colors.white
                            : widget.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Badge
                if (widget.badge != null && widget.badge! > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.badge! > 99 ? '99+' : widget.badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

enum ActionButtonStyle { filled, outlined }
