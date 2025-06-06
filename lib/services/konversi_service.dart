import 'dart:convert';
import 'package:http/http.dart' as http;

class KonversiService {
  final String _apiKey = 'fca_live_p3rPtSqZuRtUVDA0qnS9BxD3Zp9h6zAlESdqcqai'; 
  final String _baseUrl = 'https://api.freecurrencyapi.com/v1';

  // Mendapatkan nilai tukar dasar dari IDR ke mata uang lain
  Future<Map<String, double>> getExchangeRates({required String baseCurrency, List<String>? currencies}) async {
    final String symbols = currencies?.join(',') ?? '';
    final Uri uri = Uri.parse('$_baseUrl/latest?apikey=$_apiKey&base_currency=$baseCurrency&currencies=$symbols');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null) {
          return Map<String, double>.from(data['data'].map((key, value) => MapEntry(key, value.toDouble())));
        } else {
          throw Exception('Data exchange rates tidak ditemukan.');
        }
      } else {
        // Tangani error API (misalnya API key tidak valid, limit terlampaui)
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception('Gagal memuat nilai tukar: ${response.statusCode} - ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Mendapatkan daftar semua mata uang yang didukung
  Future<Map<String, String>> getCurrencies() async {
    final Uri uri = Uri.parse('$_baseUrl/currencies?apikey=$_apiKey');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['data'] != null) {
          Map<String, String> currencyNames = {};
          data['data'].forEach((code, details) {
            currencyNames[code] = details['name'];
          });
          return currencyNames;
        } else {
          throw Exception('Data mata uang tidak ditemukan.');
        }
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception('Gagal memuat daftar mata uang: ${response.statusCode} - ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}