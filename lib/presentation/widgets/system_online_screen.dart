import 'package:flutter/material.dart';

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
                      // Premium tech icon with smooth fade-in
                      AnimatedBuilder(
                        animation: _completionController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _completionOpacity.value,
                            child: Container(
                              width: isMobile ? 100 : isTablet ? 130 : 150,
                              height: isMobile ? 100 : isTablet ? 130 : 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.cyan.withValues(alpha: 0.4 * _completionOpacity.value),
                                    Colors.cyan.withValues(alpha: 0.1 * _completionOpacity.value),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.lightbulb,
                                size: isMobile ? 50 : isTablet ? 65 : 80,
                                color: Colors.cyan,
                              ),
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
