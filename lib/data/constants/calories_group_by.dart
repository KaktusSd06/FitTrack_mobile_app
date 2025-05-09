enum PeriodType { day, month }

extension PeriodTypeExtension on PeriodType {
  String get name {
    switch (this) {
      case PeriodType.day:
        return 'Day';
      case PeriodType.month:
        return 'Month';
    }
  }
}