import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../widgets/minimal_tip_card.dart';
import '../../widgets/empty_state_widget.dart';
import '../../viewmodels/tips_viewmodel.dart';

/// Page displaying list of tips for a specific OS
class TipsListPage extends StatefulWidget {
  final String os;
  final Function(VoidCallback)? onSearchToggleCallback;
  final Function(bool Function())? onSearchStateCallback;
  
  const TipsListPage({
    super.key,
    required this.os,
    this.onSearchToggleCallback,
    this.onSearchStateCallback,
  });
  
  @override
  State<TipsListPage> createState() => _TipsListPageState();
}

class _TipsListPageState extends State<TipsListPage>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _searchController;
  bool _showSearch = false;
  
  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    
    // Set up callbacks for parent to control search
    widget.onSearchToggleCallback?.call(_toggleSearch);
    widget.onSearchStateCallback?.call(() => _showSearch);
    
    // Load tips immediately when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tipsViewModel = context.read<TipsViewModel>();
      tipsViewModel.loadTipsByOS(widget.os);
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Consumer<TipsViewModel>(
      builder: (context, tipsViewModel, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80), // Reduced height for sleeker look
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        AppColors.backgroundDark.withValues(alpha: 0.95),
                        AppColors.surfaceDark.withValues(alpha: 0.9),
                        AppColors.backgroundDark.withValues(alpha: 0.98),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.95),
                        const Color(0xFFF8F9FF).withValues(alpha: 0.9),
                        Colors.white,
                      ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                // Curved app bar with rounded bottom corners
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.04),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.03),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Sleeker padding
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Spacer for left alignment (drawer button space)
                      const SizedBox(width: 40),
                      
                      // Elegant title - centered
                      Expanded(
                        child: Center(
                          child: _buildModernTitle(),
                        ),
                      ),
                      
                      // Spacer for right alignment (search button space)
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),

          
          body: Container(
            margin: const EdgeInsets.only(top: 8), // Small margin to complement curved app bar
            child: Column(
              children: [
                // Search bar
                if (_showSearch)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomSearchBar(
                      controller: _searchController,
                      hintText: 'Search ${_getOSDisplayName(widget.os)} tips...',
                      onChanged: (query) => _onSearchChanged(query, tipsViewModel),
                      onClear: () => _onSearchCleared(tipsViewModel),
                      autofocus: true,
                    ),
                  ),
                
                // Content
                Expanded(
                  child: _buildContent(tipsViewModel),
                ),
              ],
            ),
          ),

        );
      },
    );
  }
  
  Widget _buildContent(TipsViewModel tipsViewModel) {
    if (tipsViewModel.isLoading) {
      return const CustomLoadingIndicator(
        message: AppStrings.loading,
      );
    }
    
    if (tipsViewModel.hasError) {
      return CustomErrorWidget(
        message: tipsViewModel.error,
        onRetry: () => _retry(tipsViewModel),
      );
    }
    
    if (tipsViewModel.isEmpty) {
      return _buildEmptyState(tipsViewModel);
    }
    
    return RefreshIndicator(
      onRefresh: () => _refresh(tipsViewModel),
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 80, // Space for FAB
        ),
        itemCount: tipsViewModel.tips.length,
        itemBuilder: (context, index) {
          final tip = tipsViewModel.tips[index];
          return MinimalTipCard(
            tip: tip,
            index: index,
          );
        },
      ),
    );
  }
  
  Widget _buildEmptyState(TipsViewModel tipsViewModel) {
    if (tipsViewModel.searchQuery.isNotEmpty) {
      return EmptyStateWidget(
        title: 'No Results Found',
        message: 'Try adjusting your search terms or browse tips by category.',
        icon: Icons.search_off,
        osTheme: widget.os,
        action: ElevatedButton(
          onPressed: () => _onSearchCleared(tipsViewModel),
          child: const Text('Clear Search'),
        ),
      );
    }
    
    return EmptyStateWidget(
      title: 'No Tips Available',
      message: 'Check your internet connection and try again.',
      icon: Icons.info_outline,
      osTheme: widget.os,
      action: ElevatedButton(
        onPressed: () => _retry(tipsViewModel),
        child: const Text('Retry'),
      ),
    );
  }
  
  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
    
    if (!_showSearch) {
      _searchController.clear();
      final tipsViewModel = context.read<TipsViewModel>();
      tipsViewModel.clearSearch();
    }
  }

  /// Public method to toggle search (called from parent)
  void toggleSearch() {
    _toggleSearch();
  }

  /// Public getter to check if search is active
  bool get isSearchActive => _showSearch;
  
  void _onSearchChanged(String query, TipsViewModel tipsViewModel) {
    tipsViewModel.searchTips(query);
  }
  
  void _onSearchCleared(TipsViewModel tipsViewModel) {
    _searchController.clear();
    tipsViewModel.clearSearch();
  }
  
  Future<void> _refresh(TipsViewModel tipsViewModel) async {
    await tipsViewModel.refresh();
  }
  
  Future<void> _retry(TipsViewModel tipsViewModel) async {
    await tipsViewModel.loadTipsByOS(widget.os);
  }
  

  /// Get OS display name
  String _getOSDisplayName(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return 'Windows';
      case 'macos':
        return 'macOS';
      case 'linux':
        return 'Linux';
      default:
        return os.toUpperCase();
    }
  }
  
  /// Get OS icon
  IconData _getOSIcon(String os) {
    switch (os.toLowerCase()) {
      case 'windows':
        return Icons.window;
      case 'macos':
        return Icons.laptop_mac;
      case 'linux':
        return Icons.computer;
      default:
        return Icons.computer;
    }
  }

  Widget _buildModernTitle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                AppColors.accentDark.withValues(alpha: 0.9),
                AppColors.accentDark.withValues(alpha: 0.7),
                AppColors.accentDark.withValues(alpha: 0.85),
              ]
            : [
                AppColors.getOSColor(widget.os),
                AppColors.getOSColor(widget.os).withValues(alpha: 0.8),
                AppColors.getOSColor(widget.os).withValues(alpha: 0.9),
              ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark 
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.accentDark : AppColors.getOSColor(widget.os)).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: (isDark ? AppColors.accentDark : AppColors.getOSColor(widget.os)).withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 12),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Icon(
              _getOSIcon(widget.os),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_getOSDisplayName(widget.os)} Tips',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
              fontSize: 18,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
