import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/providers/dependency_injection.dart';
import 'presentation/viewmodels/settings_viewmodel.dart';
import 'presentation/viewmodels/tips_viewmodel.dart';
import 'presentation/pages/home/minimal_home_page.dart';
import 'presentation/widgets/minimal_splash_screen.dart';

void main() {
  // Enable performance optimizations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Optimize for performance
  runApp(const TechShortcutsApp());
}

/// Main application widget - Ultra performance optimized with responsive sizing
class TechShortcutsApp extends StatelessWidget {
  const TechShortcutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: DependencyInjection.getProviders(),
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, _) {
          return RepaintBoundary(
            child: MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsViewModel.themeMode,
            
            // Home page
            home: const AppInitializer(),
            
            // Global Material App configuration with responsive sizing
            builder: (context, child) {
              return MediaQuery(
                // Disable system font scaling to prevent oversized elements
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0), // Fixed 1.0 scaling
                  // Disable system font scaling
                  boldText: false,
                  highContrast: false,
                ),
                child: child!,
              );
            },
            ),
          );
        },
      ),
    );
  }
}

/// Widget that handles app initialization - Ultra performance optimized
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
      // Initialize settings after the build phase
      if (mounted) {
        final settingsViewModel = context.read<SettingsViewModel>();
        await settingsViewModel.initialize();
      }
      
      // Initialize tips immediately for offline app
      if (mounted) {
        final tipsViewModel = context.read<TipsViewModel>();
        await tipsViewModel.initializeTips();
      }
      
      // Minimal loading time for smooth experience
      await Future.delayed(const Duration(milliseconds: 25));
      
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