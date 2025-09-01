import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../viewmodels/tips_viewmodel.dart';

/// Enhanced search dialog with advanced filtering and better UX
class EnhancedSearchDialog extends StatefulWidget {
  final String os;
  final TipsViewModel tipsViewModel;

  const EnhancedSearchDialog({
    super.key,
    required this.os,
    required this.tipsViewModel,
  });

  @override
  State<EnhancedSearchDialog> createState() => _EnhancedSearchDialogState();
}

class _EnhancedSearchDialogState extends State<EnhancedSearchDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  String _selectedDifficulty = 'All';
  String _selectedCategory = 'All';
  bool _favoritesOnly = false;

  final List<String> _difficulties = ['All', 'Easy', 'Medium', 'Hard'];
  final List<String> _categories = ['All', 'Productivity', 'Security', 'Customization', 'Performance'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      widget.tipsViewModel.searchTips(query);
      Navigator.of(context).pop();
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedDifficulty = 'All';
      _selectedCategory = 'All';
      _favoritesOnly = false;
    });
    widget.tipsViewModel.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final osColor = AppColors.getOSColor(widget.os);
    
    return RepaintBoundary(
      child: Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value * 100),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                                 constraints: BoxConstraints(
                   maxWidth: context.rw(500), 
                   maxHeight: context.rh(600)
                 ),
                 margin: context.re(20),
                 decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.surface,
                   borderRadius: BorderRadius.circular(context.rbr(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                    BoxShadow(
                      color: osColor.withValues(alpha: 0.1),
                      blurRadius: 60,
                      offset: const Offset(0, 30),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Enhanced header
                    _buildEnhancedHeader(context, osColor),
                    
                    // Search field
                    _buildSearchField(context, osColor),
                    
                    // Filter options
                    _buildFilterOptions(context, osColor),
                    
                    // Action buttons
                    _buildActionButtons(context, osColor),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      ),
    );
  }

  Widget _buildEnhancedHeader(BuildContext context, Color osColor) {
         return Container(
       padding: context.re(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            osColor.withValues(alpha: 0.1),
            osColor.withValues(alpha: 0.05),
          ],
        ),
                 borderRadius: BorderRadius.only(
           topLeft: Radius.circular(context.rbr(24)),
           topRight: Radius.circular(context.rbr(24)),
         ),
      ),
      child: Row(
        children: [
                     Container(
             padding: context.re(12),
             decoration: BoxDecoration(
               color: osColor.withValues(alpha: 0.15),
               borderRadius: BorderRadius.circular(context.rbr(16)),
               border: Border.all(
                 color: osColor.withValues(alpha: 0.3),
                 width: context.rw(2),
               ),
             ),
             child: Icon(
               Icons.search_rounded,
               color: osColor,
               size: context.ri(24),
             ),
           ),
           context.rsb(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                                 Text(
                   'Advanced Search',
                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                     fontWeight: FontWeight.w800,
                     color: osColor,
                     fontSize: context.rs(20),
                   ),
                 ),
                 context.rsb(height: 4),
                                 Text(
                   'Find ${_getOSDisplayName(widget.os)} tips quickly',
                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                     color: Theme.of(context).colorScheme.onSurfaceVariant,
                     fontSize: context.rs(14),
                   ),
                 ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, Color osColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onSubmitted: (_) => _performSearch(),
        decoration: InputDecoration(
          hintText: 'Search tips, keywords, or descriptions...',
          prefixIcon: Icon(
            Icons.search_rounded,
            color: osColor,
          ),
          suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                icon: Icon(
                  Icons.clear_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : null,
          filled: true,
          fillColor: osColor.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: osColor.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: osColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: osColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildFilterOptions(BuildContext context, Color osColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Options',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          
          // Difficulty filter
          _buildFilterSection(
            context,
            'Difficulty',
            _difficulties,
            _selectedDifficulty,
            (value) => setState(() => _selectedDifficulty = value),
            osColor,
          ),
          
          const SizedBox(height: 16),
          
          // Category filter
          _buildFilterSection(
            context,
            'Category',
            _categories,
            _selectedCategory,
            (value) => setState(() => _selectedCategory = value),
            osColor,
          ),
          
          const SizedBox(height: 16),
          
          // Favorites toggle
          Row(
            children: [
              Switch.adaptive(
                value: _favoritesOnly,
                onChanged: (value) => setState(() => _favoritesOnly = value),
                activeColor: osColor,
              ),
              const SizedBox(width: 12),
              Text(
                'Favorites only',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    String title,
    List<String> options,
    String selected,
    ValueChanged<String> onChanged,
    Color osColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selected;
            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => onChanged(option),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? osColor.withValues(alpha: 0.15)
                      : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected 
                        ? osColor.withValues(alpha: 0.5)
                        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    option,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected 
                        ? osColor
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Color osColor) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Clear Filters',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _performSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: osColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Search Tips',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}
