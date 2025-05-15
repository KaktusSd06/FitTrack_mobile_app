import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/trainer_model.dart';

class TrainerService {
  final _secureStorage = const FlutterSecureStorage();

  Future<List<TrainerModel>> getTrainersByGymId(String gymId) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/Trainer/get-by-gymId/$gymId');

    final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TrainerModel.fromJson(json)).toList();
    } else if(response.statusCode == 404){
      return [];
    }
    else {
      throw Exception('Не вдалося завантажити тренерів: ${response.statusCode}');
    }
  }
}
