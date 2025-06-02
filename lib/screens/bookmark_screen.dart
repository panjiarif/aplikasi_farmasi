import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmark_provider.dart';
import '../screens/detail_obat_screen.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final bookmarks = bookmarkProvider.bookmarks;

    return Scaffold(
      appBar: AppBar(title: Text('Bookmark Obat')),
      body: bookmarks.isEmpty
          ? Center(child: Text('Belum ada bookmark'))
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final obat = bookmarks[index];
                return ListTile(
                  title: Text(obat.nama),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailObatScreen(idObat: obat.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
