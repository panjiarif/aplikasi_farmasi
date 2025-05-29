import 'package:flutter/material.dart';

class CariObatScreen extends StatelessWidget {
  const CariObatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cari Obat"),
      ),
      body: Center(
        child: Text(
          "Halaman Cari Obat",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}