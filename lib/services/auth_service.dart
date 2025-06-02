import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import '../utils/db_helper.dart';
import '../utils/session_manager.dart';

class AuthService {
  final DBHelper _dbHelper = DBHelper();

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<bool> register(String username, String password) async {
    final existing = await _dbHelper.getUser(username);
    if (existing != null) return false;

    final user = UserModel(
      username: username,
      passwordHash: hashPassword(password),
    );
    await _dbHelper.insertUser(user);
    return true;
  }

  Future<bool> login(String username, String password) async {
    final user = await _dbHelper.getUser(username);
    if (user == null) return false;

    final hash = hashPassword(password);
    if (user.passwordHash == hash) {
      await SessionManager.setLoginSession(user.id!, user.username);
      return true;
    }
    return false;
  }
}
