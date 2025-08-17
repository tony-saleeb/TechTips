import 'package:flutter/material.dart';
import '../../domain/entities/tip_entity.dart';
import 'minimal_tip_card.dart';

/// Instant tips list with no delays
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
    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh?.call();
      },
      child: ListView.builder(
        key: ValueKey('tips_${widget.os}_${widget.tips.length}'),
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 80, // Space for FAB
        ),
        itemCount: widget.tips.length,
        // Performance optimizations for fast scrolling
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) {
          final tip = widget.tips[index];
          
          // Completely instant display - no animations at all
          return MinimalTipCard(
            tip: tip,
            index: index,
          );
        },
      ),
    );
  }
}
