import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fittrack/core/config/secure_storage_keys.dart';

import '../../core/config/config.dart';
import '../models/set_model.dart';

class SetService {
  final _secureStorage = const FlutterSecureStorage();

  Future<List<SetModel>> getSetsByIndividualTrainingId(String individualTrainingId) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/Sets/get-by-individual-training-Id/$individualTrainingId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Не вдалося отримати сети: ${response.statusCode}\n${response.body}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => SetModel.fromJson(json)).toList();
  }

  Future<SetModel?> createSet(SetModel set) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/Sets');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'weight': set.weight,
        'reps': set.reps,
        'exerciseId': set.exerciseId,
        'individualTrainingId': set.individualTrainingId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SetModel(
          id: response.body,
          weight: set.weight,
          reps: set.reps,
          exerciseId: set.exerciseId,
          individualTrainingId: set.individualTrainingId,
      );
    } else {
      return null;
    }
  }

  Future<bool> deleteSet(String id) async {
    final url = Uri.parse('$baseUrl/api/Sets/$id');
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);

    final response = await http.delete(
        url,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Не вдалося видалити Set (статус: ${response.statusCode})');
    }
  }
}
