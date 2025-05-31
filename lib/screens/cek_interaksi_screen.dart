import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cek_interaksi_provider.dart';

class CekInteraksiScreen extends StatefulWidget {
  @override
  _CekInteraksiScreenState createState() => _CekInteraksiScreenState();
}

class _CekInteraksiScreenState extends State<CekInteraksiScreen> {
  final _drug1Controller = TextEditingController();
  final _drug2Controller = TextEditingController();

  void _cekInteraksi(BuildContext context) {
    final namaObat1 = _drug1Controller.text.trim();
    final namaObat2 = _drug2Controller.text.trim();

    // Validasi input
    if (namaObat1.isEmpty || namaObat2.isEmpty) {
      _showErrorDialog(context, "Nama obat tidak boleh kosong.");
      return;
    }

    if (namaObat1.length < 3 || namaObat2.length < 3) {
      _showErrorDialog(context, "Nama obat minimal terdiri dari 3 huruf.");
      return;
    }

    FocusScope.of(context).unfocus();

    final provider = Provider.of<CekInteraksiProvider>(context, listen: false);
    provider.fetchInteraksi(namaObat1, namaObat2);
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Input tidak valid"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("Tutup"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cek Interaksi Obat')),
      body: Padding(
  padding: const EdgeInsets.all(16),
  child: Consumer<CekInteraksiProvider>(
    builder: (context, provider, _) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _drug1Controller,
              decoration: InputDecoration(labelText: "Nama Obat 1"),
            ),
            TextField(
              controller: _drug2Controller,
              decoration: InputDecoration(labelText: "Nama Obat 2"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () => _cekInteraksi(context),
              child: Text("Cek Interaksi"),
            ),
            SizedBox(height: 24),

            // Loading
            if (provider.isLoading)
              Center(child: CircularProgressIndicator()),

            // Jika tidak loading, tampilkan hasil
            if (!provider.isLoading &&
                (_drug1Controller.text.isNotEmpty &&
                    _drug2Controller.text.isNotEmpty)) ...[
              Text(
                "Interaksi antara:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(provider.namaObat1?.isNotEmpty == true
                  ? provider.namaObat1!
                  : _drug1Controller.text),
              Text("dengan", style: TextStyle(fontWeight: FontWeight.bold),),
              Text(provider.namaObat2?.isNotEmpty == true
                  ? provider.namaObat2!
                  : _drug2Controller.text),
              Divider(height: 32),

              // Error
              if (provider.error.isNotEmpty)
                Text(provider.error,
                    style: TextStyle(color: Colors.red)),

              // Tidak ada interaksi
              if (provider.error.isEmpty &&
                  provider.interaksi.isEmpty)
                Text(
                  "Tidak ditemukan interaksi antara obat tersebut.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),

              // Ada interaksi
              if (provider.interaksi.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hasil Interaksi:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: provider.interaksi.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text("• ${provider.interaksi[index]}"),
                        );
                      },
                    ),
                  ],
                ),
            ],
          ],
        ),
      );
    },
  ),
),
    );
  }
}
