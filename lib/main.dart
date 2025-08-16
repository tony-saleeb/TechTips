import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_colors.dart';
import 'presentation/providers/dependency_injection.dart';
import 'presentation/viewmodels/settings_viewmodel.dart';
import 'presentation/pages/home/minimal_home_page.dart';
import 'presentation/widgets/minimal_splash_screen.dart';

void main() {
  runApp(const TechShortcutsApp());
}

/// Main application widget
class TechShortcutsApp extends StatelessWidget {
  const TechShortcutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: DependencyInjection.getProviders(),
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, _) {
    return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsViewModel.themeMode,
            
            // Home page
            home: const AppInitializer(),
            
            // Global Material App configuration
            builder: (context, child) {
              return MediaQuery(
                // Apply font size scaling based on user preference
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(_calculateTextScaleFactor(settingsViewModel.fontSize)),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
  
  /// Calculate text scale factor based on font size setting
  double _calculateTextScaleFactor(double fontSize) {
    // Base font size is 14.0, scale accordingly
    return fontSize / AppConstants.defaultFontSize;
  }
}

/// Widget that handles app initialization
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});
  
  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    try {
      // Add a small delay to ensure the widget tree is built
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Initialize settings after the build phase
      if (mounted) {
        final settingsViewModel = context.read<SettingsViewModel>();
        await settingsViewModel.initialize();
      }
      
      // Add any other initialization logic here
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate loading
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('App initialization error: $e');
      // Even if initialization fails, show the app
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MinimalSplashScreen();
    }
    
    return const MinimalHomePage();
  }
}

/// Premium animated splash screen with particle effects
class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  
  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    
    _logoRotation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
    
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    
    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    
    _startAnimations();
  }
  
  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      _logoController.forward();
    }
    
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _textController.forward();
    }
  }
  
  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundDark,
        ),
        child: Stack(
          children: [
            // Animated particles background
            _buildParticleBackground(),
            
            // Main content
            Center(
        child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated logo
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                ),
                                BoxShadow(
                                  color: AppColors.secondary.withValues(alpha: 0.2),
                                  blurRadius: 50,
                                  offset: const Offset(0, 25),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.lightbulb,
                              size: 70,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Animated app name
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlide.value),
                        child: Opacity(
                          opacity: _textFade.value,
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(colors: [AppColors.primary, AppColors.secondary]).createShader(bounds),
                            child: Text(
                              AppConstants.appName,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Animated description
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlide.value * 0.5),
                        child: Opacity(
                          opacity: _textFade.value * 0.8,
                          child: Text(
                            AppConstants.appDescription,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 64),
                  
                  // Premium loading indicator
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textFade.value,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticlesPainter(_particleController.value),
        );
      },
    );
  }
}

/// Custom painter for animated particles
class ParticlesPainter extends CustomPainter {
  final double animationValue;
  
  ParticlesPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    // Draw floating particles
    for (int i = 0; i < 50; i++) {
      final x = (i * 37.0 + animationValue * 100) % size.width;
      final y = (i * 23.0 + animationValue * 50) % size.height;
      final radius = (i % 3) + 1.0;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}