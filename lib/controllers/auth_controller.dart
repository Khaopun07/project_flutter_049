import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:natthawut_flutter_049/varibles.dart';
import 'package:provider/provider.dart';
import 'package:natthawut_flutter_049/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class AuthController {
  // Function to save tokens in SharedPreferences
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  // Function to get access token
  Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Function to get refresh token
  Future<String?> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> login(BuildContext context, String username, String password) async {
    print('API URL: $apiURL');

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": username, "password": password}),
    );

    print('Response status code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      String accessToken = data['accessToken'];
      String refreshToken = data['refreshToken'];
      String role = data['user']['role'];

      print("Access Token: $accessToken");
      print("Refresh Token: $refreshToken");
      print("Role: $role");

      // Save tokens to SharedPreferences
      await _saveTokens(accessToken, refreshToken);

      // Update UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateAccessToken(accessToken);
      userProvider.updateRefreshToken(refreshToken);

      // Navigate based on role
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      print('Login failed: ${response.body}');
    }
  }

  Future<void> register(BuildContext context, String username, String password, String name, String role) async {
    final Map<String, dynamic> registerData = {
      "email": username,
      "password": password,
      "name": name,
      "role": role,
    };

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(registerData),
    );

    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print('Registration failed: ${response.body}');
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  Future<void> refreshToken(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/refresh"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userProvider.refreshToken}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);

      final accessToken = data['accessToken'];
      userProvider.updateAccessToken(accessToken); // แก้ไขให้รับแค่ accessToken
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
