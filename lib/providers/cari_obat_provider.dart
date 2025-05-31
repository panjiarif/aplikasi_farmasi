import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class ObatItem {
  final String id;
  final String nama;

  ObatItem({required this.id, required this.nama});
}

class CariObatProvider with ChangeNotifier {

  void reset() {
    print("Resetting CekInteraksiProvider state");
    _isLoading = false;
    _error = '';
    _hasil = [];
    notifyListeners();
  }

  List<ObatItem> _hasil = [];
  bool _isLoading = false;
  String _error = '';

  List<ObatItem> get hasil => _hasil;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> cariObat(String query) async {
    _isLoading = true;
    _error = '';
    _hasil = [];
    notifyListeners();

    try {
      final data = await ApiService.searchObatByName(query);
      if (data.isEmpty) {
        _error = 'Obat tidak ditemukan.';
        _isLoading = false;
        notifyListeners();
        return;
      }
      _hasil = data.map((e) => ObatItem(id: e['id']!, nama: e['nama']!)).toList();
      _error = '';
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
