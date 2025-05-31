import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://rest.kegg.jp";

  /// Mendapatkan interaksi antar beberapa ID obat dari KEGG
  /// Contoh input: ['D00564', 'D00100'] untuk ibuprofen & paracetamol
  Future<List<String>> getDrugInteractions(List<String> drugIds) async {
    final ids = drugIds.join("+"); // menjadi: D00564+D00100
    final url = Uri.parse('$baseUrl/ddi/$ids');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // KEGG mengembalikan teks biasa, jadi kita parse manual
        final body = response.body;
        final lines = body.split('\n');
        List<String> interactions = lines.where((line) => line.trim().isNotEmpty).toList();
        return interactions;
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  /// Mendapatkan daftar turunan dari nama obat seperti Ibuprofen
  Future<List<Map<String, String>>> searchDrugByName(String name) async {
    if (name.isEmpty) {
      throw Exception('Nama obat tidak boleh kosong');
    }

    final url = Uri.parse('$baseUrl/find/drug/$name');

    try {
      final response = await http.get(url);
      
      print('Searching for drug: $name'); // Debugging line
      print('Request URL: $url'); // Debugging line
      print('Response status: ${response.statusCode}'); // Debugging line
      print('Response body: ${response.body}'); // Debugging line

      if (response.statusCode == 200) {
        final lines = response.body.split('\n');
        List<Map<String, String>> results = [];

        for (var line in lines) {
          if (line.trim().isNotEmpty) {
            final parts = line.split('\t');
            final id = parts[0]; // dr:D00564
            final nama = parts.length > 1 ? parts[1] : '';
            results.add({'id': id.replaceFirst('dr:', ''), 'name': nama});
          }
        }

        return results;
      } else {
        throw Exception('Gagal mencari obat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan saat pencarian obat: $e');
    }
  }
}
