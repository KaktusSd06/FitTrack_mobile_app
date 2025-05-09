import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/weight_model.dart';

class WeightService {
  final secureStorage = const FlutterSecureStorage();

  Future<String?> _getUserId() async =>
      await secureStorage.read(key: SecureStorageKeys.userId);

  Future<String?> _getAccessToken() async =>
      await secureStorage.read(key: SecureStorageKeys.accessToken);

  Future<void> addWeight({required double weightKg, required DateTime date}) async {
    final userId = await _getUserId();
    final accessToken = await _getAccessToken();

    if (userId == null || accessToken == null) {
      throw Exception('Missing user ID or access token');
    }

    final uri = Uri.parse('$baseUrl/api/WeightsInfo');

    final body = json.encode({
      'weightKg': weightKg,
      'date': date.toUtc().toIso8601String(),
      'userId': userId,
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add weight: ${response.statusCode}');
    }
  }

  Future<List<WeightModel>> getWeightsBetween(DateTime from, DateTime to) async {
    final userId = await _getUserId();
    final accessToken = await _getAccessToken();

    final uri = Uri.parse(
      '$baseUrl/api/WeightsInfo/get-by-userId-and-period/$userId',
    ).replace(queryParameters: {
      'fromDate': from.toUtc().toIso8601String(),
      'toDate': to.toUtc().toIso8601String(),
    });

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 404) {
      return [];
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weights: ${response.statusCode}');
    }


    final List data = json.decode(response.body);
    return data.map((json) => WeightModel.fromJson(json)).toList();
  }

  Future<WeightModel?> getLatestWeight() async {
    final now = DateTime.now();
    final weights = await getWeightsBetween(DateTime(2000), now);

    if (weights.isEmpty) return null;

    weights.sort((a, b) => b.date.compareTo(a.date));
    return weights.first;
  }

  Future<double?> getChangeThisMonth() async {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, 1);
    final to = now;

    final weights = await getWeightsBetween(from, to);
    if (weights.length < 2) return null;

    weights.sort((a, b) => a.date.compareTo(b.date));
    return weights.last.weightKg - weights.first.weightKg;
  }

  Future<double?> getChangeFromPrevious() async {
    final now = DateTime.now();
    final weights = await getWeightsBetween(DateTime(2000), now);

    if (weights.length < 2) return null;

    weights.sort((a, b) => b.date.compareTo(a.date));
    return weights[0].weightKg - weights[1].weightKg;
  }
}
