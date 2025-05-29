import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil Saya')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto Profil
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile.jpg'), // ganti sesuai path gambar
              ),
            ),
            SizedBox(height: 16),

            // Nama
            Text(
              'Panji Arif JR',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Biodata poin-poin
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileItem('NIM', '123220091'),
                profileItem('Email', 'panji@gmail.com'),
                profileItem('Nomor HP', '0838-xxxx-xxxx'),
                profileItem('Alamat', 'Surokarsa MGII/538, Yogyakarta'),
                profileItem('Status', 'Mahasiswa Informatika'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget profileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(text: "$title: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
