import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../../core/utils/extensions.dart';

/// Full-featured settings page with theme and app controls
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      
      body: ListView(
            padding: context.re(16),
              children: [
          // Preferences Section
          _buildSectionHeader('Preferences'),
                context.rsb(height: 8),
                
          _buildPreferencesCard(),
                context.rsb(height: 24),
                
          // About Section
          _buildSectionHeader('About'),
                context.rsb(height: 8),
                
          _buildAboutCard(),
                context.rsb(height: 24),
                
          // Actions Section
          _buildSectionHeader('Actions'),
          context.rsb(height: 8),
                
          _buildActionsCard(context),
              ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: context.rs(18),
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
  

  

  
  Widget _buildPreferencesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Colors.blue),
                const SizedBox(width: 12),
                const Text(
                  'App Preferences',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Enable push notifications'),
              value: _notificationsEnabled,
                onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _showSnackbar(
                  value ? 'Notifications enabled' : 'Notifications disabled'
                );
              },
            ),
            
            const ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              subtitle: Text('English'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            
            const ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Auto-save'),
              subtitle: Text('Every 5 minutes'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAboutCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: Colors.blue),
                const SizedBox(width: 12),
                const Text(
                  'About',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Version'),
              subtitle: Text('1.0.0'),
              contentPadding: EdgeInsets.zero,
            ),
            
            const ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Developer'),
              subtitle: Text('Built with ❤️ for power users'),
              contentPadding: EdgeInsets.zero,
            ),
            
            const ListTile(
              leading: Icon(Icons.code),
              title: Text('Flutter Version'),
              subtitle: Text('3.16.0'),
              contentPadding: EdgeInsets.zero,
            ),
            
            const ListTile(
              leading: Icon(Icons.update),
              title: Text('Last Updated'),
              subtitle: Text('December 2024'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Reset Settings'),
              subtitle: const Text('Reset all settings to default'),
              onTap: () => _showResetConfirmation(context),
            ),
            
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Send Feedback'),
              subtitle: const Text('Help us improve the app'),
              onTap: () {
                _showSnackbar('Feedback feature coming soon!');
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate App'),
              subtitle: const Text('Support us with a rating'),
              onTap: () {
                _showSnackbar('Rating feature coming soon!');
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share App'),
              subtitle: const Text('Share with friends'),
              onTap: () {
                _showSnackbar('Share feature coming soon!');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final settingsViewModel = context.read<SettingsViewModel>();
              await settingsViewModel.resetSettings();
              setState(() {
                _notificationsEnabled = true;
              });
              _showSnackbar('Settings reset successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
  
  void _showSnackbar(String message) {
    // Use a more performant approach for theme changes
    if (message.contains('theme selected')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}
