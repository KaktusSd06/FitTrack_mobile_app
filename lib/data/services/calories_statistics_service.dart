import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../core/config/secure_storage_keys.dart';
import '../constants/calories_group_by.dart';
import '../models/calories_statistics.dart';

class CaloriesStatisticsService {
  final String baseUrl;
  final _secureStorage = const FlutterSecureStorage();

  CaloriesStatisticsService({this.baseUrl = 'https://fittrack-latest.onrender.com'});

  Future<CaloriesStatistics> fetchCaloriesStatistics({
    required DateTime fromDate,
    required DateTime toDate,
    required PeriodType groupBy,
  }) async {
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/CaloriesStatistics/$userId').replace(
      queryParameters: {
        'fromDate': fromDate.toUtc().toIso8601String(),
        'toDate': toDate.toUtc().toIso8601String(),
        'caloriesGroupBy': groupBy.name,
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return CaloriesStatistics.fromJson(data);
    } else {
      throw Exception('Failed to load calories statistics: ${response.statusCode}');
    }
  }
}