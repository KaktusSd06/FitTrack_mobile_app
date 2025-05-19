import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/gym_feedback_model.dart';

class GymFeedbackService {
  final _secureStorage = const FlutterSecureStorage();

  Future<List<GymFeedbackModel>> getFeedbacksByGymId(String gymId) async {
    final uri = Uri.parse('$baseUrl/api/GymFeedbacks/get-by-gymId/$gymId');
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => GymFeedbackModel.fromJson(json)).toList();
    } else if(response.statusCode == 404){
      return [];
    }
    else {
      throw Exception('Не вдалося завантажити відгуки: ${response.statusCode}\n${response.body}');
    }
  }

  Future<void> createFeedback({
    required int rating,
    String? title,
    String? review,
    required String gymId,
  }) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);
    final uri = Uri.parse('$baseUrl/api/GymFeedbacks');

    final body = {
      "rating": rating,
      "title": title,
      "review": review,
      "userId": userId,
      "gymId": gymId,
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      throw Exception('Не вдалося створити відгук: ${response.statusCode}\n${response.body}');
    }
  }

  Future<void> deleteFeedback(String id) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/GymFeedbacks/$id');

    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Не вдалося видалити відгук: ${response.statusCode}\n${response.body}');
    }
  }
}
