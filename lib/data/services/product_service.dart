import 'dart:convert';
import 'package:fittrack/data/models/store/service_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/store/product_model.dart';

class ProductService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<List<ProductModel>> getProductsByGymId(String gymId) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/Products/get-by-gymId/$gymId')
        .replace(queryParameters: {'type': "Good"});

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => ProductModel.fromJson(json)).toList();

    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Не вдалося завантажити продукти: ${response.statusCode}');
    }
  }

  Future<List<ServiceModel>> getServicesByGymid(String gymId) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/Products/get-by-gymId/$gymId')
        .replace(queryParameters: {'type': "Service"});

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => ServiceModel.fromJson(json)).toList();

    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Не вдалося завантажити продукти: ${response.statusCode}');
    }
  }
}