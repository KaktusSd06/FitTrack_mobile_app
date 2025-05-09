class WaterIntake {
  final String id;
  final DateTime date;
  final int volumeMl;
  final String userId;

  WaterIntake({
    required this.id,
    required this.date,
    required this.volumeMl,
    required this.userId,
  });

  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    return WaterIntake(
      id: json['id'],
      date: DateTime.parse(json['date']),
      volumeMl: json['volumeMl'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'volumeMl': volumeMl,
      'userId': userId,
    };
  }

  WaterIntake copyWith({
    String? id,
    DateTime? date,
    int? volumeMl,
    String? userId,
  }) {
    return WaterIntake(
      id: id ?? this.id,
      date: date ?? this.date,
      volumeMl: volumeMl ?? this.volumeMl,
      userId: userId ?? this.userId,
    );
  }
}
