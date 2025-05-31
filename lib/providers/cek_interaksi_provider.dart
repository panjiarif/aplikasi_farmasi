import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CekInteraksiProvider with ChangeNotifier {

  void reset() {
    print("Resetting CekInteraksiProvider state");
    isLoading = false;
    error = '';
    interaksi = [];
    namaObat1 = '';
    namaObat2 = '';
    notifyListeners();
  }

  final ApiService _apiService = ApiService();

  bool isLoading = false;
  String error = '';
  List<String> interaksi = [];
  String? namaObat1;
  String? namaObat2;

  Future<void> fetchInteraksi(String obat1, String obat2) async {
    isLoading = true;
    error = '';
    interaksi = [];
    namaObat1 = '';
    namaObat2 = '';
    notifyListeners();

    try {
      // Validasi panjang input
      if (obat1.trim().length < 3 || obat2.trim().length < 3) {
        error = "Nama obat harus minimal 3 huruf.";
        isLoading = false;
        notifyListeners();
        return;
      }

      final list1 = await _apiService.searchDrugByName(obat1);
      final list2 = await _apiService.searchDrugByName(obat2);

      if (list1.isEmpty || list2.isEmpty) {
        error = "Nama obat tidak ditemukan atau tidak valid.";
        isLoading = false;
        notifyListeners();
        return;
      }

      namaObat1 = list1.first['name']!;
      namaObat2 = list2.first['name']!;
      final id1 = list1.first['id']!;
      final id2 = list2.first['id']!;

      // Panggil API interaksi
      final rawInteraksi = await _apiService.getDrugInteractions([id1, id2]);

      if (rawInteraksi.isEmpty) {
        interaksi = [];
        isLoading = false;
        notifyListeners();
        return;
      }

      // Ambil hanya baris pertama dan parse ke format yang ramah pengguna
      final parts = rawInteraksi.first.split('\t');
      if (parts.length >= 3) {
        final tipe = parts[2] == 'CI'
            ? 'Dilarang digunakan bersama (Contraindicated)'
            : parts[2] == 'P'
                ? 'Perlu perhatian khusus (Precaution)'
                : parts[2];

        final mekanisme = parts.length > 3
            ? parts[3].replaceFirst('Target: ', '')
            : 'Tidak diketahui';

        interaksi = [
          "Tipe interaksi: $tipe",
          "Mekanisme terlibat: $mekanisme",
        ];
      } else {
        interaksi = ["Format interaksi tidak dikenali."];
      }
    } catch (e) {
      error = "Terjadi kesalahan: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
