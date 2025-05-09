import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/sleep_statistic_response.dart';

class SleepStatisticsService {
  final secureStorage = const FlutterSecureStorage();


  SleepStatisticsService();

  Future<SleepStatisticResponse> fetchSleepStatistics({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/SleepStatistics/$userId').replace(
      queryParameters: {
        'fromDate': fromDate.toUtc().toIso8601String(),
        'toDate': toDate.toUtc().toIso8601String(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch sleep statistics: ${response.statusCode} ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return SleepStatisticResponse.fromJson(json);
  }

}
