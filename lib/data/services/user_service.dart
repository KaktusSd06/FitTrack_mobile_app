import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/gym_model.dart';
import '../models/trainer_model.dart';

enum PatchOperationType { replace }

class UserService {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> patchUserDetails({
    String? gymId,
    String? trainerId,
  }) async {
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/User/patch-user-details/$userId');

    final List<Map<String, dynamic>> operations = [];

    if (gymId != null) {
      operations.add({
        "op": "replace",
        "path": "/gymId",
        "value": gymId,
      });
    }

    operations.add({
      "op": "replace",
      "path": "/trainerId",
      "value": trainerId,
    });

    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(operations),
    );

    if (response.statusCode != 204) {
      throw Exception('Не вдалося оновити користувача: ${response.statusCode}\n${response.body}');
    }
  }

  Future<GymModel?> getGymByUserId() async {
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/User/get-gym-by-userId/$userId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return GymModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else if(response.statusCode == 404){
      return null;
    }
    else {
      throw Exception('Не вдалося отримати зал користувача: ${response.statusCode}\n${response.body}');
    }
  }

  Future<TrainerModel?> getTrainerByUserId() async {
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/User/get-trainer-by-userId/$userId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return TrainerModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Не вдалося отримати тренера користувача: ${response.statusCode}\n${response.body}');
    }
  }
}