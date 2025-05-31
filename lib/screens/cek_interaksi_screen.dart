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
    final provider = Provider.of<CekInteraksiProvider>(context, listen: false);
    provider.fetchInteraksi(
      _drug1Controller.text.trim(),
      _drug2Controller.text.trim(),
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
            return Column(
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
                  onPressed: provider.isLoading ? null : () => _cekInteraksi(context),
                  child: Text("Cek Interaksi"),
                ),
                SizedBox(height: 16),
                if (provider.isLoading)
                  Center(child: CircularProgressIndicator())
                else if (provider.error.isNotEmpty)
                  Text(provider.error, style: TextStyle(color: Colors.red))
                else if (provider.interaksi.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Interaksi antara:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("${provider.namaObat1}"),
                        Text("dengan"),
                        Text("${provider.namaObat2}"),
                        Divider(),
                        Text("Hasil Interaksi:", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.interaksi.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text("• ${provider.interaksi[index]}"),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
