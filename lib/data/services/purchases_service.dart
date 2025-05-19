import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/config.dart';
import '../../core/config/secure_storage_keys.dart';
import '../models/store/purchases_model.dart';
import '../models/store/user_membership_model.dart';

class PurchaseMembershipService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<List<PurchaseModel>> getPurchaseHistoryByUserId() async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);

    final uri = Uri.parse('$baseUrl/api/Purchases/get-history-by-userId/$userId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PurchaseModel.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Не вдалося отримати історію покупок: ${response.statusCode}');
    }
  }

  Future<String> createPurchase(double price, String productId, String gymId) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);


    final uri = Uri.parse('$baseUrl/api/Purchases');

    final body = jsonEncode({
      'price': price,
      'productId': productId,
      'userId': userId,
      'gymId': gymId,
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return response.body.replaceAll('"', '');
    } else {
      throw Exception('Не вдалося створити покупку: ${response.statusCode}');
    }
  }

  Future<List<UserMembershipModel>> getUserMembershipHistoryByUserId() async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);
    final userId = await _secureStorage.read(key: SecureStorageKeys.userId);

    final uri = Uri.parse('$baseUrl/api/UserMemberships/get-history-by-userId/$userId');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserMembershipModel.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Не вдалося отримати історію членств: ${response.statusCode}');
    }
  }

  Future<String> createUserMembership(String userId, String membershipId) async {
    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);

    final uri = Uri.parse('$baseUrl/api/UserMemberships');

    final body = jsonEncode({
      'userId': userId,
      'membershipId': membershipId,
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return response.body.replaceAll('"', '');
    } else if(response.statusCode == 404){
      return '';
    }
    else {
      throw Exception('Не вдалося створити членство: ${response.statusCode}');
    }
  }
}