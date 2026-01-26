import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../state/sync_controller.dart';

class SyncStatusPill extends ConsumerWidget {
  const SyncStatusPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncControllerProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: syncState.isOnline ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: syncState.isOnline ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            syncState.isOnline ? Icons.cloud_done : Icons.cloud_off,
            size: 16,
            color: syncState.isOnline ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            syncState.isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: syncState.isOnline ? Colors.green : Colors.red,
            ),
          ),
          if (syncState.lastSyncTime != null) ...[
            const SizedBox(width: 8),
            Text(
              'Last: ${DateFormat('HH:mm').format(syncState.lastSyncTime!)}',
              style: const TextStyle(fontSize: 10),
            ),
          ],
          if (syncState.pendingUploadsCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${syncState.pendingUploadsCount}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
