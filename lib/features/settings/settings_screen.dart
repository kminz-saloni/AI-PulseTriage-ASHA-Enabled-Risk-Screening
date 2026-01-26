import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../state/app_settings_controller.dart';
import '../../state/sync_controller.dart';
import '../../l10n/app_localizations.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsControllerProvider);
    final syncState = ref.watch(syncControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(settings.locale.languageCode == 'en' ? l10n.english : l10n.hindi),
            trailing: Switch(
              value: settings.locale.languageCode == 'hi',
              onChanged: (value) {
                ref.read(appSettingsControllerProvider.notifier).toggleLanguage();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(l10n.themeMode),
            subtitle: Text(settings.themeMode == ThemeMode.system ? l10n.system : 
                           settings.themeMode == ThemeMode.light ? l10n.light : l10n.dark),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              items: [
                DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.system)),
                DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.light)),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.dark)),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(appSettingsControllerProvider.notifier).setThemeMode(mode);
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(l10n.manualSync),
            subtitle: Text(
              syncState.lastSyncTime != null
                  ? '${l10n.lastSync}: ${syncState.lastSyncTime}'
                  : 'Never synced',
            ),
            trailing: syncState.isSyncing
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      ref.read(syncControllerProvider.notifier).performSync();
                    },
                    child: Text(l10n.syncNow),
                  ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.about),
            subtitle: Text('${l10n.appTitle} ${l10n.version} 1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Model Version'),
            subtitle: Text('rules_v1'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              ref.read(authStateProvider.notifier).state = false;
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
