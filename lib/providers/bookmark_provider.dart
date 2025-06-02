import 'package:flutter/material.dart';

import '../models/bookmark_obat_model.dart';
import '../utils/bookmark_db_helper.dart';

class BookmarkProvider with ChangeNotifier {
  List<BookmarkObat> _bookmarks = [];

  List<BookmarkObat> get bookmarks => _bookmarks;

  BookmarkProvider() {
    loadBookmarks();
  }

  Future<void> toggleBookmark(BookmarkObat obat) async {
    final exists = await BookmarkDBHelper.isBookmarked(obat.id);
    if (exists) {
      await BookmarkDBHelper.deleteBookmark(obat.id);
      _bookmarks.removeWhere((o) => o.id == obat.id);
    } else {
      await BookmarkDBHelper.insertBookmark(obat);
      _bookmarks.add(obat);
    }
    notifyListeners();
  }

  Future<void> loadBookmarks() async {
    _bookmarks = await BookmarkDBHelper.getBookmarks();
    notifyListeners();
  }

  Future<bool> isBookmarked(String id) async {
    return await BookmarkDBHelper.isBookmarked(id);
  }
}
