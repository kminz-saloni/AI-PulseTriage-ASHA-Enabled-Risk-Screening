import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Status'),
      ),
      body: SingleChildScrollView(
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
