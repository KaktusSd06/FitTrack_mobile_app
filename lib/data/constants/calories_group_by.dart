enum CaloriesGroupBy { day, month }

extension CaloriesGroupByExtension on CaloriesGroupBy {
  String get name {
    switch (this) {
      case CaloriesGroupBy.day:
        return 'Day';
      case CaloriesGroupBy.month:
        return 'Month';
    }
  }
}