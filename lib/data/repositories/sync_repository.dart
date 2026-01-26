class SyncRepository {
  DateTime? _lastSyncTime;
  int _pendingUploadsCount = 3;
  bool _isOnline = false;

  Future<bool> isOnline() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _isOnline;
  }

  Future<DateTime?> getLastSyncTime() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _lastSyncTime;
  }

  Future<int> getPendingUploadsCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _pendingUploadsCount;
  }

  Future<void> performSync() async {
    await Future.delayed(const Duration(seconds: 2));
    _lastSyncTime = DateTime.now();
    _pendingUploadsCount = 0;
    _isOnline = true;
  }

  Future<void> simulatePhcOutcomeUpdate(String referralId, String outcome) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void setOffline() {
    _isOnline = false;
  }

  void addPendingUpload() {
    _pendingUploadsCount++;
  }
}
