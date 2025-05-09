import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';

class GoalService {
  final secureStorage = const FlutterSecureStorage();

  Future<void> setOrUpdateGoal({
    required String goalType,
    required int value,
  }) async {
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    if (userId == null || accessToken == null) {
      throw Exception('Missing user ID or access token');
    }

    final existingGoal = await getGoalDetails(goalType: goalType);

    if (existingGoal != null) {
      await updateGoal(
        id: existingGoal['id'],
        goalType: goalType,
        value: value,
      );
    } else {
      final uri = Uri.parse('$baseUrl/api/UserGoal');

      final body = {
        'goalType': goalType,
        'value': value,
        'userId': userId,
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(body),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create goal: ${response.statusCode}');
      }
    }
  }

  Future<void> updateGoal({
    required String id,
    required String goalType,
    required int value,
  }) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/UserGoal/$id');

    final body = {
      'id': id,
      'goalType': goalType,
      'value': value,
    };

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update goal: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> getGoalDetails({required String goalType}) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);

    if (userId == null) {
      throw Exception('User ID not found in secure storage');
    }

    final uri = Uri.parse(
      '$baseUrl/api/UserGoal/get-by-userId-and-goal-type/$userId',
    ).replace(queryParameters: {
      'goalType': goalType,
    });

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch goal: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (data is List && data.isNotEmpty) {
      return data[0];
    }

    return null;
  }

  Future<double> getGoalValue({required String goalType}) async {
    final goal = await getGoalDetails(goalType: goalType);
    if (goal != null && goal['value'] != null) {
      return (goal['value'] as num).toDouble();
    } else {
      return 0;
    }
  }
}
