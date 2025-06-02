import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmark_provider.dart';
import 'detail_obat_screen.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final bookmarks = bookmarkProvider.bookmarks;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Bookmark Obat'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: bookmarks.isEmpty
          ? Center(child: Text('Belum ada bookmark'))
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final obat = bookmarks[index];

                return Dismissible(
                  key: Key(obat.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Hapus Bookmark'),
                        content: Text(
                            'Apakah Anda yakin ingin menghapus "${obat.nama}" dari bookmark?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Batal'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    bookmarkProvider.toggleBookmark(obat);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${obat.nama} dihapus dari bookmark'),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    color: Colors.red.shade400,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(
                        obat.nama,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailObatScreen(idObat: obat.id),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
