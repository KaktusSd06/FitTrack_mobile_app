class WeightModel {
  String? id;
  double weightKg;
  DateTime date;
  String? userId;

  WeightModel({
    this.id,
    required this.weightKg,
    required this.date,
    this.userId,
  });

  factory WeightModel.fromJson(Map<String, dynamic> json) {
    return WeightModel(
      id: json['id'],
      weightKg: json['weightKg'] is int
          ? (json['weightKg'] as int).toDouble()
          : json['weightKg'],
      date: DateTime.parse(json['date']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'weightKg': weightKg,
      'date': date.toIso8601String(),
      if (userId != null) 'userId': userId,
    };
  }

  WeightModel copyWith({
    String? id,
    double? weightKg,
    DateTime? date,
    String? userId,
  }) {
    return WeightModel(
      id: id ?? this.id,
      weightKg: weightKg ?? this.weightKg,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'WeightModel(id: $id, weightKg: $weightKg, date: $date, userId: $userId)';
  }
}