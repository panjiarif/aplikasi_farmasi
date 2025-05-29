import 'package:flutter/material.dart';

class SaranScreen extends StatelessWidget {
  const SaranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saran"),
      ),
      body: Column(
        children: [
          Text("Saran Halaman", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
