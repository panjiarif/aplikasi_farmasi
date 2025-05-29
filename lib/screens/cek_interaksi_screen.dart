import 'package:flutter/material.dart';

class CekInteraksiScreen extends StatelessWidget {
  const CekInteraksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Interaksi"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Cek Interaksi Halaman",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aksi yang ingin dilakukan saat tombol ditekan
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tombol ditekan!')),
                );
              },
              child: const Text("Tekan Saya"),
            ),
          ],
        ),
      ),
    );
  }
}