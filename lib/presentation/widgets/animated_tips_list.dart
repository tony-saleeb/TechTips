import 'package:flutter/material.dart';
import '../../domain/entities/tip_entity.dart';
import '../../core/utils/extensions.dart';
import 'minimal_tip_card.dart';

/// Optimized tips list with instant loading and smooth scrolling
class AnimatedTipsList extends StatefulWidget {
  final List<TipEntity> tips;
  final String os;
  final VoidCallback? onRefresh;
  
  const AnimatedTipsList({
    super.key,
    required this.tips,
    required this.os,
    this.onRefresh,
  });

  @override
  State<AnimatedTipsList> createState() => _AnimatedTipsListState();
}

class _AnimatedTipsListState extends State<AnimatedTipsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: ValueKey('tips_${widget.os}_${widget.tips.length}'),
        padding: context.ro(
          top: 8,
          bottom: 100, // Space for bottom nav
        ),
        itemCount: widget.tips.length,
        // Ultra performance optimizations for smooth scrolling
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        cacheExtent: 3000, // Cache more items for smoother scrolling
        itemExtent: null, // Let Flutter calculate item heights
        physics: const ClampingScrollPhysics(), // Better performance
        itemBuilder: (context, index) {
          final tip = widget.tips[index];
          
          // Instant display with minimal overhead
          return RepaintBoundary(
            child: MinimalTipCard(
              key: ValueKey('tip_${tip.id}'),
              tip: tip,
              index: index,
            ),
          );
        },
    );
  }
}
