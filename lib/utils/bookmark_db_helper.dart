import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bookmark_obat_model.dart';

class BookmarkDBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'bookmark.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks (
            id TEXT PRIMARY KEY,
            nama TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertBookmark(BookmarkObat obat) async {
    final dbClient = await db;
    await dbClient.insert('bookmarks', obat.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<BookmarkObat>> getBookmarks() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('bookmarks');
    return maps.map((map) => BookmarkObat.fromJson(map)).toList();
  }

  static Future<void> deleteBookmark(String id) async {
    final dbClient = await db;
    await dbClient.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  static Future<bool> isBookmarked(String id) async {
    final dbClient = await db;
    final maps = await dbClient.query('bookmarks', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty;
  }
}