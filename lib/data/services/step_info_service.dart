import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/step_info_model.dart';

class StepsInfoService {
  final _secureStorage = const FlutterSecureStorage();

  Future<List<StepsInfo>> fetchStepsByPeriod({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);

    final uri = Uri.parse(
      '$baseUrl/api/StepsInfo/get-by-userId-and-period/$userId?fromDate=${fromDate.toUtc().toIso8601String()}&toDate=${toDate.toUtc().toIso8601String()}',
    );

    final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => StepsInfo.fromJson(json)).toList();
    } else if(response.statusCode == 404){
      return [];
    }
    else {
      throw Exception('Failed to fetch steps');
    }
  }

  Future<void> addOrUpdateSteps({
    required int steps,
    required DateTime date,
  }) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);
    final existingRecords = await fetchStepsByPeriod(
      fromDate: date,
      toDate: date,
    );

    if (existingRecords.isNotEmpty) {
      final existing = existingRecords.first;
      final uri = Uri.parse('$baseUrl/api/StepsInfo/${existing.id}');
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'id': existing.id,
          'steps': steps,
          'date': date.toUtc().toIso8601String(),
          'userId': userId,
        }),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to update steps');
      }
    } else {
      final uri = Uri.parse('$baseUrl/api/StepsInfo/');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'steps': steps,
          'date': date.toUtc().toIso8601String(),
          'userId': userId,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create steps');
      }
    }
  }
}
