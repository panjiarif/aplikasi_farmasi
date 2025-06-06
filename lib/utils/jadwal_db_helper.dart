import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/jadwal_obat_model.dart';

class JadwalDbHelper {
  static final JadwalDbHelper _instance = JadwalDbHelper._internal();
  factory JadwalDbHelper() => _instance;
  JadwalDbHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'jadwal_obat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE jadwal_obat (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            namaObat TEXT,
            frekuensi INTEGER,
            aturanMinum TEXT,
            jamMulai TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertJadwal(JadwalObat jadwal) async {
    final dbClient = await db;
    return await dbClient.insert('jadwal_obat', jadwal.toMap());
  }

  Future<List<JadwalObat>> getAllJadwal() async {
    final dbClient = await db;
    final res = await dbClient.query('jadwal_obat');
    return res.map((e) => JadwalObat.fromMap(e)).toList();
  }

  Future<int> updateJadwal(JadwalObat jadwal) async {
    final dbClient = await db;
    return await dbClient.update(
      'jadwal_obat',
      jadwal.toMap(),
      where: 'id = ?',
      whereArgs: [jadwal.id],
    );
  }

  Future<int> deleteJadwal(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'jadwal_obat',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}