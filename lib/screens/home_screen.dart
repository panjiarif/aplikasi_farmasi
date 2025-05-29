import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Beranda")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman cek interaksi
              },
              child: Text("Cek Interaksi Obat"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman pencarian data obat
              },
              child: Text("Cari Data Obat"),
            ),
          ],
        ),
      ),
    );
  }
}
