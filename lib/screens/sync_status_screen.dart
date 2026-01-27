import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/cards_buttons.dart';

class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({Key? key}) : super(key: key);

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen> {
  bool _isSyncing = false;
  int _unsynced = 3;

  // SOS & Voice variables
  Timer? _sosTimer;
  bool _sosActive = false;
  Offset _sosPosition = const Offset(0, 0);
  Offset _voicePosition = const Offset(0, 0);

  void _performSync() {
    setState(() => _isSyncing = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSyncing = false;
        _unsynced = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sync completed successfully'),
          backgroundColor: AppTheme.riskLow,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  void dispose() {
    _sosTimer?.cancel();
    super.dispose();
  }

  void _showSOSDialog() {
    _sosTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _activateSOS();
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Emergency Alert',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text(
          'Are you in emergency?\nSOS will activate if you don\'t respond in 5 seconds.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              _sosTimer?.cancel();
              Navigator.pop(context);
              _sosActive = false;
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              _sosTimer?.cancel();
              Navigator.pop(context);
              _activateSOS();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Emergency!'),
          ),
        ],
      ),
    );
  }

  void _activateSOS() {
    if (_sosActive) return;
    _sosActive = true;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '🚨 SOS Activated!\n📍 Location shared with emergency contact\n📞 Calling emergency contact...',
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _openVoiceAssistant() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎤 Voice Assistant Activated'),
        duration: Duration(seconds: 2),
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
        title: const Text('Sync Status'),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: AppTheme.riskLow.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppTheme.riskLow.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.cloud_done,
                              color: AppTheme.riskLow,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Connection Status',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Online - Ready to sync',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.riskLow,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sync Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSyncInfoRow(
                            context,
                            'Last Sync',
                            'Today at 2:30 PM',
                            Icons.history,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 1,
                            color: AppTheme.borderColor,
                          ),
                          const SizedBox(height: 12),
                          _buildSyncInfoRow(
                            context,
                            'Synced Records',
                            '47 visits',
                            Icons.check_circle,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 1,
                            color: AppTheme.borderColor,
                          ),
                          const SizedBox(height: 12),
                          _buildSyncInfoRow(
                            context,
                            'Pending Sync',
                            '$_unsynced records',
                            Icons.cloud_upload,
                            color: _unsynced > 0 ? AppTheme.riskMedium : AppTheme.riskLow,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: AppTheme.lightBg,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.storage,
                                color: AppTheme.primaryBlue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Offline Mode',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'All your data is saved locally. When you go offline, you can still create new visits and enter patient data. Sync will happen automatically when connection is restored.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.mediumText,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_unsynced > 0)
                    Card(
                      color: AppTheme.riskMedium.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  color: AppTheme.riskMedium,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Pending Records',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.riskMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'You have $_unsynced record(s) waiting to be synced. Tap "Sync Now" to send them.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.darkText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // SOS Button
          Positioned(
            left: _sosPosition.dx,
            bottom: _sosPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _sosPosition = Offset(
                    (_sosPosition.dx + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - 60),
                    (_sosPosition.dy - details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - 200),
                  );
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showSOSDialog,
                    customBorder: const CircleBorder(),
                    child: const Icon(Icons.sos, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ),
          // Voice Assistant Button
          Positioned(
            left: _voicePosition.dx,
            bottom: _voicePosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _voicePosition = Offset(
                    (_voicePosition.dx + details.delta.dx).clamp(0.0, MediaQuery.of(context).size.width - 60),
                    (_voicePosition.dy - details.delta.dy).clamp(0.0, MediaQuery.of(context).size.height - 200),
                  );
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentTeal.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openVoiceAssistant,
                    customBorder: const CircleBorder(),
                    child: const Icon(Icons.mic, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSyncing ? null : _performSync,
            child: Text(_isSyncing ? 'Syncing...' : 'Sync Now'),
          ),
        ),
      ),
    );
  }

  Widget _buildSyncInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color ?? AppTheme.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumText,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
