import 'package:flutter/material.dart';

import '../utils/session_manager.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  void _logout(BuildContext context) async {
    await SessionManager.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bantuan"),
      ),
      body: Column(
        children: [
          Text("Bantuan Halaman", style: TextStyle(fontSize: 20)),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _logout(context),
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}
