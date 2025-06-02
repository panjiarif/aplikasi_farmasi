import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bookmark_obat_model.dart';
import '../providers/bookmark_provider.dart';
import '../providers/cari_obat_provider.dart';

class DetailObatScreen extends StatefulWidget {
  final String idObat;

  DetailObatScreen({required this.idObat});

  @override
  _DetailObatScreenState createState() => _DetailObatScreenState();
}

class _DetailObatScreenState extends State<DetailObatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CariObatProvider>(context, listen: false)
          .fetchDetailObat(widget.idObat);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CariObatProvider, BookmarkProvider>(
      builder: (context, obatProvider, bookmarkProvider, _) {
        final isLoading = obatProvider.isLoadingDetailObat;
        final obat = obatProvider.detailObat;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text('Detail Obat'),
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
          ),
          floatingActionButton: obat != null
              ? FutureBuilder<bool>(
                  future: bookmarkProvider.isBookmarked(obat.id),
                  builder: (context, snapshot) {
                    final isMarked = snapshot.data ?? false;
                    return FloatingActionButton(
                      onPressed: () {
                        bookmarkProvider.toggleBookmark(
                          BookmarkObat(id: obat.id, nama: obat.names.first),
                        );
                      },
                      backgroundColor: Colors.blue.shade700,
                      child: Icon(
                        isMarked ? Icons.bookmark : Icons.bookmark_border,
                      ),
                    );
                  },
                )
              : null,
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : obat == null
                  ? Center(child: Text('Gagal mengambil detail.'))
                  : Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        children: [
                          Text(
                            obat.names.first,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 16),
                          buildInfoTile('ID KEGG', obat.id),
                          buildInfoTile(
                              'Nama Lain', obat.names.skip(1).join(", ")),
                          buildInfoTile('Formula', obat.formula),
                          buildInfoTile('Berat Molekul', obat.weight),
                          buildInfoTile('Kelas Obat', obat.classDrug),
                          buildInfoTile('Efek / Efikasi', obat.efficacy),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget buildInfoTile(String title, String content) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        tileColor: Colors.blue.shade50,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content.isNotEmpty ? content : '-'),
      ),
    );
  }
}
