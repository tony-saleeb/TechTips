import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Simple System Online screen - shows only the "SYSTEM ONLINE" part
class SystemOnlineScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const SystemOnlineScreen({super.key, this.onComplete});

  @override
  State<SystemOnlineScreen> createState() => _SystemOnlineScreenState();
}

class _SystemOnlineScreenState extends State<SystemOnlineScreen>
    with TickerProviderStateMixin {
  late AnimationController _completionController;
  late AnimationController _textRevealController;
  
  late Animation<double> _completionScale;
  late Animation<double> _completionOpacity;
  late Animation<double> _textSlide;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _completionController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _textRevealController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _completionScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _completionController,
      curve: Curves.easeOutCubic,
    ));
    
    _completionOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _completionController,
      curve: Curves.easeInOut,
    ));
    
    _textSlide = Tween<double>(
      begin: 60.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textRevealController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimationSequence() async {
    // Start completion scale and opacity
    _completionController.forward();
    
    // Wait for completion to start, then reveal text
    await Future.delayed(const Duration(milliseconds: 800));
    _textRevealController.forward();

    // Wait for all animations to complete, then proceed
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _completionController.dispose();
    _textRevealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1200;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: AnimatedBuilder(
        animation: _completionController,
        builder: (context, child) {
          return Container(
            color: isDark ? Colors.black : Colors.white.withValues(alpha: 0.98),
            child: Center(
              child: Transform.scale(
                scale: _completionScale.value,
                child: Opacity(
                  opacity: _completionOpacity.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Creative tech keyboard key with enhanced effects
                      AnimatedBuilder(
                        animation: _completionController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _completionOpacity.value,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Ultra-smooth outer glow with perfect blue-to-gray transition
                                Container(
                                  width: isMobile ? 180 : isTablet ? 220 : 260,
                                  height: isMobile ? 180 : isTablet ? 220 : 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                        const Color(0xFF0891B2).withValues(alpha: 0.18 * _completionOpacity.value),
                                        const Color(0xFF0E7490).withValues(alpha: 0.14 * _completionOpacity.value),
                                        const Color(0xFF155E75).withValues(alpha: 0.11 * _completionOpacity.value),
                                        const Color(0xFF1E3A8A).withValues(alpha: 0.08 * _completionOpacity.value),
                                        const Color(0xFF334155).withValues(alpha: 0.06 * _completionOpacity.value),
                                        const Color(0xFF475569).withValues(alpha: 0.04 * _completionOpacity.value),
                                        const Color(0xFF64748B).withValues(alpha: 0.03 * _completionOpacity.value),
                                        const Color(0xFF6B7280).withValues(alpha: 0.02 * _completionOpacity.value),
                                    Colors.transparent,
                                  ],
                                      stops: const [0.0, 0.15, 0.28, 0.4, 0.52, 0.64, 0.76, 0.88, 1.0],
                                    ),
                                  ),
                                ),
                                
                                // Premium container with sophisticated styling
                                Container(
                                  width: isMobile ? 160 : isTablet ? 200 : 240,
                                  height: isMobile ? 160 : isTablet ? 200 : 240,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: const Color(0xFF0E7490).withValues(alpha: 0.4 * _completionOpacity.value),
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0891B2).withValues(alpha: 0.25 * _completionOpacity.value),
                                        blurRadius: 25,
                                        spreadRadius: 8,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF155E75).withValues(alpha: 0.15 * _completionOpacity.value),
                                        blurRadius: 35,
                                        spreadRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: CustomPaint(
                                    painter: CreativeTechKeyPainter(
                                      progress: _completionOpacity.value,
                                      isDark: isDark,
                                      size: isMobile ? 160 : isTablet ? 200 : 240,
                                      animationValue: _completionController.value,
                                    ),
                                  ),
                                ),
                                
                                // Premium floating particles with sophisticated colors
                                ...List.generate(12, (index) {
                                  final angle = (index * 30.0) * (3.14159 / 180);
                                  final radius = (isMobile ? 100 : isTablet ? 120 : 140) * _completionOpacity.value;
                                  final x = radius * math.cos(angle);
                                  final y = radius * math.sin(angle);
                                  
                                  // Premium color palette with more variety
                                  final particleColors = [
                                    const Color(0xFF0891B2), // Rich cyan
                                    const Color(0xFF0E7490), // Deeper cyan
                                    const Color(0xFF155E75), // Dark blue-gray
                                    const Color(0xFF374151), // Sophisticated gray
                                    const Color(0xFF4B5563), // Medium gray
                                    const Color(0xFF6B7280), // Warm gray
                                  ];
                                  final particleColor = particleColors[index % particleColors.length];
                                  final particleSize = 2.5 + (index % 3) * 0.5; // Varying sizes: 2.5, 3.0, 3.5
                                  
                                  return Transform.translate(
                                    offset: Offset(x, y),
                                    child: Container(
                                      width: particleSize,
                                      height: particleSize,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: particleColor.withValues(alpha: 0.9 * _completionOpacity.value),
                                        boxShadow: [
                                          BoxShadow(
                                            color: particleColor.withValues(alpha: 0.6 * _completionOpacity.value),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: isMobile ? 40 : isTablet ? 50 : 60),
                      
                      // Main title - premium tech style
                      AnimatedBuilder(
                        animation: _textRevealController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _textSlide.value),
                            child: Column(
                              children: [
                                Text(
                                  'TECHTIPS',
                                  style: TextStyle(
                                    fontSize: isMobile ? 28 : isTablet ? 32 : 36,
                                    fontWeight: FontWeight.w300,
                                    color: isDark 
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : Colors.black.withValues(alpha: 0.6),
                                    letterSpacing: isMobile ? 6 : isTablet ? 8 : 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: isMobile ? 8 : isTablet ? 10 : 12),
                                
                                Text(
                                  'READY',
                                  style: TextStyle(
                                    fontSize: isMobile ? 48 : isTablet ? 56 : 64,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.cyan,
                                    letterSpacing: isMobile ? 8 : isTablet ? 12 : 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: isMobile ? 30 : isTablet ? 35 : 40),
                                
                                // Status line with smooth scale
                                AnimatedBuilder(
                                  animation: _textRevealController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scaleX: _textRevealController.value,
                                      child: Container(
                                        width: isMobile ? 150 : isTablet ? 180 : 200,
                                        height: isMobile ? 1.5 : isTablet ? 1.8 : 2,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.cyan,
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                SizedBox(height: isMobile ? 30 : isTablet ? 35 : 40),
                                
                                // Tech specs
                                Text(
                                  'TECHTIPS v1.0',
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : isTablet ? 18 : 20,
                                    color: isDark 
                                      ? Colors.white.withValues(alpha: 0.5)
                                      : Colors.black.withValues(alpha: 0.4),
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: isMobile ? 2 : isTablet ? 2.5 : 3,
                                  ),
                                ),
                                
                                SizedBox(height: isMobile ? 8 : isTablet ? 10 : 12),
                                
                                Text(
                                  'Tips & tricks loaded',
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : isTablet ? 16 : 18,
                                    color: isDark 
                                      ? Colors.white.withValues(alpha: 0.4)
                                      : Colors.black.withValues(alpha: 0.3),
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: isMobile ? 1 : isTablet ? 1.5 : 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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

/// Creative tech keyboard key painter with enhanced effects
class CreativeTechKeyPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final double size;
  final double animationValue;

  CreativeTechKeyPainter({
    required this.progress,
    required this.isDark,
    required this.size,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final keySize = size * 0.5; // Much larger key

    // Create ultra-smooth gradient with perfect blue-to-gray transition
    final keyPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF0891B2).withValues(alpha: 0.98 * progress), // Rich cyan center
          const Color(0xFF0E7490).withValues(alpha: 0.92 * progress), // Deeper cyan
          const Color(0xFF155E75).withValues(alpha: 0.85 * progress), // Dark blue-gray
          const Color(0xFF1E3A8A).withValues(alpha: 0.78 * progress), // Blue-gray transition
          const Color(0xFF334155).withValues(alpha: 0.72 * progress), // Blue-gray blend
          const Color(0xFF475569).withValues(alpha: 0.65 * progress), // Gray-blue blend
          const Color(0xFF64748B).withValues(alpha: 0.58 * progress), // Gray transition
          const Color(0xFF6B7280).withValues(alpha: 0.52 * progress), // Warm gray
          const Color(0xFF9CA3AF).withValues(alpha: 0.45 * progress), // Light gray
        ],
        stops: const [0.0, 0.15, 0.28, 0.4, 0.52, 0.64, 0.76, 0.88, 1.0],
      ).createShader(Rect.fromCenter(
        center: center,
        width: keySize,
        height: keySize,
      ));

    // Main key body with enhanced rounded corners
    final keyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: keySize,
        height: keySize,
      ),
      const Radius.circular(20),
    );
    
    canvas.drawRRect(keyRect, keyPaint);

    // Ultra-smooth outline with perfect blue-to-gray gradient
    final outlinePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF0891B2).withValues(alpha: 0.9 * progress),
          const Color(0xFF0E7490).withValues(alpha: 0.85 * progress),
          const Color(0xFF155E75).withValues(alpha: 0.8 * progress),
          const Color(0xFF1E3A8A).withValues(alpha: 0.75 * progress),
          const Color(0xFF334155).withValues(alpha: 0.7 * progress),
          const Color(0xFF475569).withValues(alpha: 0.65 * progress),
          const Color(0xFF64748B).withValues(alpha: 0.6 * progress),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCenter(
        center: center,
        width: keySize,
        height: keySize,
      ))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(keyRect, outlinePaint);

    // Enhanced shadow with multiple layers
    final shadowPaint1 = Paint()
      ..color = Colors.black.withValues(alpha: 0.3 * progress)
      ..style = PaintingStyle.fill;

    final shadowRect1 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 3, center.dy + 3),
        width: keySize,
        height: keySize,
      ),
      const Radius.circular(20),
    );
    
    canvas.drawRRect(shadowRect1, shadowPaint1);

    final shadowPaint2 = Paint()
      ..color = Colors.black.withValues(alpha: 0.1 * progress)
      ..style = PaintingStyle.fill;

    final shadowRect2 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 6, center.dy + 6),
        width: keySize,
        height: keySize,
      ),
      const Radius.circular(20),
    );
    
    canvas.drawRRect(shadowRect2, shadowPaint2);

    // Draw the enhanced key symbol with better typography
    final textPainter = TextPainter(
      text: TextSpan(
        text: '⌘',
        style: TextStyle(
          fontSize: keySize * 0.5, // Larger symbol
          fontWeight: FontWeight.w200,
          color: Colors.white.withValues(alpha: 0.95 * progress),
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.3 * progress),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    // Multiple highlights for 3D effect
    final highlightPaint1 = Paint()
      ..color = Colors.white.withValues(alpha: 0.4 * progress)
      ..style = PaintingStyle.fill;

    final highlightRect1 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - keySize * 0.25, center.dy - keySize * 0.25),
        width: keySize * 0.4,
        height: keySize * 0.4,
      ),
      const Radius.circular(12),
    );
    
    canvas.drawRRect(highlightRect1, highlightPaint1);

    final highlightPaint2 = Paint()
      ..color = Colors.white.withValues(alpha: 0.2 * progress)
      ..style = PaintingStyle.fill;

    final highlightRect2 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + keySize * 0.15, center.dy - keySize * 0.15),
        width: keySize * 0.25,
        height: keySize * 0.25,
      ),
      const Radius.circular(8),
    );
    
    canvas.drawRRect(highlightRect2, highlightPaint2);

    // Enhanced tech-style corner accents with animation
    final accentPaint = Paint()
      ..color = const Color(0xFF0891B2).withValues(alpha: 0.8 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final pulseEffect = 1.0 + (0.1 * math.sin(animationValue * 3 * math.pi));

    // Top-left accent with pulse
    final accentSize = keySize * 0.3 * pulseEffect;
    canvas.drawLine(
      Offset(center.dx - keySize * 0.45, center.dy - keySize * 0.45),
      Offset(center.dx - accentSize, center.dy - keySize * 0.45),
      accentPaint,
    );
    canvas.drawLine(
      Offset(center.dx - keySize * 0.45, center.dy - keySize * 0.45),
      Offset(center.dx - keySize * 0.45, center.dy - accentSize),
      accentPaint,
    );

    // Bottom-right accent with pulse
    canvas.drawLine(
      Offset(center.dx + keySize * 0.45, center.dy + keySize * 0.45),
      Offset(center.dx + accentSize, center.dy + keySize * 0.45),
      accentPaint,
    );
    canvas.drawLine(
      Offset(center.dx + keySize * 0.45, center.dy + keySize * 0.45),
      Offset(center.dx + keySize * 0.45, center.dy + accentSize),
      accentPaint,
    );

    // Add corner dots for extra tech feel
    final dotPaint = Paint()
      ..color = const Color(0xFF0891B2).withValues(alpha: 0.8 * progress)
      ..style = PaintingStyle.fill;

    // Corner dots
    canvas.drawCircle(Offset(center.dx - keySize * 0.4, center.dy - keySize * 0.4), 3, dotPaint);
    canvas.drawCircle(Offset(center.dx + keySize * 0.4, center.dy - keySize * 0.4), 3, dotPaint);
    canvas.drawCircle(Offset(center.dx - keySize * 0.4, center.dy + keySize * 0.4), 3, dotPaint);
    canvas.drawCircle(Offset(center.dx + keySize * 0.4, center.dy + keySize * 0.4), 3, dotPaint);

    // Ultra-smooth inner glow with perfect blue-to-gray transition
    final innerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF0891B2).withValues(alpha: 0.5 * progress),
          const Color(0xFF0E7490).withValues(alpha: 0.4 * progress),
          const Color(0xFF155E75).withValues(alpha: 0.32 * progress),
          const Color(0xFF1E3A8A).withValues(alpha: 0.25 * progress),
          const Color(0xFF334155).withValues(alpha: 0.18 * progress),
          const Color(0xFF475569).withValues(alpha: 0.12 * progress),
          const Color(0xFF64748B).withValues(alpha: 0.08 * progress),
          const Color(0xFF6B7280).withValues(alpha: 0.05 * progress),
          Colors.transparent,
        ],
        stops: const [0.0, 0.15, 0.28, 0.4, 0.52, 0.64, 0.76, 0.88, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: keySize * 0.35));

    canvas.drawCircle(center, keySize * 0.3, innerGlowPaint);

    // Removed circuit lines for cleaner appearance
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is CreativeTechKeyPainter &&
        (oldDelegate.progress != progress || 
         oldDelegate.isDark != isDark || 
         oldDelegate.animationValue != animationValue);
  }
}
