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

class _DetailObatScreenState extends State<DetailObatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    Future.microtask(() {
      Provider.of<CariObatProvider>(context, listen: false)
          .fetchDetailObat(widget.idObat);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CariObatProvider, BookmarkProvider>(
      builder: (context, obatProvider, bookmarkProvider, _) {
        final isLoading = obatProvider.isLoadingDetailObat;
        final obat = obatProvider.detailObat;

        // Start animation ketika data sudah dimuat
        if (!isLoading && obat != null && !_animationController.isCompleted) {
          _animationController.forward();
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
              'Detail Obat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.blue[600],
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            actions: obat != null
                ? [
                    FutureBuilder<bool>(
                      future: bookmarkProvider.isBookmarked(obat.id),
                      builder: (context, snapshot) {
                        final isMarked = snapshot.data ?? false;
                        return IconButton(
                          onPressed: () {
                            bookmarkProvider.toggleBookmark(
                              BookmarkObat(id: obat.id, nama: obat.names.first),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isMarked
                                      ? 'Bookmark dihapus'
                                      : 'Ditambahkan ke bookmark',
                                ),
                                backgroundColor:
                                    isMarked ? Colors.grey : Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Icon(
                            isMarked ? Icons.bookmark : Icons.bookmark_border,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ]
                : null,
          ),
          body: isLoading
              ? _buildLoadingState()
              : obat == null
                  ? _buildErrorState()
                  : _buildDetailContent(obat),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[600]!, Colors.blue[400]!],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Memuat detail obat...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[600]!, Colors.blue[400]!],
        ),
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red[400],
              ),
              SizedBox(height: 16),
              Text(
                'Gagal Memuat Detail',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tidak dapat mengambil detail obat. Periksa koneksi internet Anda.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Kembali',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailContent(dynamic obat) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header dengan gradient
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[600]!, Colors.blue[400]!],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medication,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Informasi lengkap tentang obat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama obat utama
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue[100]!, Colors.blue[50]!],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue[200]!, width: 1),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_pharmacy,
                          size: 40,
                          color: Colors.blue[600],
                        ),
                        SizedBox(height: 12),
                        Text(
                          obat.names.first,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Informasi Detail",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Detail cards
                  _buildDetailCard(
                    'ID KEGG',
                    obat.id,
                    Icons.fingerprint,
                    Colors.purple,
                  ),
                  _buildDetailCard(
                    'Nama Lain',
                    obat.names.skip(1).join(", "),
                    Icons.text_fields,
                    Colors.green,
                  ),
                  _buildDetailCard(
                    'Formula',
                    obat.formula,
                    Icons.science,
                    Colors.orange,
                  ),
                  _buildDetailCard(
                    'Berat Molekul',
                    obat.weight,
                    Icons.monitor_weight,
                    Colors.red,
                  ),
                  _buildDetailCard(
                    'Kelas Obat',
                    obat.classDrug,
                    Icons.category,
                    Colors.indigo,
                  ),
                  _buildDetailCard(
                    'Efek / Efikasi',
                    obat.efficacy,
                    Icons.healing,
                    Colors.teal,
                  ),

                  SizedBox(height: 20),

                  // Disclaimer
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.amber[200]!, width: 1),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.amber[700],
                          size: 30,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Disclaimer",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Informasi ini hanya untuk referensi. Konsultasikan dengan dokter atau apoteker sebelum menggunakan obat ini.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber[700],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
      String title, String content, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    content.isNotEmpty ? content : 'Tidak tersedia',
                    style: TextStyle(
                      fontSize: 16,
                      color: content.isNotEmpty
                          ? Colors.grey[800]
                          : Colors.grey[500],
                      height: 1.3,
                      fontStyle:
                          content.isEmpty ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
