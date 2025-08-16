import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Custom loading indicator widget
class CustomLoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final String? message;
  
  const CustomLoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.message,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size ?? 40,
            height: size ?? 40,
            child: CircularProgressIndicator(
              color: color ?? AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
