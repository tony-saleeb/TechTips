import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Visually stunning splash screen with beautiful animations
class MinimalSplashScreen extends StatefulWidget {
  const MinimalSplashScreen({super.key});

  @override
  State<MinimalSplashScreen> createState() => _MinimalSplashScreenState();
}

class _MinimalSplashScreenState extends State<MinimalSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _backgroundController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotation;
  late Animation<double> _logoElevation;
  late Animation<double> _logoGlow;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _backgroundOpacity;
  late Animation<double> _backgroundScale;
  late Animation<double> _particleOpacity;
  late Animation<double> _gradientRotation;

  final List<Offset> _particles = [];
  final List<double> _particleSizes = [];
  final List<Color> _particleColors = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateParticles();
  }

  void _initializeAnimations() {
    // Main orchestration controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Particle animation controller
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Logo animations with enhanced effects
    _logoScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _logoRotation = Tween<double>(
      begin: -0.3,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
    ));

    _logoElevation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    _logoGlow = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    // Text animations
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    _textSlide = Tween<double>(
      begin: 60.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));

    // Background animations
    _backgroundOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeOut,
    ));

    _backgroundScale = Tween<double>(
      begin: 1.2,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeOutCubic,
    ));

    _gradientRotation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));

    // Particle effects
    _particleOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    // Start animations in sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Start background first
    _backgroundController.forward();
    
    // Wait a bit, then start logo
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      _logoController.forward();
    }
    
    // Wait for logo to be mostly done, then start text
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      _textController.forward();
    }
    
    // Start particles
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      _particleController.forward();
    }
  }

  void _generateParticles() {
    for (int i = 0; i < 30; i++) {
      _particles.add(Offset(
        (i * 47) % 600 - 300,
        (i * 83) % 1000 - 500,
      ));
      _particleSizes.add(1.5 + (i % 4) * 1.5);
      _particleColors.add([
        const Color(0xFF00D4FF), // Cyan
        const Color(0xFF8B5CF6), // Purple
        const Color(0xFF10B981), // Green
        const Color(0xFFFF6B6B), // Red
      ][i % 4]);
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _backgroundController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RepaintBoundary(
        child: Stack(
          children: [
            // Beautiful animated background
            _buildBeautifulBackground(),
            
            // Particle effects
            _buildParticleEffects(),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Enhanced logo with stunning animations
                  _buildStunningLogo(),
                  
                  const SizedBox(height: 50),
                  
                  // App name with elegant typography
                  _buildElegantAppName(),
                  
                  const SizedBox(height: 24),
                  
                  // Tagline
                  _buildTagline(),
                ],
              ),
            ),
            
            // Floating decorative elements
            _buildFloatingDecorations(),
          ],
        ),
      ),
    );
  }

  Widget _buildBeautifulBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Transform.scale(
          scale: _backgroundScale.value,
          child: Opacity(
            opacity: _backgroundOpacity.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                    const Color(0xFF0A0A0A),
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
              child: CustomPaint(
                painter: BackgroundPatternPainter(
                  gradientRotation: _gradientRotation.value,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticleEffects() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: EnhancedParticlePainter(
            particles: _particles,
            particleSizes: _particleSizes,
            particleColors: _particleColors,
            opacity: _particleOpacity.value,
            animationValue: _particleController.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildStunningLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Transform.rotate(
            angle: _logoRotation.value,
            child: Opacity(
              opacity: _logoOpacity.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow effect
                  _buildOuterGlow(),
                  
                  // Middle glow effect
                  _buildMiddleGlow(),
                  
                  // Main logo container with actual TechTips design
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF00D4FF),
                          const Color(0xFF00B4D8),
                          const Color(0xFF0099CC),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00D4FF).withValues(alpha: 0.4 * _logoGlow.value),
                          blurRadius: 30 * _logoElevation.value,
                          spreadRadius: 8 * _logoGlow.value,
                        ),
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.2 * _logoGlow.value),
                          blurRadius: 20 * _logoElevation.value,
                          spreadRadius: 4 * _logoGlow.value,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 25,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'T',
                          style: GoogleFonts.inter(
                            fontSize: 72,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF8B5CF6), // Purple T as in your logo
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                offset: const Offset(3, 3),
                                blurRadius: 6,
                              ),
                              Shadow(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOuterGlow() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Container(
          width: 180 + _logoGlow.value * 40,
          height: 180 + _logoGlow.value * 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            gradient: RadialGradient(
              colors: [
                const Color(0xFF00D4FF).withValues(alpha: 0.15 * _logoGlow.value),
                const Color(0xFF8B5CF6).withValues(alpha: 0.1 * _logoGlow.value),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiddleGlow() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Container(
          width: 160 + _logoGlow.value * 20,
          height: 160 + _logoGlow.value * 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: RadialGradient(
              colors: [
                const Color(0xFF00D4FF).withValues(alpha: 0.25 * _logoGlow.value),
                const Color(0xFF00D4FF).withValues(alpha: 0.1 * _logoGlow.value),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildElegantAppName() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _textSlide.value),
          child: Opacity(
            opacity: _textOpacity.value,
            child: Column(
              children: [
                Text(
                  'TECHTIPS',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: const Color(0xFF8B5CF6),
                    shadows: [
                      Shadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
                        offset: const Offset(0, 3),
                        blurRadius: 12,
                      ),
                      Shadow(
                        color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 80,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF00D4FF),
                        const Color(0xFF8B5CF6),
                        const Color(0xFF10B981),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacity.value * 0.9,
          child: Text(
            'Your Tech Knowledge Hub',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[300],
              letterSpacing: 0.8,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingDecorations() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return Stack(
            children: [
              // Floating code brackets
              Positioned(
                top: 120,
                right: 60,
                child: Opacity(
                  opacity: _mainController.value * 0.8,
                  child: Transform.rotate(
                    angle: _mainController.value * 0.15,
                    child: Icon(
                      Icons.code,
                      size: 28,
                      color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              
              // Floating settings icon
              Positioned(
                bottom: 180,
                left: 50,
                child: Opacity(
                  opacity: _mainController.value * 0.6,
                  child: Transform.rotate(
                    angle: -_mainController.value * 0.08,
                    child: Icon(
                      Icons.settings,
                      size: 24,
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              
              // Floating computer icon
              Positioned(
                top: 250,
                left: 80,
                child: Opacity(
                  opacity: _mainController.value * 0.5,
                  child: Transform.rotate(
                    angle: _mainController.value * 0.12,
                    child: Icon(
                      Icons.computer,
                      size: 22,
                      color: const Color(0xFF10B981).withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              
              // Floating lightbulb icon
              Positioned(
                bottom: 120,
                right: 80,
                child: Opacity(
                  opacity: _mainController.value * 0.7,
                  child: Transform.rotate(
                    angle: _mainController.value * 0.06,
                    child: Icon(
                      Icons.lightbulb_outline,
                      size: 26,
                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Enhanced custom painter for particle effects
class EnhancedParticlePainter extends CustomPainter {
  final List<Offset> particles;
  final List<double> particleSizes;
  final List<Color> particleColors;
  final double opacity;
  final double animationValue;

  EnhancedParticlePainter({
    required this.particles,
    required this.particleSizes,
    required this.particleColors,
    required this.opacity,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length; i++) {
      final paint = Paint()
        ..color = particleColors[i].withValues(alpha: opacity * 0.7)
        ..style = PaintingStyle.fill;

      final offset = Offset(
        particles[i].dx + size.width / 2,
        particles[i].dy + size.height / 2 + animationValue * 80,
      );

      // Draw main particle
      canvas.drawCircle(offset, particleSizes[i], paint);
      
      // Draw glow effect
      final glowPaint = Paint()
        ..color = particleColors[i].withValues(alpha: opacity * 0.3)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(offset, particleSizes[i] * 2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(EnhancedParticlePainter oldDelegate) {
    return oldDelegate.opacity != opacity || 
           oldDelegate.animationValue != animationValue;
  }
}

/// Custom painter for background pattern
class BackgroundPatternPainter extends CustomPainter {
  final double gradientRotation;

  BackgroundPatternPainter({required this.gradientRotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D4FF).withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    // Draw subtle grid pattern
    for (int i = 0; i < size.width; i += 60) {
      for (int j = 0; j < size.height; j += 60) {
        canvas.drawCircle(
          Offset(i.toDouble(), j.toDouble()),
          1,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) {
    return oldDelegate.gradientRotation != gradientRotation;
  }
}
