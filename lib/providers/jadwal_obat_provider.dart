import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/jadwal_obat_model.dart';
import '../utils/jadwal_db_helper.dart';
import 'package:collection/collection.dart'; // Import ini untuk firstWhereOrNull

class JadwalObatProvider with ChangeNotifier {
  final List<JadwalObat> _schedules = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  JadwalObatProvider(this.flutterLocalNotificationsPlugin);

  List<JadwalObat> get schedules => _schedules;

  // Tambahkan metode ini untuk testing notifikasi instan
  Future<void> showAddNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel_id', // Channel ID baru untuk tes
      'Test Notifikasi',  // Nama channel untuk tes
      channelDescription: 'Channel untuk menguji notifikasi instan',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker text', // Teks yang muncul sebentar di status bar
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Langsung tampilkan notifikasi sekarang
    await flutterLocalNotificationsPlugin.show(
      0, // ID notifikasi unik (gunakan 0 atau angka lain yang tidak akan bentrok)
      title,
      body,
      platformChannelSpecifics,
      payload: 'test_payload',
    );
    print('Notifikasi tes instan telah dipicu.');
  }

  // Metode untuk menjadwalkan notifikasi dengan penundaan singkat untuk debugging
  Future<void> scheduleDelayedTestNotification(int delaySeconds) async {
    final tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: delaySeconds));

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'delayed_test_channel_id', // Channel ID baru untuk tes tertunda
      'Test Notifikasi Tertunda',
      channelDescription: 'Channel untuk menguji notifikasi dengan penundaan',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, // ID notifikasi unik
      'Notifikasi Tes Tertunda',
      'Ini adalah notifikasi tes yang dijadwalkan untuk $delaySeconds detik kemudian!',
      scheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Tetap gunakan ini untuk konsistensi, meskipun tidak relevan untuk delay singkat
    );
    print('Notifikasi tes tertunda dijadwalkan pada: $scheduledTime');
  }

  Future<void> loadSchedules() async {
    _isLoading = true;
    notifyListeners();
    _schedules.clear();
    final data = await JadwalDbHelper().getAllJadwal();
    _schedules.addAll(data);
    _isLoading = false;
    notifyListeners();
    // Opsional: Jadwalkan ulang notifikasi yang sudah ada saat aplikasi dimuat
    // agar notifikasi yang mungkin hilang setelah reboot perangkat bisa kembali
    // for (var schedule in _schedules) {
    //   _scheduleNotifications(schedule);
    // }
  }

  Future<void> addSchedule(JadwalObat schedule) async {
    final id = await JadwalDbHelper().insertJadwal(schedule);
    schedule.id = id;
    _schedules.add(schedule);
    _scheduleNotifications(schedule);
    notifyListeners();
  }

  Future<void> updateSchedule(JadwalObat updated) async {
    await JadwalDbHelper().updateJadwal(updated);
    final index = _schedules.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      final oldSchedule = _schedules[index]; // Ambil jadwal lama sebelum di-update
      _schedules[index] = updated; // Update di daftar lokal

      // Batalkan notifikasi lama berdasarkan frekuensi lama
      _cancelNotificationsBySchedule(oldSchedule);
      // Jadwalkan ulang notifikasi dengan data yang diperbarui
      _scheduleNotifications(updated);
      notifyListeners();
    }
  }

  Future<void> deleteSchedule(int id) async {
    // Gunakan firstWhereOrNull untuk penanganan null yang aman
    final scheduleToDelete = _schedules.firstWhereOrNull((e) => e.id == id);
    if (scheduleToDelete != null) {
      await JadwalDbHelper().deleteJadwal(id);
      _schedules.removeWhere((e) => e.id == id);
      _cancelNotificationsBySchedule(scheduleToDelete); // Panggil fungsi pembatalan
      notifyListeners();
    } else {
      print('Jadwal obat dengan ID $id tidak ditemukan untuk dihapus.');
    }
  }

  /// Fungsi untuk menjadwalkan notifikasi berdasarkan objek JadwalObat.
  void _scheduleNotifications(JadwalObat schedule) {
    if (schedule.id == null) {
      print('Error: ID jadwal obat null, tidak bisa menjadwalkan notifikasi.');
      return;
    }

    // Menghitung interval jam antara setiap notifikasi dalam sehari
    // Jika frekuensi 1, interval 24 jam. Jika 2, interval 12 jam. Jika 3, interval 8 jam.
    int intervalHours = 24 ~/ schedule.frekuensi;

    for (int i = 0; i < schedule.frekuensi; i++) {
      // Menghitung jam notifikasi yang spesifik untuk iterasi ini
      // Dimulai dari jamMulai, ditambah kelipatan intervalHours
      final scheduledTime = schedule.jamMulai.add(Duration(hours: i * intervalHours));

      // ID unik untuk setiap notifikasi (penting untuk pembatalan dan update)
      // schedule.id! * 10 memberikan rentang ID yang cukup untuk setiap jadwal,
      // lalu ditambah 'i' untuk ID unik per notifikasi dalam jadwal tersebut.
      final notificationId = (schedule.id! * 10) + i;

      flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Waktunya Minum Obat!', // Judul notifikasi
        'Jangan lupa minum ${schedule.namaObat} (${schedule.aturanMinum}).', // Body notifikasi
        _nextInstanceOf(scheduledTime), // Waktu pasti notifikasi akan muncul
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'obat_channel', // ID channel notifikasi (harus unik)
            'Pengingat Obat', // Nama channel yang terlihat di pengaturan Android
            channelDescription: 'Notifikasi jadwal minum obat Anda', // Deskripsi channel
            importance: Importance.max, // Pentingnya notifikasi (memunculkan pop-up)
            priority: Priority.high, // Prioritas notifikasi
            // Jika ingin ikon notifikasi kustom, tambahkan di sini:
            // smallIcon: 'nama_ikon_di_drawable', // Contoh: 'ic_launcher'
            // largeIcon: DrawableResourceAndroidBitmap('nama_ikon_besar_di_drawable'),
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Penting untuk akurasi di Doze mode
        matchDateTimeComponents: DateTimeComponents.time, // Hanya cocokkan waktu (jam, menit, detik)
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime, // Interpretasi waktu absolut
      );
      print('Menjadwalkan notifikasi (ID: $notificationId) untuk ${schedule.namaObat} jam ke-${i + 1} pada: ${_nextInstanceOf(scheduledTime)}');
    }
  }

  /// Fungsi untuk membatalkan notifikasi berdasarkan objek JadwalObat.
  /// Ini memastikan semua notifikasi terkait dengan jadwal tertentu dibatalkan.
  void _cancelNotificationsBySchedule(JadwalObat schedule) {
    if (schedule.id == null) {
      print('Error: ID jadwal obat null, tidak bisa membatalkan notifikasi.');
      return;
    }
    for (int i = 0; i < schedule.frekuensi; i++) {
      final notificationId = (schedule.id! * 10) + i;
      flutterLocalNotificationsPlugin.cancel(notificationId);
      print('Membatalkan notifikasi ID: $notificationId untuk ${schedule.namaObat}');
    }
  }

  /// Menentukan waktu berikutnya untuk menjadwalkan notifikasi agar sesuai dengan waktu yang ditentukan.
  /// Jika waktu yang diinginkan sudah lewat hari ini, notifikasi akan dijadwalkan untuk hari berikutnya.
  tz.TZDateTime _nextInstanceOf(DateTime time) {
    final now = tz.TZDateTime.now(tz.local); // Waktu sekarang dalam zona waktu lokal
    
    // Buat objek TZDateTime untuk waktu yang dijadwalkan hari ini
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second, // Sertakan detik untuk presisi lebih
    );

    // Jika waktu yang dijadwalkan (hari ini) sudah lewat dari waktu sekarang,
    // maka jadwal notifikasi untuk hari berikutnya.
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }
}