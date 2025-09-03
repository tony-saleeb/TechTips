import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/utils/extensions.dart';
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
  
  Widget _buildTipsListView(TipsViewModel tipsViewModel) {
    // Show loading state during initialization
    if (tipsViewModel.isLoading && tipsViewModel.tips.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    // Show error state
    if (tipsViewModel.hasError) {
      return CustomErrorWidget(
        message: tipsViewModel.error,
        onRetry: () => _retry(tipsViewModel),
      );
    }
    
    // Show empty state only if not loading and tips are actually empty
    if (tipsViewModel.isEmpty && !tipsViewModel.isLoading) {
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
    
    // If tips are being loaded, show loading instead of empty state
    if (tipsViewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    // Only show "No Tips Available" if there's an actual error or no tips loaded
    if (!tipsViewModel.hasTips && !tipsViewModel.isLoading) {
      return EmptyStateWidget(
        title: 'Loading Tips...',
        message: 'Please wait while tips are being loaded.',
        icon: Icons.hourglass_empty,
        osTheme: widget.os,
        action: ElevatedButton(
          onPressed: () => _retry(tipsViewModel),
          child: const Text('Retry'),
        ),
      );
    }
    
    return const SizedBox.shrink(); // Don't show anything if tips are available
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
  




  /// Build search view with search bar
  Widget _buildSearchView(TipsViewModel tipsViewModel) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.rp(16),
            vertical: context.rp(8),
          ),
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
          child: _buildTipsListView(tipsViewModel),
        ),
      ],
    );
  }

  /// Build content

}

