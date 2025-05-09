class SleepEntry {
  final String id;
  final DateTime sleepStart;
  final DateTime wakeUpTime;
  final String userId;

  SleepEntry({
    required this.id,
    required this.sleepStart,
    required this.wakeUpTime,
    required this.userId,
  });

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      id: json['id'],
      sleepStart: DateTime.parse(json['sleepStart']),
      wakeUpTime: DateTime.parse(json['wakeUpTime']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sleepStart': sleepStart.toIso8601String(),
      'wakeUpTime': wakeUpTime.toIso8601String(),
      'userId': userId,
    };
  }

  SleepEntry copyWith({
    String? id,
    DateTime? sleepStart,
    DateTime? wakeUpTime,
    String? userId,
  }) {
    return SleepEntry(
      id: id ?? this.id,
      sleepStart: sleepStart ?? this.sleepStart,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      userId: userId ?? this.userId,
    );
  }
}
