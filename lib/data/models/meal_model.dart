class MealModel {
  final String? id;
  final int weight;
  final String name;
  final double calories;
  final DateTime date;

  MealModel({
    this.id,
    required this.weight,
    required this.name,
    required this.calories,
    required this.date,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      weight: json['weight'],
      name: json['name'],
      calories: (json['calories'] as num).toDouble(),
      date: DateTime.parse(json['dateOfConsumption']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'name': name,
      'calories': calories,
      'dateOfConsumption': date.toUtc().toIso8601String(),
    };
  }
}
