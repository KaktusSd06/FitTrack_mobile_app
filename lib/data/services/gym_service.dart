import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/gym_model.dart';

class GymService {
  final _secureStorage = const FlutterSecureStorage();

  Future<List<GymModel>> fetchGyms() async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/Gyms');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => GymModel.fromJson(json)).toList();
    } else {
      throw Exception('Не вдалося завантажити зали: ${response.statusCode}\n${response.body}');
    }
  }

  Future<GymModel> getGymById(String id) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/Gyms/$id');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return GymModel.fromJson(jsonData);
    } else {
      throw Exception('Не вдалося отримати зал: ${response.statusCode}\n${response.body}');
    }
  }
}
