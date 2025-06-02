import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cari_obat_provider.dart';
import 'bookmark_screen.dart';
import 'detail_obat_screen.dart';

class CariObatScreen extends StatefulWidget {
  @override
  State<CariObatScreen> createState() => _CariObatScreenState();
}

class _CariObatScreenState extends State<CariObatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _cariObat(BuildContext context) {
    final provider = Provider.of<CariObatProvider>(context, listen: false);
    final namaObat = _controller.text.trim();

    if (namaObat.isEmpty) {
      _showSnackBar(context, 'Nama obat tidak boleh kosong', Colors.red);
      return;
    } else if (namaObat.length < 3) {
      _showSnackBar(context, 'Nama obat minimal 3 huruf', Colors.orange);
      return;
    } else if (namaObat.length > 50) {
      _showSnackBar(context, 'Nama obat maksimal 50 huruf', Colors.orange);
      return;
    }

    FocusScope.of(context).unfocus();
    provider.cariObat(namaObat);
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        final provider = Provider.of<CariObatProvider>(context, listen: false);
        provider.reset();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CariObatProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Cari Obat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: ElevatedButton(
        child: Text("Lihat Bookmark"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookmarkScreen()),
          );
        },
      ),
      body: Column(
        children: [
          // Header dengan gradient
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[600]!, Colors.blue[400]!],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Masukkan nama obat yang ingin dicari",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => _cariObat(context),
                    decoration: InputDecoration(
                      hintText: 'Contoh: Paracetamol, Ibuprofen',
                      prefixIcon: Icon(Icons.search, color: Colors.blue[600]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: provider.isLoading
                              ? Colors.grey
                              : Colors.blue[600],
                        ),
                        onPressed: provider.isLoading
                            ? null
                            : () => _cariObat(context),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildContent(provider, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CariObatProvider provider, BuildContext context) {
    if (provider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
            ),
            SizedBox(height: 16),
            Text(
              'Mencari obat...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (provider.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            SizedBox(height: 16),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              provider.error,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => provider.reset(),
              icon: Icon(Icons.refresh),
              label: Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (provider.hasil.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Belum ada hasil pencarian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Masukkan nama obat untuk mulai mencari',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hasil Pencarian (${provider.hasil.length})',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: provider.hasil.length,
            itemBuilder: (context, index) {
              final item = provider.hasil[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailObatScreen(idObat: item.id),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.medication,
                              color: Colors.blue[600],
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.nama,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'ID: ${item.id}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
