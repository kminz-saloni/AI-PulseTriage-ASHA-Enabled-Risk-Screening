enum TaskStatus {
  open,
  done,
  blocked,
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.open:
        return 'Open';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.blocked:
        return 'Blocked';
    }
  }
}
