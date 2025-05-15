
import 'dart:convert';

import 'package:fittrack/data/models/message_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';

class TrainerCommentService {
  final secureStorage = const FlutterSecureStorage();

  Future<List<MessageModel>> getCommentsByUserId(
      {DateTime? date}) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);

    if (userId == null) {
      throw Exception('User ID not found in secure storage');
    }

    final queryParams = <String, String>{};
    if (date != null) {
      final adjustedDate = date.add(const Duration(hours: 3));
      queryParams['date'] = adjustedDate.toUtc().toIso8601String();
    }

    final uri = Uri.parse(
      '$baseUrl/api/TrainerComments/get-by-userId/$userId',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 404) return [];
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to fetch trainer comments: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (data is List) {
      return data.map((json) => MessageModel.fromJson(json)).toList();
    }

    return [];
  }
}