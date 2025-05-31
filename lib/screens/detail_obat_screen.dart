import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DetailObatScreen extends StatefulWidget {
  final String idObat;

  DetailObatScreen({required this.idObat});

  @override
  _DetailObatScreenState createState() => _DetailObatScreenState();
}

class _DetailObatScreenState extends State<DetailObatScreen> {
  String _detail = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final detail = await ApiService.getObatDetailById(widget.idObat);
      setState(() {
        _detail = detail;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _detail = 'Gagal mengambil data: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Obat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(child: Text(_detail)),
      ),
    );
  }
}
