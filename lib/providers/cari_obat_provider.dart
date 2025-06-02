import 'package:flutter/foundation.dart';
import '../models/obat_detail_model.dart';
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

  // Detail Obat
  ObatDetail? _detailObat;
  bool _loading = false;

  Future<void> fetchDetailObat(String id) async {
    _loading = true;
    notifyListeners();
    try {
      _detailObat = await ApiService.getObatDetailParsed(id);
    } catch (e) {
      _detailObat = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  ObatDetail? get detailObat => _detailObat;
  bool get isLoadingDetailObat => _loading;

}
