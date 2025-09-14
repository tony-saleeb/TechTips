import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Beautiful skeleton loading widget for tip cards
class TipCardSkeleton extends StatefulWidget {
  final int index;
  
  const TipCardSkeleton({
    super.key,
    required this.index,
  });

  @override
  State<TipCardSkeleton> createState() => _TipCardSkeletonState();
}

class _TipCardSkeletonState extends State<TipCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark 
              ? AppColors.surfaceDark.withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with OS badge and favorite button
                Row(
                  children: [
                    // OS badge skeleton
                    Container(
                      width: 80,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _getShimmerColor(isDark),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const Spacer(),
                    // Favorite button skeleton
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getShimmerColor(isDark),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Title skeleton
                Container(
                  width: double.infinity,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getShimmerColor(isDark),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Description skeleton (2 lines)
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getShimmerColor(isDark),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getShimmerColor(isDark),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Tags skeleton
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getShimmerColor(isDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getShimmerColor(isDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 70,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getShimmerColor(isDark),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Color _getShimmerColor(bool isDark) {
    final shimmerValue = _shimmerAnimation.value;
    final baseColor = isDark 
      ? AppColors.surfaceDark.withValues(alpha: 0.3)
      : Colors.grey.withValues(alpha: 0.2);
    
    final shimmerColor = isDark
      ? AppColors.surfaceDark.withValues(alpha: 0.6)
      : Colors.grey.withValues(alpha: 0.4);
    
    if (shimmerValue < 0 || shimmerValue > 1) {
      return baseColor;
    }
    
    return Color.lerp(baseColor, shimmerColor, shimmerValue)!;
  }
}

/// Skeleton list widget for multiple tip cards
class TipCardSkeletonList extends StatelessWidget {
  final int count;
  
  const TipCardSkeletonList({
    super.key,
    this.count = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: count,
      itemBuilder: (context, index) {
        return TipCardSkeleton(index: index);
      },
    );
  }
}
