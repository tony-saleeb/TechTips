import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';

/// Revolutionary Ultra-Premium About Page
/// The most creative and modern about page ever created
class RevolutionaryAboutPage extends StatefulWidget {
  const RevolutionaryAboutPage({super.key});

  @override
  State<RevolutionaryAboutPage> createState() => _RevolutionaryAboutPageState();
}

class _RevolutionaryAboutPageState extends State<RevolutionaryAboutPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _floatingController;
  late AnimationController _glowController;
  late AnimationController _particleController;
  late AnimationController _morphController;
  late AnimationController _shimmerController;

  late Animation<double> _heroAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _morphAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Hero section animation
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _heroAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutCubic,
    );

    // Floating elements animation
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _floatingAnimation = CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    );

    // Glow effects animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );

    // Particle effects animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _particleAnimation = CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    );

    // Morphing elements animation
    _morphController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _morphAnimation = CurvedAnimation(
      parent: _morphController,
      curve: Curves.elasticOut,
    );

    // Shimmer effects animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );
  }

  void _startAnimations() {
    _heroController.forward();
    _floatingController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
    _particleController.repeat();
    _morphController.forward();
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _floatingController.dispose();
    _glowController.dispose();
    _particleController.dispose();
    _morphController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
              ? [
                  Color(0xFF0F0F23),
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F0F23),
                ]
              : [
                  Color(0xFFF8FAFC),
                  Color(0xFFE2E8F0),
                  Color(0xFFF1F5F9),
                  Color(0xFFF8FAFC),
                ],
          ),
        ),
        child: Stack(
          children: [
            // Revolutionary background effects
            _buildRevolutionaryBackground(isDark),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Ultra-premium header
                    _buildUltraPremiumHeader(isDark),
                    
                    const SizedBox(height: 40),
                    
                    // Revolutionary content sections
                    _buildRevolutionaryContent(isDark),
                    
                    const SizedBox(height: 40),
                    
                    // Premium footer
                    _buildPremiumFooter(isDark),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevolutionaryBackground(bool isDark) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _particleController,
        _glowController,
        _floatingController,
      ]),
      builder: (context, child) {
        return CustomPaint(
          painter: _RevolutionaryBackgroundPainter(
            particleAnimation: _particleAnimation.value,
            glowAnimation: _glowAnimation.value,
            floatingAnimation: _floatingAnimation.value,
            isDark: isDark,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildUltraPremiumHeader(bool isDark) {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                ? [
                    Colors.purple.withValues(alpha: 0.3),
                    Colors.indigo.withValues(alpha: 0.2),
                    Colors.blue.withValues(alpha: 0.25),
                    Colors.purple.withValues(alpha: 0.2),
                  ]
                : [
                    Colors.blue.withValues(alpha: 0.2),
                    Colors.blue.withValues(alpha: 0.1),
                    Colors.blue.withValues(alpha: 0.15),
                    Colors.blue.withValues(alpha: 0.12),
                  ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isDark
                ? Colors.purple.withValues(alpha: 0.4)
                : Colors.blue.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                  ? Colors.purple.withValues(alpha: 0.3)
                  : Colors.blue.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 8,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: isDark
                  ? Colors.indigo.withValues(alpha: 0.2)
                  : Colors.blue.withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Revolutionary app icon with holographic effects
              _buildHolographicAppIcon(isDark),
              
              const SizedBox(height: 24),
              
              // App name with gradient text
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDark
                    ? [Colors.purple, Colors.indigo, Colors.blue]
                    : [Colors.blue, Colors.blue, Colors.blue],
                ).createShader(bounds),
                child: Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.0,
                    shadows: [
                      Shadow(
                        color: isDark
                          ? Colors.purple.withValues(alpha: 0.5)
                          : Colors.blue.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Revolutionary tagline
              Text(
                '🚀 The Ultimate Tech Shortcuts Revolution 🚀',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.grey[800],
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle with premium styling
              Text(
                'Empowering developers, designers, and power users worldwide',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.grey[600],
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHolographicAppIcon(bool isDark) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _morphController,
        _shimmerController,
        _glowController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_morphAnimation.value * 0.1),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                  ? [
                      Colors.purple.withValues(alpha: 0.4),
                      Colors.indigo.withValues(alpha: 0.3),
                      Colors.blue.withValues(alpha: 0.2),
                      Colors.transparent,
                    ]
                  : [
                      Colors.blue.withValues(alpha: 0.3),
                      Colors.blue.withValues(alpha: 0.2),
                      Colors.blue.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                    ? Colors.purple.withValues(alpha: 0.4 * _glowAnimation.value)
                    : Colors.blue.withValues(alpha: 0.3 * _glowAnimation.value),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: isDark
                    ? Colors.indigo.withValues(alpha: 0.3 * _glowAnimation.value)
                    : Colors.blue.withValues(alpha: 0.2 * _glowAnimation.value),
                  blurRadius: 60,
                  spreadRadius: 15,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shimmer effect
                Transform.rotate(
                  angle: _shimmerAnimation.value * 3.14159 * 2,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: isDark
                          ? [
                              Colors.transparent,
                              Colors.purple.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.6),
                              Colors.purple.withValues(alpha: 0.3),
                              Colors.transparent,
                            ]
                          : [
                              Colors.transparent,
                              Colors.blue.withValues(alpha: 0.3),
                              Colors.white.withValues(alpha: 0.6),
                              Colors.blue.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                
                // Main icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isDark
                        ? [
                            Colors.purple.withValues(alpha: 0.8),
                            Colors.indigo.withValues(alpha: 0.6),
                            Colors.blue.withValues(alpha: 0.4),
                          ]
                        : [
                            Colors.blue.withValues(alpha: 0.8),
                            Colors.blue.withValues(alpha: 0.6),
                            Colors.blue.withValues(alpha: 0.4),
                          ],
                    ),
                    border: Border.all(
                      color: isDark
                        ? Colors.purple.withValues(alpha: 0.6)
                        : Colors.blue.withValues(alpha: 0.5),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                          ? Colors.purple.withValues(alpha: 0.3)
                          : Colors.blue.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.terminal_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRevolutionaryContent(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Revolutionary features section
          _buildRevolutionaryFeatures(isDark),
          
          const SizedBox(height: 32),
          
          // Premium stats section
          _buildPremiumStats(isDark),
          
          const SizedBox(height: 32),
          
          // Revolutionary description
          _buildRevolutionaryDescription(isDark),
        ],
      ),
    );
  }

  Widget _buildRevolutionaryFeatures(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.02),
                Colors.white.withValues(alpha: 0.05),
              ]
            : [
                Colors.black.withValues(alpha: 0.03),
                Colors.black.withValues(alpha: 0.01),
                Colors.black.withValues(alpha: 0.03),
              ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
            ? Colors.purple.withValues(alpha: 0.2)
            : Colors.blue.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ Revolutionary Features',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark
                ? Colors.purple
                : Colors.blue,
              letterSpacing: -0.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildFeatureItem(
            isDark,
            icon: Icons.rocket_launch,
            title: 'Lightning Fast',
            description: 'Instant access to thousands of shortcuts',
            color: Colors.orange,
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureItem(
            isDark,
            icon: Icons.auto_awesome,
            title: 'AI-Powered Search',
            description: 'Smart search that understands your intent',
            color: Colors.purple,
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureItem(
            isDark,
            icon: Icons.palette,
            title: 'Premium Themes',
            description: 'Beautiful dark and light themes',
            color: Colors.blue,
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureItem(
            isDark,
            icon: Icons.favorite,
            title: 'Smart Favorites',
            description: 'Organize and access your most-used shortcuts',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    bool isDark, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [
                Colors.white.withValues(alpha: 0.03),
                Colors.white.withValues(alpha: 0.01),
              ]
            : [
                Colors.black.withValues(alpha: 0.02),
                Colors.black.withValues(alpha: 0.005),
              ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.8),
                  color.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                      ? Colors.white.withValues(alpha: 0.9)
                      : Colors.grey[800],
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumStats(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [
                Colors.purple.withValues(alpha: 0.1),
                Colors.indigo.withValues(alpha: 0.05),
                Colors.blue.withValues(alpha: 0.08),
              ]
            : [
                Colors.blue.withValues(alpha: 0.08),
                Colors.blue.withValues(alpha: 0.04),
                Colors.blue.withValues(alpha: 0.06),
              ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
            ? Colors.purple.withValues(alpha: 0.2)
            : Colors.blue.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            '📊 Impressive Stats',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark
                ? Colors.purple
                : Colors.blue,
              letterSpacing: -0.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  isDark,
                  number: '1000+',
                  label: 'Shortcuts',
                  color: Colors.orange,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: _buildStatItem(
                  isDark,
                  number: '3',
                  label: 'Operating Systems',
                  color: Colors.green,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  isDark,
                  number: '24/7',
                  label: 'Available',
                  color: Colors.blue,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: _buildStatItem(
                  isDark,
                  number: '100%',
                  label: 'Free',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    bool isDark, {
    required String number,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.02),
              ]
            : [
                Colors.black.withValues(alpha: 0.03),
                Colors.black.withValues(alpha: 0.01),
              ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: -1.0,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevolutionaryDescription(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.02),
                Colors.white.withValues(alpha: 0.05),
              ]
            : [
                Colors.black.withValues(alpha: 0.03),
                Colors.black.withValues(alpha: 0.01),
                Colors.black.withValues(alpha: 0.03),
              ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
            ? Colors.purple.withValues(alpha: 0.2)
            : Colors.blue.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🌟 About This Revolutionary App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark
                ? Colors.purple
                : Colors.blue,
              letterSpacing: -0.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            AppConstants.appDescription,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDark
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.grey[800],
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Built with cutting-edge Flutter technology and designed with love for the developer community. This app represents the future of productivity tools - fast, beautiful, and incredibly powerful.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDark
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.grey[700],
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFooter(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
            ? [
                Colors.purple.withValues(alpha: 0.1),
                Colors.indigo.withValues(alpha: 0.05),
                Colors.blue.withValues(alpha: 0.08),
              ]
            : [
                Colors.blue.withValues(alpha: 0.08),
                Colors.blue.withValues(alpha: 0.04),
                Colors.blue.withValues(alpha: 0.06),
              ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
            ? Colors.purple.withValues(alpha: 0.2)
            : Colors.blue.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Version 1.0.0 • Built with Flutter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark
                ? Colors.purple
                : Colors.blue,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Made with ❤️ for the developer community',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark
                ? Colors.white.withValues(alpha: 0.8)
                : Colors.grey[700],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Premium close button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                  ? [
                      Colors.purple.withValues(alpha: 0.8),
                      Colors.indigo.withValues(alpha: 0.6),
                      Colors.blue.withValues(alpha: 0.4),
                    ]
                  : [
                      Colors.blue.withValues(alpha: 0.8),
                      Colors.blue.withValues(alpha: 0.6),
                      Colors.blue.withValues(alpha: 0.4),
                    ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                    ? Colors.purple.withValues(alpha: 0.3)
                    : Colors.blue.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Text(
                        'Amazing! Got it!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Revolutionary background painter with particle effects
class _RevolutionaryBackgroundPainter extends CustomPainter {
  final double particleAnimation;
  final double glowAnimation;
  final double floatingAnimation;
  final bool isDark;

  _RevolutionaryBackgroundPainter({
    required this.particleAnimation,
    required this.glowAnimation,
    required this.floatingAnimation,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i * 0.1)) % size.width;
      final y = (size.height * (i * 0.15) + floatingAnimation * 100) % size.height;
      final radius = 2 + (particleAnimation * 3);
      
      paint.color = isDark
        ? Colors.purple.withValues(alpha: 0.1 + (particleAnimation * 0.2))
        : Colors.blue.withValues(alpha: 0.08 + (particleAnimation * 0.15));
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw glow effects
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.2 + i * 0.2);
      final y = size.height * (0.3 + i * 0.1);
      final radius = 50 + (glowAnimation * 30);
      
      paint.color = isDark
        ? Colors.purple.withValues(alpha: 0.05 + (glowAnimation * 0.1))
        : Colors.blue.withValues(alpha: 0.03 + (glowAnimation * 0.08));
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
