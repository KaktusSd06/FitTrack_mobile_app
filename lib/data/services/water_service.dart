import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/water_intake_model.dart';

class WaterService {
  final secureStorage = const FlutterSecureStorage();

  Future<WaterIntake?> getWaterIntakeByUserAndDate(DateTime date) async {
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/WaterIntakeLogs/get-by-userId-and-day/$userId')
        .replace(queryParameters: {
      'date': date.toIso8601String(),
    });

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          return WaterIntake.fromJson(jsonList.first);
        }
      }

      if (response.statusCode == 404) {
        return null;
      }

      throw Exception('Failed to get water intake: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error getting water intake: $e');
    }
  }

  Future<String?> addWaterIntake(WaterIntake entry) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    final response = await http.post(
      Uri.parse('$baseUrl/api/WaterIntakeLogs'),
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(entry.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body) as String;
    }

    return null;
  }

  Future<bool> updateWaterIntake(WaterIntake entry) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    final response = await http.put(
      Uri.parse('$baseUrl/api/WaterIntakeLogs/${entry.id}'),
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(entry.toJson()),
    );

    return response.statusCode == 204;
  }

  Future<void> upsertWaterIntake({
    required String userId,
    required DateTime date,
    required int volumeMl,
  }) async {

    final existing = await getWaterIntakeByUserAndDate(date);

    if (existing != null) {
      final updated = existing.copyWith(volumeMl: volumeMl);
      await updateWaterIntake(updated);
    } else {
      await addWaterIntake(WaterIntake(
        id: '',
        date: date,
        volumeMl: volumeMl,
        userId: userId,
      ));
    }
  }
}
