import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/jadwal_obat_model.dart';
import '../providers/jadwal_obat_provider.dart';
import 'tambah_jadwal_screen.dart';

class JadwalObatScreen extends StatelessWidget {
  const JadwalObatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JadwalObatProvider>(context);
    final List<JadwalObat> jadwalList = provider.schedules;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Jadwal Minum Obat',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red[600],
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: jadwalList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada jadwal minum obat',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red[600]!, Colors.red[400]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Icon(Icons.alarm_on_rounded, size: 40, color: Colors.white),
                        Text(
                          "Pantau jadwal minum obat Anda",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: jadwalList.length,
                    itemBuilder: (ctx, i) {
                      final jadwal = jadwalList[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            jadwal.namaObat,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Aturan: ${jadwal.frekuensi}x sehari (${jadwal.aturanMinum})\nJam mulai: ${jadwal.jamMulai}',
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                // Navigasi ke form edit
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TambahJadwalScreen(),
                                  ),
                                );
                              } else if (value == 'hapus') {
                                provider.deleteSchedule(jadwal.id!);
                              }
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'hapus',
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TambahJadwalScreen(),
            ),
          );
        },
        backgroundColor: Colors.red[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
