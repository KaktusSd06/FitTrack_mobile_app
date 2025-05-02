import 'dart:convert';
import 'package:fittrack/core/config/secure_storage_keys.dart';
import 'package:fittrack/data/models/individual_training_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/config.dart';

class IndividualTrainingService {
  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  IndividualTrainingService();

  Future<IndividualTrainingModel> getIndividualTrainingsByPeriod({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);

    if (userId == null) {
      throw Exception('User ID not found in secure storage');
    }

    final uri = Uri.parse(
      '$baseUrl/api/IndividualTrainings/get-by-userId-and-period/'
          '$userId/${fromDate.toUtc().toIso8601String()}/${toDate.toUtc().toIso8601String()}',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);

      if (decoded.isNotEmpty) {
        final Map<String, dynamic> trainingData = decoded[0] as Map<String, dynamic>;

        final training = IndividualTrainingModel.fromJson(trainingData);
        return training;
      } else {
        throw Exception('No data found');
      }
    }
    else {
      throw Exception('Failed to fetch workouts: ${response.statusCode}\n${response.body}');
    }
  }


  Future<String> createIndividualTraining({
    required DateTime date,
    String? trainerId,
  }) async {
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/IndividualTrainings');

    final body = {
      'userId': userId,
      'trainerId': trainerId,
      'date': date.toUtc().toIso8601String(),
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create workout: ${response.statusCode}');
    }

    final responseBody = jsonDecode(response.body);
    return responseBody;
  }
}
