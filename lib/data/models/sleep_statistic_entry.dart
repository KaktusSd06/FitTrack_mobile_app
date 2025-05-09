class SleepStatisticEntry {
  final DateTime date;
  final int durationMinutes;

  SleepStatisticEntry({
    required this.date,
    required this.durationMinutes,
  });

  factory SleepStatisticEntry.fromJson(Map<String, dynamic> json) {
    return SleepStatisticEntry(
      date: DateTime.parse(json['date']),
      durationMinutes: json['durationMinutes'],
    );
  }
}
