import 'package:aplikasi_farmasi/providers/bookmark_provider.dart';
import 'package:aplikasi_farmasi/providers/cari_obat_provider.dart';
import 'package:aplikasi_farmasi/providers/cek_interaksi_provider.dart';
import 'package:aplikasi_farmasi/providers/jadwal_obat_provider.dart';
import 'package:aplikasi_farmasi/providers/location_provider.dart';
import 'package:aplikasi_farmasi/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'screens/login_screen.dart';
import 'screens/main_nav_screen.dart';
import 'screens/register_screen.dart';
import 'utils/session_manager.dart';

// Definisi plugin notifikasi di luar main agar bisa diakses global jika perlu
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Fungsi handler untuk background notification tap
// Harus berupa top-level function (di luar class)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('Notification clicked in background: ${notificationResponse.payload}');
  // Tambahkan logika navigasi atau penanganan lain di sini
  // Misalnya, Anda bisa menyimpan payload ke SharedPreferences dan menanganinya di main.dart
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi zona waktu
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); // Sesuaikan dengan zona waktu lokal Anda

  // Konfigurasi settings untuk Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Konfigurasi settings keseluruhan
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: DarwinInitializationSettings(), // Jika Anda juga mendukung iOS
  );

  // Inisialisasi plugin notifikasi dengan handler
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      // Handler ketika notifikasi diklik (aplikasi di foreground/background)
      print('Notification clicked: ${notificationResponse.payload}');
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CekInteraksiProvider()),
        ChangeNotifierProvider(create: (_) => CariObatProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => JadwalObatProvider(flutterLocalNotificationsPlugin)..loadSchedules()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharma Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade600,
          brightness: Brightness.light,
        ),
        useMaterial3: true, // tetap pakai Material 3
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.teal[600],
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
        ),
      ),
      home: FutureBuilder<bool>(
        future: SessionManager.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return snapshot.data == true ? MainNavigationScreen() : LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainNavigationScreen(),
      },
    );
  }
}
