import 'package:flutter/material.dart';
import '../utils/session_manager.dart';

class HomeScreen extends StatelessWidget {
  void _logout(BuildContext context) async {
    await SessionManager.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PharmaCare")),
      body: Center(child: Text("Selamat datang!")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _logout(context),
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}
