enum AlertStatus { noAlert, future, overdue, repeat, finished, today }

extension AlertStatusExtension on AlertStatus {
  int get value {
    switch (this) {
      case AlertStatus.noAlert:
        return 0;
      case AlertStatus.future:
        return 1;
      case AlertStatus.overdue:
        return 2;
      case AlertStatus.repeat:
        return 3;
      case AlertStatus.finished:
        return 4;
      case AlertStatus.today:
        return 5;
      default:
        return 0;
    }
  }
}
