import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';
import '../widgets/buttons.dart';
import '../widgets/input_components.dart';
import '../widgets/floating_action_buttons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEnglish = true;
  bool _voiceMode = true;
  bool _outdoorMode = false;

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.emergencyRed,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Navigate to login by popping all routes and pushing login route
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: AppTheme.riskHigh)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false),
          padding: EdgeInsets.zero,
        ),
        title: const Text('Settings'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Row(
                  children: [
                    Icon(
                      Icons.language,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'EN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryTeal.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 44,
                              color: AppTheme.primaryTeal,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Savitri Singh',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ASHA ID: ASHA-98765',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mediumText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nandpur Village, District Xyz',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'PREFERENCES',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context,
                        'Language',
                        _isEnglish ? 'English' : 'हिंदी',
                        Icons.language,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Select Language'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() => _isEnglish = true);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('English'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() => _isEnglish = false);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('हिंदी'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _buildToggleTile(
                        context,
                        'Outdoor Mode',
                        'High contrast UI',
                        Icons.brightness_high,
                        _outdoorMode,
                        (value) {
                          setState(() => _outdoorMode = value);
                        },
                      ),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _buildSettingsTile(
                        context,
                        'Data Sync',
                        'Auto sync enabled',
                        Icons.cloud_sync,
                      ),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _buildSettingsTile(
                        context,
                        'Notifications',
                        'On',
                        Icons.notifications_active,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'APP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context,
                        'About AI PulseTriage',
                        'Version 1.0.0',
                        Icons.info_outline,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('About AI PulseTriage'),
                              content: const Text(
                                'AI PulseTriage v1.0.0\n\n'
                                'Offline risk screening for rural health workers.\n\n'
                                '© 2024 Healthcare Innovation',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _buildSettingsTile(
                        context,
                        'Help & Support',
                        'FAQs and contact',
                        Icons.help_outline,
                      ),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _buildSettingsTile(
                        context,
                        'Privacy Policy',
                        'View terms',
                        Icons.policy,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.riskHigh,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Logout',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          
          // Floating Action Buttons (SOS & Voice)
          FloatingActionButtonsWidget(
            key: const ValueKey('settings_buttons'),
            isEnglish: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryTeal),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.mediumText,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.lightText),
      onTap: onTap,
    );
  }

  Widget _buildToggleTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryTeal),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.mediumText,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryTeal,
      ),
    );
  }
}
