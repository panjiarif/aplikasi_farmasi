import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../utils/db_helper.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    // Debugging line to check if username is retrieved correctly
    print('Retrieved username: $username');
    
    if (username != null) {
      final dbHelper = DBHelper();
      final userFromDb = await dbHelper.getUser(username);

      if (userFromDb != null) {
        _user = userFromDb;
        notifyListeners();
      }
    }
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<void> updateUser(UserModel newUser) async {
    final dbHelper = DBHelper(); // pastikan sudah diimport
    final prefs = await SharedPreferences.getInstance();

    // Ambil user lama untuk membandingkan password
    final oldUser = _user;

    // Jika password kosong, tetap gunakan password lama
    final updatedUser = UserModel(
      id: newUser.id,
      username: newUser.username,
      passwordHash: (newUser.passwordHash.isEmpty)
        ? (oldUser?.passwordHash ?? '')
        : hashPassword(newUser.passwordHash),

    );

    // Simpan ke SQLite
    await dbHelper.updateUser(updatedUser);

    // Simpan ke SharedPreferences
    prefs.setString('user', jsonEncode(updatedUser.toJson()));

    // Update state
    _user = updatedUser;
    notifyListeners();
  }

}
