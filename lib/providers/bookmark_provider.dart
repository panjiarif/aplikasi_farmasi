import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark_obat_model.dart';

class BookmarkProvider with ChangeNotifier {
  List<BookmarkObat> _bookmarks = [];

  List<BookmarkObat> get bookmarks => _bookmarks;

  BookmarkProvider() {
    loadBookmarks();
  }

  void toggleBookmark(BookmarkObat obat) {
    if (isBookmarked(obat.id)) {
      _bookmarks.removeWhere((o) => o.id == obat.id);
    } else {
      _bookmarks.add(obat);
    }
    saveBookmarks();
    notifyListeners();
  }

  bool isBookmarked(String id) {
    return _bookmarks.any((o) => o.id == id);
  }

  void saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _bookmarks.map((o) => jsonEncode(o.toJson())).toList();
    prefs.setStringList('bookmarks', data);
  }

  void loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('bookmarks') ?? [];
    _bookmarks = data.map((s) => BookmarkObat.fromJson(jsonDecode(s))).toList();
    notifyListeners();
  }
}
