// lib/widgets/feedback_display_dialog.dart
import 'package:flutter/material.dart';

class SaranPakBagus extends StatelessWidget {
  const SaranPakBagus({super.key});

  // Teks kritik dan saran Anda
  final String feedbackContent = """
  Kepada Bapak Dosen Pengampu Mata Kuliah Pemrograman Mobile,
  Bapak Bagus Muhammad Akbar, S.S.T., M.Kom.

  Assalamualaikum Warahmatullahi Wabarakatuh.

  Dengan hormat saya menyampaikan kritik, saran, dan pesan terkait mata kuliah Pemrograman Mobile yang telah saya jalani selama satu semester ini.
  Berikut adalah beberapa poin yang ingin saya sampaikan:

  Kesan & Pesan:
  Saya merasa tertekan pada saat mengerjakan tugas akhir mata kuliah Pemrograman Mobile ini, karena dekatnya deadline dan banyaknya requirement yang harus dipenuhi.
  Namun, saya juga merasa semua ini akan menjadi pengalaman yang baik sebelum saya masuk ke dunia kerja.
  Jangan pernah berhenti untuk menguji aplikasi mahasiswa dengan cara yang tidak normal Pak, supaya mahasiswa belajar betapa pentingnya penanganan error handling yang baik.


  Saran & Kritik:
  Untuk meningkatkan kualitas perkuliahan di masa mendatang, berikut saran saya :
  1. Untuk tugas akhir, sebaiknya diberikan waktu yang lebih fleksibel agar mahasiswa dapat mengerjakan dengan lebih maksimal.
  2. Untuk kuis-kuis, yang hanya sekedar teori menurut saya tidak perlu banyak banyak, justru perbanyak tugas praktik.
  3. Satu lagi untuk laporan tugas akhir, menurut saya ini baik tapi sangat membebankan jika waktu sangat sedikit diberikan.

  Demikianlah yang dapat saya sampaikan, semgoa Pak Baguse selalu dalam lindungan Allah SWT. Aamiin.

  Terima kasih atas perhatian Bapak.

  Wassalamualaikum Warahmatullahi Wabarakatuh.

  Hormat Saya,
  Panji Arif J - 123220091
  """;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // insetPadding penting untuk mengatur lebar dialog
      // horizontal: 24.0 adalah default, Anda bisa coba 16.0 jika terlalu lebar
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      title: const Text(
        "Kritik & Saran untuk Dosen",
        textAlign: TextAlign.center, // Pusatkan judul
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal, // Sesuaikan warna tema Anda
        ),
      ),
      content: SingleChildScrollView(
        // Memastikan teks bisa di-scroll
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Agar Column tidak mengambil ruang lebih
          crossAxisAlignment: CrossAxisAlignment.start, // Teks rata kiri
          children: [
            // Menggunakan SelectableText agar teks bisa dicopy (opsional)
            SelectableText(
              feedbackContent,
              textAlign: TextAlign.justify, // Teks rata kanan-kiri
              style: const TextStyle(
                  fontSize: 14, height: 1.5), // Tinggi baris untuk keterbacaan
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "Tutup",
            style: TextStyle(color: Colors.teal), // Sesuaikan warna tema
          ),
        ),
      ],
    );
  }
}
