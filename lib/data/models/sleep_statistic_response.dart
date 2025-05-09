import 'sleep_statistic_entry.dart';

class SleepStatisticResponse {
  final List<SleepStatisticEntry> sleepGrouped;
  final double averageDurationMinutes;

  SleepStatisticResponse({
    required this.sleepGrouped,
    required this.averageDurationMinutes,
  });

  factory SleepStatisticResponse.fromJson(Map<String, dynamic> json) {
    final grouped = (json['sleepGrouped'] as List)
        .map((e) => SleepStatisticEntry.fromJson(e))
        .toList();

    return SleepStatisticResponse(
      sleepGrouped: grouped,
      averageDurationMinutes: json['averageDurationMinutes'],
    );
  }

  factory SleepStatisticResponse.empty() {
    return SleepStatisticResponse(
      sleepGrouped: [],
      averageDurationMinutes: 0,
    );
  }
}
