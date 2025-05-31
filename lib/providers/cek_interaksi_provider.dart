import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CekInteraksiProvider with ChangeNotifier {
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
      final list1 = await _apiService.searchDrugByName(obat1);
      final list2 = await _apiService.searchDrugByName(obat2);

      if (list1.isEmpty || list2.isEmpty) {
        error = "Nama obat tidak ditemukan atau tidak valid.";
        notifyListeners();
        return;
      }

      namaObat1 = list1.first['name'];
      namaObat2 = list2.first['name'];

      // debug
      print('Obat 1: $namaObat1, Obat 2: $namaObat2');

      if (list1.isEmpty || list2.isEmpty) {
        error = 'Obat tidak ditemukan';
        isLoading = false;
        notifyListeners();
        return;
      }else{
        final id1 = list1.first['id']!;
        final id2 = list2.first['id']!;
        // debug
        print('ID Obat 1: $id1, ID Obat 2: $id2');
        interaksi = await _apiService.getDrugInteractions([id1, id2]);
      }

    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }

  }
}