import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cari_obat_provider.dart';
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

    // validasi input nama obat
    if (namaObat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama obat tidak boleh kosong')),
      );
      return;
    } else if (namaObat.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama obat minimal 3 huruf')),
      );
      return;
    } else if (namaObat.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama obat maksimal 50 huruf')),
      );
      return;
    }

    FocusScope.of(context).unfocus(); // Menyembunyikan keyboard
    provider.cariObat(namaObat);
    // _controller.clear(); // Mengosongkan input setelah pencarian
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
      appBar: AppBar(title: Text('Cari Obat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => _cariObat(context),
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nama Obat',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: provider.isLoading
                          ? null
                          : () => _cariObat(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (provider.isLoading)
              CircularProgressIndicator()
            else if (provider.error.isNotEmpty)
              Text(provider.error, style: TextStyle(color: Colors.red))
            else if (provider.hasil.isEmpty)
              Text('Tidak ada hasil.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.hasil.length,
                  itemBuilder: (context, index) {
                    final item = provider.hasil[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.nama),
                        subtitle: Text('ID: ${item.id}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailObatScreen(idObat: item.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
