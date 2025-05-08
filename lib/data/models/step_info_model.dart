class StepsInfo {
  final String id;
  final int steps;
  final DateTime date;
  final String userId;

  StepsInfo({
    required this.id,
    required this.steps,
    required this.date,
    required this.userId,
  });

  factory StepsInfo.fromJson(Map<String, dynamic> json) {
    return StepsInfo(
      id: json['id'],
      steps: json['steps'],
      date: DateTime.parse(json['date']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'steps': steps,
    'date': date.toUtc().toIso8601String(),
    'userId': userId,
  };
}
