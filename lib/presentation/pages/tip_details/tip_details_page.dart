import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/tip_entity.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../../viewmodels/tips_viewmodel.dart';

/// Page displaying detailed view of a tip
class TipDetailsPage extends StatelessWidget {
  final TipEntity tip;
  
  const TipDetailsPage({
    super.key,
    required this.tip,
  });
  
  @override
  Widget build(BuildContext context) {
    return Consumer<TipsViewModel>(
      builder: (context, tipsViewModel, _) {
        final isFavorite = tipsViewModel.isFavorite(tip.id);
        
        return Scaffold(
          appBar: AppBar(
            title: Text(_getOSDisplayName(tip.os)),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? AppIcons.favorite : AppIcons.favoriteBorder,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorite(context, tipsViewModel),
                tooltip: isFavorite 
                    ? AppStrings.removeFromFavorites 
                    : AppStrings.addToFavorites,
              ),
              IconButton(
                icon: const Icon(AppIcons.share),
                onPressed: () => _shareTip(context),
                tooltip: 'Share tip',
              ),
            ],
          ),
          
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Creative Header with OS and Title
                _buildCreativeHeader(context),
                
                const SizedBox(height: 20),
                
                // Description
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.colorScheme.primaryContainer.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    tip.description,
                    style: context.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Steps
                Text(
                  AppStrings.steps,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                ...tip.steps.asMap().entries.map(
                  (entry) => _buildStep(context, entry.key + 1, entry.value),
                ),
                
                const SizedBox(height: 24),
                
                // Tags
                if (tip.tags.isNotEmpty) ...[
                  Text(
                    'Tags',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tip.tags.map((tag) => _buildTag(context, tag)).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                ],
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _copyToClipboard(context),
                        icon: const Icon(AppIcons.copy),
                        label: const Text('Copy Steps'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _shareTip(context),
                        icon: const Icon(AppIcons.share),
                        label: const Text('Share'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCreativeHeader(BuildContext context) {
    final osColor = AppColors.getOSColor(tip.os);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
            ? [
                AppColors.accentDark.withValues(alpha: 0.1),
                AppColors.accentDark.withValues(alpha: 0.05),
                AppColors.surfaceDark.withValues(alpha: 0.8),
              ]
            : [
                AppColors.accentDark.withValues(alpha: 0.08),
                AppColors.accentDark.withValues(alpha: 0.03),
                AppColors.neutral50.withValues(alpha: 0.9),
              ],
          stops: const [0.0, 0.3, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark 
            ? AppColors.accentDark.withValues(alpha: 0.3)
            : AppColors.accentDark.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? AppColors.accentDark.withValues(alpha: 0.2)
              : AppColors.accentDark.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: isDark 
              ? Colors.black.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // OS Badge with enhanced design
              Row(
                children: [
                  // Enhanced OS Icon Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          osColor.withValues(alpha: 0.2),
                          osColor.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: osColor.withValues(alpha: 0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: osColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      AppIcons.getOSIcon(tip.os),
                      size: 24,
                      color: osColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Enhanced OS Name Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          osColor.withValues(alpha: 0.15),
                          osColor.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: osColor.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: osColor.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      _getOSDisplayName(tip.os),
                      style: context.textTheme.labelLarge?.copyWith(
                        color: osColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Tip Type Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark 
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark 
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.6),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Tip',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: isDark 
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Enhanced Title
              Text(
                tip.title,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: isDark 
                    ? Colors.white
                    : AppColors.textPrimary,
                  fontSize: 22,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle with step count
              Row(
                children: [
                  Icon(
                    Icons.format_list_numbered_rounded,
                    size: 16,
                    color: isDark 
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${tip.steps.length} steps to master',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark 
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  

  
  Widget _buildStep(BuildContext context, int stepNumber, String stepText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Text(
              stepText,
              style: context.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTag(BuildContext context, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  void _toggleFavorite(BuildContext context, TipsViewModel tipsViewModel) {
    tipsViewModel.toggleFavorite(tip.id);
    
    final isFavorite = tipsViewModel.isFavorite(tip.id);
    final message = isFavorite 
        ? AppStrings.addToFavorites 
        : AppStrings.removeFromFavorites;
    
    context.showSnackBar(message);
  }
  
  void _copyToClipboard(BuildContext context) {
    final stepsText = tip.steps.asMap().entries
        .map((entry) => '${entry.key + 1}. ${entry.value}')
        .join('\n');
    
    final fullText = '''
${tip.title}

${tip.description}

Steps:
$stepsText
''';
    
    Clipboard.setData(ClipboardData(text: fullText));
    context.showSnackBar('Copied to clipboard');
  }
  
  void _shareTip(BuildContext context) {
    final stepsText = tip.steps.asMap().entries
        .map((entry) => '${entry.key + 1}. ${entry.value}')
        .join('\n');
    
    final shareText = '''
${tip.title}

${tip.description}

Steps:
$stepsText

#TechShortcuts #${_getOSDisplayName(tip.os)}
''';
    
    // In a real app, you would use share_plus package
    Clipboard.setData(ClipboardData(text: shareText));
    context.showSnackBar('Share text copied to clipboard');
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
}
