import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fittrack/core/config/secure_storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/config/config.dart';
import '../models/exercise_model.dart';


class ExerciseService {
  final _secureStorage = const FlutterSecureStorage();

  Future<List<ExerciseModel>> fetchExercises() async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/Exercises');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ExerciseModel.fromJson(json)).toList();
    } else {
      throw Exception('Не вдалося завантажити вправи: ${response.statusCode}\n${response.body}');
    }
  }

  Future<void> createExercise(ExerciseModel exercise) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/Exercises');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(exercise.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Не вдалося створити вправу: ${response.statusCode}\n${response.body}');
    }
  }

  Future<ExerciseModel> getExerciseById(String id) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/Exercises/$id');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Не вдалося отримати вправу: ${response.statusCode}\n${response.body}');
    }
    try {
      final dynamic jsonData = jsonDecode(response.body);

      if (jsonData is List) {
        if (jsonData.isEmpty) {
          throw Exception('API повернув порожній список вправ');
        }

        final Map<String, dynamic> exerciseData = jsonData.first;
        return ExerciseModel(
          id: exerciseData["id"],
          name: exerciseData["name"],
          description: exerciseData["description"],
        );
      }
      else if (jsonData is Map<String, dynamic>) {
        return ExerciseModel(
          id: jsonData["id"],
          name: jsonData["name"],
          description: jsonData["description"],
        );
      }
      else {
        throw Exception('Неочікуваний формат даних від API');
      }
    } catch (e) {
      throw Exception('Не вдалося завантажити вправу: $e');
    }
  }
}
