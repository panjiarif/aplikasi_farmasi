import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/jadwal_obat_model.dart';
import '../providers/jadwal_obat_provider.dart';

class TambahJadwalScreen extends StatefulWidget {
  // Jika ini juga digunakan untuk edit, Anda bisa passing JadwalObat di sini
  final JadwalObat? initialSchedule;
  const TambahJadwalScreen({super.key, this.initialSchedule});

  @override
  _TambahJadwalScreenState createState() => _TambahJadwalScreenState();
}

class _TambahJadwalScreenState extends State<TambahJadwalScreen> {
  final _formKey = GlobalKey<FormState>();
  String _namaObat = ''; // Ubah _nama menjadi _namaObat agar lebih jelas
  int _frekuensi = 1;
  String _aturanMinum = 'sebelum makan';
  TimeOfDay _jamMulai = TimeOfDay.now(); // Ubah _time menjadi _jamMulai

  // Jika Anda ingin ini bisa digunakan untuk mengedit juga,
  // inisialisasi state dari widget.initialSchedule di initState
  @override
  void initState() {
    super.initState();
    if (widget.initialSchedule != null) {
      _namaObat = widget.initialSchedule!.namaObat;
      _frekuensi = widget.initialSchedule!.frekuensi;
      _aturanMinum = widget.initialSchedule!.aturanMinum;
      _jamMulai = TimeOfDay.fromDateTime(widget.initialSchedule!.jamMulai);
    }
  }

  void _simpanJadwal() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Gabungkan TimeOfDay dengan tanggal saat ini untuk membuat DateTime
      final now = DateTime.now();
      final jamMulaiDateTime = DateTime(
          now.year, now.month, now.day, _jamMulai.hour, _jamMulai.minute);

      final schedule = JadwalObat(
        namaObat: _namaObat,
        frekuensi: _frekuensi,
        aturanMinum: _aturanMinum,
        jamMulai: jamMulaiDateTime,
      );

      final provider = Provider.of<JadwalObatProvider>(context, listen: false);

      // Jika untuk edit, panggil updateSchedule
      if (widget.initialSchedule != null) {
        schedule.id = widget.initialSchedule!.id;
        provider.updateSchedule(schedule);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal obat berhasil diperbarui!')),
        );
      } else {
        // Untuk menambah jadwal baru
        provider.addSchedule(schedule);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Jadwal minum obat $_namaObat berhasil ditambahkan!')),
        );
        // Pastikan JadwalObatProvider memiliki method showAddNotification atau sesuaikan
        provider.showAddNotification(
          title: 'Jadwal Obat Ditambahkan',
          body: 'Jadwal minum obat $_namaObat telah ditambahkan.',
        );
      }
      Navigator.pop(context); // Kembali ke layar sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Background yang sama dengan JadwalObatScreen
      appBar: AppBar(
        title: const Text(
          "Tambah Jadwal Obat", // Judul AppBar
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor:
            Colors.red[600], // Warna yang sama dengan JadwalObatScreen
        elevation: 0, // Elevation yang sama
        centerTitle: true, // Judul di tengah
        iconTheme: const IconThemeData(
            color: Colors.white), // Warna ikon panah kembali
      ),
      body: SingleChildScrollView(
        // Tambahkan SingleChildScrollView untuk mencegah overflow pada keyboard
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            // Ubah ListView menjadi Column di sini jika padding sudah di SingleChildScrollView
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Agar tombol dan field mengisi lebar
            children: [
              TextFormField(
                initialValue: _namaObat, // Untuk mode edit
                decoration: InputDecoration(
                  labelText: 'Nama Obat',
                  hintText: 'Misal: Paracetamol, Vitamin C',
                  border: OutlineInputBorder(
                    // Gaya border
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.medical_services_outlined,
                      color: Colors.red[600]), // Ikon
                ),
                onSaved: (val) => _namaObat = val!,
                validator: (val) =>
                    val!.isEmpty ? 'Nama obat tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20), // Jarak antar field
              DropdownButtonFormField<int>(
                value: _frekuensi,
                decoration: InputDecoration(
                  labelText: 'Frekuensi Per Hari',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon:
                      Icon(Icons.repeat, color: Colors.red[600]), // Ikon
                ),
                onChanged: (val) => setState(() => _frekuensi = val!),
                items: [1, 2, 3]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text('$e x sehari'),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _aturanMinum,
                decoration: InputDecoration(
                  labelText: 'Aturan Minum',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.restaurant_menu,
                      color: Colors.red[600]), // Ikon
                ),
                onChanged: (val) => setState(() => _aturanMinum = val!),
                items: ['sebelum makan', 'sesudah makan', 'bersama makan']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              const SizedBox(height: 20),
              // ListTile untuk pemilihan jam
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    "Jam Mulai Minum",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  subtitle: Text(
                    _jamMulai.format(context), // Menggunakan _jamMulai
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red, // Sesuai tema
                    ),
                  ),
                  trailing: Icon(Icons.access_time,
                      color: Colors.red[600], size: 30),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _jamMulai,
                      builder: (context, child) {
                        return MediaQuery(
                          // Untuk memastikan time picker menggunakan 24 jam format jika sistem ponsel mendukung
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) setState(() => _jamMulai = picked);
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _simpanJadwal, // Panggil method _simpanJadwal
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor:
                      Colors.red[600], // Warna tombol sesuai AppBar jadwal
                  foregroundColor: Colors.white, // Warna teks tombol
                  elevation: 5,
                ),
                child: const Text(
                  "Simpan Jadwal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
