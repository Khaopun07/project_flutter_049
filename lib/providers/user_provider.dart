import 'package:flutter/material.dart';
import 'package:natthawut_flutter_049/models/user_model.dart';

class UserProvider with ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  void updateAccessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }

  void updateRefreshToken(String token) {
    _refreshToken = token;
    notifyListeners();
  }

  // logout
  void onLogout() {
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }
}