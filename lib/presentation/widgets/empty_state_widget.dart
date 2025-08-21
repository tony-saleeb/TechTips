import 'package:flutter/material.dart';
import '../../core/utils/extensions.dart';
import '../../core/constants/app_colors.dart';

/// Enhanced empty state widget with animations and better visual design
class EmptyStateWidget extends StatefulWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final Widget? action;
  final String? osTheme;
  
  const EmptyStateWidget({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.action,
    this.osTheme,
  });

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _floatAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward().then((_) {
      _animationController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  

  
  @override
  Widget build(BuildContext context) {
    final osColor = widget.osTheme != null 
      ? AppColors.getOSColor(widget.osTheme!)
      : AppColors.primary;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Padding(
          padding: context.re(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated illustration container
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                                                 width: context.rw(120),
                         height: context.rh(120),
                         decoration: BoxDecoration(
                           gradient: LinearGradient(
                             begin: Alignment.topLeft,
                             end: Alignment.bottomRight,
                             colors: [
                               osColor.withValues(alpha: 0.15),
                               osColor.withValues(alpha: 0.05),
                             ],
                           ),
                           borderRadius: BorderRadius.circular(context.rbr(30)),
                           border: Border.all(
                             color: osColor.withValues(alpha: 0.2),
                             width: context.rw(2),
                           ),
                          boxShadow: [
                            BoxShadow(
                              color: osColor.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                                                 child: Icon(
                           widget.icon ?? Icons.info_outline,
                           size: context.ri(50),
                           color: osColor,
                         ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
                             // Enhanced title
               Text(
                 widget.title ?? 'Nothing Here',
                 style: context.textTheme.headlineSmall?.copyWith(
                   color: osColor,
                   fontWeight: FontWeight.w700,
                   letterSpacing: -0.5,
                   fontSize: context.rs(20),
                 ),
                 textAlign: TextAlign.center,
               ),
               
               context.rsb(height: 12),
              
                             // Enhanced message in container
               Container(
                 padding: context.rse(horizontal: 20, vertical: 16),
                 decoration: BoxDecoration(
                   color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                   borderRadius: BorderRadius.circular(context.rbr(12)),
                   border: Border.all(
                     color: context.colorScheme.outline.withValues(alpha: 0.2),
                     width: context.rw(1),
                   ),
                 ),
                 child: Text(
                   widget.message ?? 'There are no items to display.',
                   style: context.textTheme.bodyLarge?.copyWith(
                     color: context.colorScheme.onSurfaceVariant,
                     height: 1.5,
                     fontSize: context.rs(16),
                   ),
                   textAlign: TextAlign.center,
                 ),
               ),
              
              if (widget.action != null) ...[
                context.rsb(height: 32),
                widget.action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
