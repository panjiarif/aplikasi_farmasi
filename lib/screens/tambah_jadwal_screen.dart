// screens/add_medication_screen.dart
import 'package:aplikasi_farmasi/models/jadwal_obat_model.dart';
import 'package:aplikasi_farmasi/providers/jadwal_obat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TambahJadwalScreen extends StatefulWidget {
  @override
  _TambahJadwalScreenState createState() => _TambahJadwalScreenState();
}

class _TambahJadwalScreenState extends State<TambahJadwalScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  int _frekuensi = 1;
  String _aturanMinum = 'sebelum makan';
  TimeOfDay _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Jadwal Obat")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nama Obat'),
              onSaved: (val) => _nama = val!,
              validator: (val) => val!.isEmpty ? 'Masukkan nama obat' : null,
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Frekuensi Per Hari'),
              value: _frekuensi,
              onChanged: (val) => setState(() => _frekuensi = val!),
              items: [1, 2, 3]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e x sehari')))
                  .toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Aturan Minum'),
              value: _aturanMinum,
              onChanged: (val) => setState(() => _aturanMinum = val!),
              items: ['sebelum makan', 'sesudah makan', 'bersama makan']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            ListTile(
              title: Text("Jam Pertama Minum: ${_time.format(context)}"),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: _time);
                if (picked != null) setState(() => _time = picked);
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final now = DateTime.now();
                  final jamMulai = DateTime(now.year, now.month, now.day, _time.hour, _time.minute);
                  final schedule = JadwalObat(
                    namaObat: _nama,
                    frekuensi: _frekuensi,
                    aturanMinum: _aturanMinum,
                    jamMulai: jamMulai,
                  );

                  Provider.of<JadwalObatProvider>(context, listen: false).addSchedule(schedule);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Jadwal obat disimpan!")));
                  Navigator.pop(context);
                }
              },
              child: Text("Simpan Jadwal"),
            ),
          ]),
        ),
      ),
    );
  }
}