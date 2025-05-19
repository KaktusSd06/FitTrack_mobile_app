import 'dart:convert';
import 'package:fittrack/data/models/group_training.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';

class GroupTrainingService {
  final _secureStorage = const FlutterSecureStorage();

  /// Отримання тренувань за залом і періодом
  Future<List<GroupTraining>> fetchTrainingsByGymAndPeriod({
    required String gymId,
    String? fromDate,
    String? toDate,
  }) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);

    final queryParams = <String, String>{};
    if (fromDate != null) queryParams['fromDate'] = fromDate;
    if (toDate != null) queryParams['toDate'] = toDate;

    final uri = Uri.parse('$baseUrl/api/GroupTraining/get-by-gymId-and-period/$gymId')
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => GroupTraining.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Не вдалося завантажити тренування: ${response.statusCode}\n${response.body}');
    }
  }

  /// Запис користувача на тренування
  Future<void> assignUserToTraining({
    required String trainingId,
  }) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);

    final uri = Uri.parse('$baseUrl/api/GroupTraining/assign-user/$trainingId')
        .replace(queryParameters: {'userId': userId});

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Не вдалося записати користувача: ${response.statusCode}\n${response.body}');
    }
  }

  /// Отримання історії тренувань користувача
  Future<List<GroupTraining>> fetchUserTrainingHistory() async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);

    final uri = Uri.parse('$baseUrl/api/GroupTraining/user-history/$userId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => GroupTraining.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Не вдалося отримати історію тренувань: ${response.statusCode}\n${response.body}');
    }
  }
}
