import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/animated_tips_list.dart';
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

class _TipsListPageState extends State<TipsListPage> {
  late TextEditingController _searchController;
  bool _showSearch = false;
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    
    // Set up callbacks for parent to control search
    widget.onSearchToggleCallback?.call(_toggleSearch);
    widget.onSearchStateCallback?.call(() => _showSearch);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<TipsViewModel>(
      builder: (context, tipsViewModel, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: _showSearch
            ? _buildSearchView(tipsViewModel)
            : _buildTipsListView(tipsViewModel),
        );
      },
    );
  }
  
    Widget _buildContent(TipsViewModel tipsViewModel) {
    // Show error state
    if (tipsViewModel.hasError) {
      return CustomErrorWidget(
        message: tipsViewModel.error,
        onRetry: () => _retry(tipsViewModel),
      );
    }
    
    // Show empty state
    if (tipsViewModel.isEmpty) {
      return _buildEmptyState(tipsViewModel);
    }
    
    // Show tips list instantly
    return AnimatedTipsList(
      tips: tipsViewModel.tips,
      os: widget.os,
      onRefresh: () => _refresh(tipsViewModel),
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
      message: 'Tips will appear here once loaded.',
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
        return Icons.apple;
      case 'linux':
        return Icons.computer;
      default:
        return Icons.computer;
    }
  }

  Widget _buildModernTitle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                AppColors.surfaceDark.withValues(alpha: 0.95),
                AppColors.cardDark.withValues(alpha: 0.9),
                AppColors.surfaceDark.withValues(alpha: 0.98),
              ]
            : [
                Colors.white.withValues(alpha: 0.95),
                AppColors.neutral50.withValues(alpha: 0.9),
                Colors.white,
              ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark 
            ? AppColors.getOSColor(widget.os).withValues(alpha: 0.25)
            : AppColors.getOSColor(widget.os).withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? Colors.black.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.getOSColor(widget.os).withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.getOSColor(widget.os),
                  AppColors.getOSColor(widget.os).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getOSColor(widget.os).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _getOSIcon(widget.os),
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${_getOSDisplayName(widget.os)} Tips',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              letterSpacing: -0.3,
              fontSize: 18,
              shadows: [
                Shadow(
                  color: isDark 
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
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

  /// Build search view with search bar
  Widget _buildSearchView(TipsViewModel tipsViewModel) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }

  /// Build tips list view without search bar
  Widget _buildTipsListView(TipsViewModel tipsViewModel) {
    return _buildContent(tipsViewModel);
  }

  /// Build content

}

