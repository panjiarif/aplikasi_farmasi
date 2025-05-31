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
    } else if (namaObat1.length < 3 || namaObat2.length < 3) {
      _showErrorDialog(context, "Nama obat minimal terdiri dari 3 huruf.");
      return;
    } else if (namaObat1.length > 50 || namaObat2.length > 50) {
      _showErrorDialog(
          context, "Nama obat terlalu panjang, maksimal 50 huruf.");
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        final provider = Provider.of<CekInteraksiProvider>(context, listen: false);
        provider.reset();
      });
    });
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
                    if (provider.isLoading)
                      Center(child: CircularProgressIndicator()),
                    if (!provider.isLoading) ...[
                      if (provider.error.isNotEmpty)
                        Text(provider.error,
                            style: TextStyle(color: Colors.red)),
                      if (provider.error.isEmpty &&
                          provider.interaksi.isEmpty &&
                          (provider.namaObat1?.isNotEmpty ?? false) &&
                          (provider.namaObat2?.isNotEmpty ?? false))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Interaksi antara:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(provider.namaObat1!),
                            Text("dengan"),
                            Text(provider.namaObat2!),
                            SizedBox(height: 8),
                            Divider(height: 32),
                            Text(
                              "Tidak ditemukan interaksi antara obat tersebut.",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15),
                            ),
                          ],
                        ),
                      if (provider.interaksi.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Interaksi antara:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(provider.namaObat1!),
                            Text("dengan"),
                            Text(provider.namaObat2!),
                            SizedBox(height: 16),
                            Divider(height: 32),
                            Text("Hasil Interaksi:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            ...provider.interaksi.map((item) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text("• $item",
                                      style: TextStyle(fontSize: 16)),
                                )),
                          ],
                        ),
                    ],
                  ],
                ),
              );
            },
          )),
    );
  }
}
