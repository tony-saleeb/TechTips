import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/animation_extensions.dart';

/// Clean, minimal splash screen
class MinimalSplashScreen extends StatefulWidget {
  const MinimalSplashScreen({super.key});

  @override
  State<MinimalSplashScreen> createState() => _MinimalSplashScreenState();
}

class _MinimalSplashScreenState extends State<MinimalSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      _logoController.safeForward();
    }
    
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _textController.safeForward();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundLight,
              AppColors.neutral50,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Enhanced logo with depth
              FadeTransition(
                opacity: _logoOpacity,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.tips_and_updates_outlined,
                      size: 50,
                      color: AppColors.textInverse,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Enhanced text with better hierarchy
              FadeTransition(
                opacity: _textOpacity,
                child: Column(
                  children: [
                    Text(
                      AppConstants.appName,
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -1.0,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Professional OS Tips & Tricks',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Loading indicator
              FadeTransition(
                opacity: _textOpacity,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
