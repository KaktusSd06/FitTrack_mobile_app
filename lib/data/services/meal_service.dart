import 'package:fittrack/core/config/secure_storage_keys.dart';
import 'package:fittrack/data/models/meal_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/config/config.dart';

class MealService{
  final secureStorage = const FlutterSecureStorage();

  Future<List<MealModel>> getMealByUserIdAdnDate({required date}) async {
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);

    if (userId == null) {
      throw Exception('User ID not found in secure storage');
    }

    final uri = Uri.parse(
        '$baseUrl/api/Meal/get-by-userId-and-day/$userId'
    ).replace(
      queryParameters: {
        'date': date.toUtc().toIso8601String(),
      },
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
        final meals = decoded
            .map((item) => MealModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return meals;
      } else {
        throw Exception('No data found');
      }
    }
    if(response.statusCode == 404){
      return [];
    }
    else {
      throw Exception('Failed to fetch meals by user id and date: ${response.statusCode}\n${response.body}');
    }
  }

  Future<MealModel> createMeal({
    required int weight,
    required String name,
    required double calories,
    required DateTime date,
}) async {
    final userId = await secureStorage.read(key: SecureStorageKeys.userId);
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/Meal');

    final body = {
      'userId': userId,
      'name': name,
      'calories': calories,
      'weight': weight,
      'dateOfConsumption': date.toUtc().toIso8601String(),
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
    return MealModel(
        id: responseBody,
        weight: weight,
        name: name,
        calories: calories,
        date: date
    );
  }

  Future<bool> deleteMealById({
    required String mealId,
  }) async {
    final accessToken = await secureStorage.read(key: SecureStorageKeys.accessToken);
    final uri = Uri.parse('$baseUrl/api/Meal/$mealId');

    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode == 204;
  }


}