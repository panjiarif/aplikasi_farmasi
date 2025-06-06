// lib/widgets/time_display_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async'; // Untuk Timer

class WaktuDunia extends StatefulWidget {
  const WaktuDunia({super.key});

  @override
  State<WaktuDunia> createState() => _WaktuDuniaState();
}

class _WaktuDuniaState extends State<WaktuDunia> {
  late Timer _timer;
  late tz.TZDateTime _currentTime;

  // Daftar zona waktu yang ingin ditampilkan
  final Map<String, String> _timeZones = {
    'Waktu Indonesia Barat (WIB)': 'Asia/Jakarta', // Zona waktu lokal Anda
    'Waktu Indonesia Tengah (WITA)': 'Asia/Makassar',
    'Waktu Indonesia Timur (WIT)': 'Asia/Jayapura',
    'UTC/GMT/London': 'Europe/London',
    'Makkah (Saudi Arabia)': 'Asia/Riyadh', // Atau Asia/Mecca jika ada
    'Tokyo (Jepang)': 'Asia/Tokyo',
  };

  @override
  void initState() {
    super.initState();
    // Inisialisasi waktu pertama kali
    _updateTime();
    // Set up timer untuk memperbarui waktu setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    if (mounted) {
      // Pastikan widget masih ada di tree sebelum setState
      setState(() {
        _currentTime = tz.TZDateTime.now(tz.local);
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Batalkan timer saat widget di-dispose
    super.dispose();
  }

  // Fungsi pembantu untuk mendapatkan waktu di zona waktu tertentu
  tz.TZDateTime _getTimeInTimeZone(String locationName) {
    try {
      final location = tz.getLocation(locationName);
      return tz.TZDateTime.from(_currentTime, location);
    } catch (e) {
      // Tangani jika zona waktu tidak ditemukan (jarang terjadi jika nama benar)
      print('Error getting timezone for $locationName: $e');
      return _currentTime; // Fallback ke waktu lokal
    }
  }

  // Fungsi pembantu untuk memformat waktu
  String _formatTime(tz.TZDateTime time) {
    final formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm:ss');
    return formatter.format(time);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      title: const Text(
        "Waktu Dunia Saat Ini",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Agar teks rata kiri
          children: _timeZones.entries.map((entry) {
            final String zoneName = entry.key;
            final String locationName = entry.value;
            final tz.TZDateTime timeInZone = _getTimeInTimeZone(locationName);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$zoneName:',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    _formatTime(timeInZone),
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 20, 20, 20)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Tutup", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
