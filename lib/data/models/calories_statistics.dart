class CaloriesItem {
  final String period;
  final double totalCalories;

  CaloriesItem({required this.period, required this.totalCalories});

  factory CaloriesItem.fromJson(Map<String, dynamic> json) {
    return CaloriesItem(
      period: json['period'],
      totalCalories: (json['totalCalories'] as num).toDouble(),
    );
  }
}

class CaloriesStatistics {
  final List<CaloriesItem> items;
  final double averageCalories;

  CaloriesStatistics({required this.items, required this.averageCalories});

  factory CaloriesStatistics.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List)
        .map((item) => CaloriesItem.fromJson(item))
        .toList();

    return CaloriesStatistics(
      items: items,
      averageCalories: (json['averageCalories'] as num).toDouble(),
    );
  }
}