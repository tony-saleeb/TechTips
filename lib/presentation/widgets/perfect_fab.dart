import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Perfect FAB widget with enhanced design and functionality
class PerfectFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final String heroTag;
  final Color backgroundColor;
  final IconData icon;
  final String? label;
  final int? badge;
  final String tooltip;
  final FABSize size;

  const PerfectFAB({
    super.key,
    required this.onPressed,
    required this.heroTag,
    required this.backgroundColor,
    required this.icon,
    required this.tooltip,
    required this.size,
    this.label,
    this.badge,
  });

  @override
  State<PerfectFAB> createState() => _PerfectFABState();
}

class _PerfectFABState extends State<PerfectFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  late Animation<double> _elevationAnimation;
  bool _isPressed = false;

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

    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size == FABSize.extended ? 28 : 28),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withValues(alpha: 0.3 * _shadowAnimation.value),
                    blurRadius: 12 * _shadowAnimation.value,
                    offset: Offset(0, 6 * _shadowAnimation.value),
                  ),
                  BoxShadow(
                    color: widget.backgroundColor.withValues(alpha: 0.1 * _shadowAnimation.value),
                    blurRadius: 24 * _shadowAnimation.value,
                    offset: Offset(0, 12 * _shadowAnimation.value),
                  ),
                  // Additional glow effect when pressed
                  if (_isPressed)
                    BoxShadow(
                      color: widget.backgroundColor.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 0),
                    ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main FAB
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(widget.size == FABSize.extended ? 28 : 28),
                    elevation: _elevationAnimation.value,
                    shadowColor: widget.backgroundColor,
                    child: widget.size == FABSize.extended && widget.label != null
                      ? FloatingActionButton.extended(
                          onPressed: null, // Handled by GestureDetector
                          heroTag: widget.heroTag,
                          backgroundColor: widget.backgroundColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          icon: Icon(widget.icon, size: 20),
                          label: Text(
                            widget.label!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      : FloatingActionButton(
                          onPressed: null, // Handled by GestureDetector
                          heroTag: widget.heroTag,
                          backgroundColor: widget.backgroundColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          child: Icon(widget.icon, size: 24),
                        ),
                  ),
                  
                  // Badge (if present)
                  if (widget.badge != null && widget.badge! > 0)
                    Positioned(
                      top: -6,
                      right: widget.size == FABSize.extended ? 8 : -6,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.error,
                              AppColors.error.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withValues(alpha: 0.4),
                              blurRadius: 6,
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
                  
                  // Gesture detector for custom press effects
                  Positioned.fill(
                    child: GestureDetector(
                      onTapDown: _onTapDown,
                      onTapUp: _onTapUp,
                      onTapCancel: _onTapCancel,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.size == FABSize.extended ? 28 : 28),
                          color: _isPressed 
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

enum FABSize { regular, extended }
