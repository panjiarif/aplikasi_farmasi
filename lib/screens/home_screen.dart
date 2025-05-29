import 'package:flutter/material.dart';

import 'cari_obat_screen.dart';
import 'cek_interaksi_screen.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CekInteraksiScreen()),
                );
              },
              child: Text("Cek Interaksi Obat"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman pencarian data obat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CariObatScreen()),
                );
              },
              child: Text("Cari Data Obat"),
            ),
          ],
        ),
      ),
    );
  }
}
