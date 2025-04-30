import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrack/core/config/secure_storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fittrack/core/config/config.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();


  Future<http.Response> loginWithGoogle({
    required String firstName,
    required String lastName,
    required String email,
    String? profilePicture,
    required int role,
  }) async {
    final uri = Uri.parse('$baseUrl/api/Account/login-mobile');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'profilePicture': profilePicture,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final accessToken = responseBody[SecureStorageKeys.accessToken];
      final refreshToken = responseBody[SecureStorageKeys.refreshToken];

      _secureStorage.write(key: SecureStorageKeys.accessToken, value: accessToken);
      _secureStorage.write(key: SecureStorageKeys.refreshToken, value: refreshToken);
      print("User successfully added");
      return response;
    } else {
      print("Login failed: ${response.body}");
      throw Exception('Помилка входу: ${response.statusCode}');
    }
  }


  Future<UserCredential?> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        return null;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final firstName = gUser.displayName?.split(" ").first ?? "";
      final lastName = gUser.displayName?.split(" ").last ?? "";
      final email = gUser.email;

      final response = await loginWithGoogle(
        firstName: firstName,
        lastName: lastName,
        email: email,
        profilePicture: gUser.photoUrl,
        role: 1,
      );

      if (response.statusCode == 200) {
        await _secureStorage.write(
          key: SecureStorageKeys.idToken,
          value: gAuth.idToken,
        );

        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        return null;
      }
    } catch (e) {
      print("Помилка входу через Google: $e");
      return null;
    }
  }

  Future<void> refreshTokenIfNeeded() async {

    final uri = Uri.parse('$baseUrl/api/Account/refresh-token/mobile');

    final storedRefreshToken = await _secureStorage.read(key: SecureStorageKeys.refreshToken);

    if (storedRefreshToken == null) {
      throw Exception("Refresh token is missing.");
    }

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'refreshToken': storedRefreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final newAccessToken = responseBody[SecureStorageKeys.accessToken];
      final newRefreshToken = responseBody[SecureStorageKeys.refreshToken];

      if (newAccessToken != null && newRefreshToken != null) {
        await _secureStorage.write(key: SecureStorageKeys.accessToken, value: newAccessToken);
        await _secureStorage.write(key: SecureStorageKeys.refreshToken, value: newRefreshToken);
        await _secureStorage.write(
          key: SecureStorageKeys.refreshTokenDate,
          value: DateTime.now().toIso8601String(),
        );
      } else {
        throw Exception("Invalid response format — missing tokens.");
      }
    } else {
      throw Exception('Failed to refresh token: ${response.statusCode}\n${response.body}');
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await _secureStorage.deleteAll();
    } catch (e) {
      print("Помилка виходу: $e");
    }
  }

  Future<void> deleteAccount({
    required String email,
  }) async {

    final url = Uri.parse('$baseUrl/api/Account/by-email');

    final accessToken = await _secureStorage.read(key: SecureStorageKeys.accessToken);

    if (accessToken == null) {
      throw Exception('Access token відсутній. Авторизуйтесь знову.');
    }

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Сервер повернув помилку: ${response.statusCode}\n${response.body}');
    }
    else{
      signOut();
    }
  }
}