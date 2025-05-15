import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/sleep/sleep_entry_model.dart';

class SleepService {
  final secureStorage = const FlutterSecureStorage();

  Future<SleepEntry?> getSleepById(String id) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/Sleeps/$id');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return SleepEntry.fromJson(json);
      }

      if (response.statusCode == 404) {
        return null;
      }

      throw Exception('API error: ${response.statusCode}, ${response.body}');
    } catch (e) {
      throw Exception('Failed to get sleep by ID: $e');
    }
  }


  Future<SleepEntry?> getSleepByUserAndDate(DateTime date) async {
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/Sleeps/get-by-userId-and-day/$userId')
        .replace(queryParameters: {'date': date.toIso8601String()});


    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
      );

      // Повертаємо null для 404 (не знайдено) статусу
      if (response.statusCode == 404) {
        return null;
      }

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          return SleepEntry.fromJson(jsonList.first);
        }
      }

      // Для інших помилок кидаємо виключення
      if (response.statusCode != 200) {
        throw Exception('API error: ${response.statusCode}, ${response.body}');
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get sleep data: $e');
    }
  }

  Future<String?> addSleep(SleepEntry entry) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    final response = await http.post(
      Uri.parse('$baseUrl/api/Sleeps'),
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'sleepStart': entry.sleepStart.subtract(const Duration(days: 1)).toIso8601String(),
        'wakeUpTime': entry.wakeUpTime.subtract(const Duration(days: 1)).toIso8601String(),
        'userId': entry.userId,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body) as String;
    }
    return null;
  }

  Future<bool> updateSleep(SleepEntry entry) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    final response = await http.put(
      Uri.parse('$baseUrl/api/Sleeps/${entry.id}'),
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(entry.toJson()),
    );

    return response.statusCode == 204;
  }

  Future<void> upsertSleep({
    required String userId,
    required DateTime sleepStart,
    required DateTime wakeUpTime,
    String? id,
  }) async {
    if (id != null && id.isNotEmpty) {
      // If ID is provided, try to get existing entry by ID
      final existing = await getSleepById(id);
      if (existing != null) {
        // Update existing entry
        final updated = existing.copyWith(
          sleepStart: sleepStart,
          wakeUpTime: wakeUpTime,
        );
        await updateSleep(updated);
        return;
      }
    }

    // If ID is not provided or entry not found by ID,
    // check if there's an entry for this date
    final existing = await getSleepByUserAndDate(sleepStart);
    if (existing != null) {
      final updated = existing.copyWith(
        sleepStart: sleepStart,
        wakeUpTime: wakeUpTime,
      );
      await updateSleep(updated);
    } else {
      // Create new entry
      await addSleep(SleepEntry(
        id: '',
        sleepStart: sleepStart,
        wakeUpTime: wakeUpTime,
        userId: userId,
      ));
    }
  }
}