import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('user');
    if (jsonStr != null) {
      _user = UserModel.fromJson(jsonDecode(jsonStr));
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel newUser) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(newUser.toJson()));
    _user = newUser;
    notifyListeners();
  }
}
