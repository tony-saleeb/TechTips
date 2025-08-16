import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/premium_app_bar.dart';
import '../../viewmodels/app_viewmodel.dart';
import '../../viewmodels/tips_viewmodel.dart';
import '../tips_list/tips_list_page.dart';
import '../settings/settings_page.dart';

/// Main home page with bottom navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Initialize app and load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  Future<void> _initializeApp() async {
    try {
      final appViewModel = context.read<AppViewModel>();
      
      // Initialize app first
      await appViewModel.initialize();
      
      // Load initial tips for the first OS with error handling
      if (mounted && appViewModel.availableOS.isNotEmpty) {
        final tipsViewModel = context.read<TipsViewModel>();
        await tipsViewModel.loadTipsByOS(appViewModel.currentOS);
      }
    } catch (e) {
      debugPrint('Home initialization error: $e');
      // Continue even if initialization fails
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, appViewModel, _) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            ),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                appViewModel.setCurrentTabIndex(index);
                _loadTipsForCurrentOS();
              },
              children: [
                // OS-specific tips pages
                ...appViewModel.availableOS.map(
                  (os) => TipsListPage(os: os),
                ),
              ],
            ),
          ),
          
          bottomNavigationBar: _buildPremiumBottomNav(appViewModel),
          
          // Premium floating action button for settings
          floatingActionButton: PremiumFAB(
            onPressed: () => _navigateToSettings(),
            tooltip: AppStrings.settings,
            heroTag: "settings_fab",
            gradient: LinearGradient(colors: [AppColors.accent, AppColors.accent]),
            child: const Icon(
              AppIcons.settings,
              color: Colors.white,
            ),
          ),
          
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
  
  /// Build premium bottom navigation with glassmorphism
  Widget _buildPremiumBottomNav(AppViewModel appViewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      ),
      child: ClipRRect(
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withOpacity(0.2)
              : Colors.white.withOpacity(0.2),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: appViewModel.availableOS.asMap().entries.map((entry) {
              final index = entry.key;
              final os = entry.value;
              final isSelected = appViewModel.currentTabIndex == index;
              
              return _buildNavItem(
                os: os,
                icon: appViewModel.getOSIcon(os),
                label: appViewModel.getOSDisplayName(os),
                isSelected: isSelected,
                onTap: () => _onTabTapped(index, appViewModel),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem({
    required String os,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final osColor = AppColors.getOSColor(os);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
            ? LinearGradient(
                colors: [osColor.withOpacity(0.2), osColor.withOpacity(0.1)],
              )
            : null,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
            ? Border.all(color: osColor.withOpacity(0.3), width: 1)
            : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: isSelected
                  ? LinearGradient(colors: [osColor, osColor.withOpacity(0.8)])
                  : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: osColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
              ),
              child: Icon(
                icon,
                color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                  ? osColor
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  
  void _onTabTapped(int index, AppViewModel appViewModel) {
    if (index != appViewModel.currentTabIndex) {
      appViewModel.setCurrentTabIndex(index);
      _pageController.animateToPage(
        index,
        duration: AppConstants.mediumAnimationDuration,
        curve: Curves.easeInOut,
      );
      _loadTipsForCurrentOS();
    }
  }
  
  void _loadTipsForCurrentOS() {
    final appViewModel = context.read<AppViewModel>();
    final tipsViewModel = context.read<TipsViewModel>();
    
    // Load tips for current OS
    tipsViewModel.loadTipsByOS(appViewModel.currentOS);
  }
  
  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }
}
