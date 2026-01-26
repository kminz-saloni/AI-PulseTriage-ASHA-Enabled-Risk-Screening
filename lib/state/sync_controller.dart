import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/sync_repository.dart';

class SyncState {
  final bool isOnline;
  final DateTime? lastSyncTime;
  final int pendingUploadsCount;
  final bool isSyncing;

  const SyncState({
    required this.isOnline,
    this.lastSyncTime,
    required this.pendingUploadsCount,
    this.isSyncing = false,
  });

  SyncState copyWith({
    bool? isOnline,
    DateTime? lastSyncTime,
    int? pendingUploadsCount,
    bool? isSyncing,
  }) {
    return SyncState(
      isOnline: isOnline ?? this.isOnline,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      pendingUploadsCount: pendingUploadsCount ?? this.pendingUploadsCount,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

class SyncController extends StateNotifier<SyncState> {
  final SyncRepository _repository;

  SyncController(this._repository)
      : super(const SyncState(
          isOnline: false,
          pendingUploadsCount: 0,
        )) {
    _init();
  }

  Future<void> _init() async {
    final isOnline = await _repository.isOnline();
    final lastSync = await _repository.getLastSyncTime();
    final pending = await _repository.getPendingUploadsCount();
    
    state = SyncState(
      isOnline: isOnline,
      lastSyncTime: lastSync,
      pendingUploadsCount: pending,
    );
  }

  Future<void> performSync() async {
    state = state.copyWith(isSyncing: true);
    
    try {
      await _repository.performSync();
      final isOnline = await _repository.isOnline();
      final lastSync = await _repository.getLastSyncTime();
      final pending = await _repository.getPendingUploadsCount();
      
      state = SyncState(
        isOnline: isOnline,
        lastSyncTime: lastSync,
        pendingUploadsCount: pending,
        isSyncing: false,
      );
    } catch (e) {
      state = state.copyWith(isSyncing: false);
    }
  }
}

final syncRepositoryProvider = Provider<SyncRepository>((ref) => SyncRepository());

final syncControllerProvider = StateNotifierProvider<SyncController, SyncState>((ref) {
  final repo = ref.watch(syncRepositoryProvider);
  return SyncController(repo);
});
