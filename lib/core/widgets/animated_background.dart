import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_colors.dart';

/// Animated background with floating geometric shapes
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final String? osTheme;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.osTheme,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<FloatingShape> _shapes;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _shapes = List.generate(8, (index) => FloatingShape(
      index: index,
      osTheme: widget.osTheme,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated background shapes
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: FloatingShapesPainter(
                animation: _controller,
                shapes: _shapes,
                isDark: Theme.of(context).brightness == Brightness.dark,
              ),
              size: Size.infinite,
            );
          },
        ),
        // Main content
        widget.child,
      ],
    );
  }
}

class FloatingShape {
  final int index;
  final String? osTheme;
  late double x;
  late double y;
  late double size;
  late double speed;
  late Color color;
  late ShapeType type;

  FloatingShape({required this.index, this.osTheme}) {
    final random = math.Random(index);
    x = random.nextDouble();
    y = random.nextDouble();
    size = 20 + random.nextDouble() * 60;
    speed = 0.1 + random.nextDouble() * 0.3;
    
    // Choose color based on OS theme or use neutral colors
    if (osTheme != null) {
      color = AppColors.getOSColor(osTheme!).withValues(alpha: 0.03);
    } else {
      final colors = [
        AppColors.primary.withValues(alpha: 0.02),
        AppColors.secondary.withValues(alpha: 0.02),
        AppColors.accent.withValues(alpha: 0.02),
      ];
      color = colors[random.nextInt(colors.length)];
    }
    
    type = ShapeType.values[random.nextInt(ShapeType.values.length)];
  }
}

enum ShapeType { circle, square, triangle, diamond }

class FloatingShapesPainter extends CustomPainter {
  final Animation<double> animation;
  final List<FloatingShape> shapes;
  final bool isDark;

  FloatingShapesPainter({
    required this.animation,
    required this.shapes,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    for (final shape in shapes) {
      final progress = (animation.value + shape.index * 0.1) % 1.0;
      final x = (shape.x + progress * shape.speed) % 1.0 * size.width;
      final y = (shape.y + math.sin(progress * math.pi * 2) * 0.1) * size.height;

      paint.color = isDark 
        ? shape.color.withValues(alpha: shape.color.alpha * 0.5)
        : shape.color;

      switch (shape.type) {
        case ShapeType.circle:
          canvas.drawCircle(
            Offset(x, y),
            shape.size / 2,
            paint,
          );
          break;
        case ShapeType.square:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(x, y),
              width: shape.size,
              height: shape.size,
            ),
            paint,
          );
          break;
        case ShapeType.triangle:
          final path = Path();
          path.moveTo(x, y - shape.size / 2);
          path.lineTo(x - shape.size / 2, y + shape.size / 2);
          path.lineTo(x + shape.size / 2, y + shape.size / 2);
          path.close();
          canvas.drawPath(path, paint);
          break;
        case ShapeType.diamond:
          final path = Path();
          path.moveTo(x, y - shape.size / 2);
          path.lineTo(x + shape.size / 2, y);
          path.lineTo(x, y + shape.size / 2);
          path.lineTo(x - shape.size / 2, y);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant FloatingShapesPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
