import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleMapsService {
  final String apiKey = 'AIzaSyDWfWFQVRKtX4DfRxFB0eCGxWmj1BnRoyk';

  Future<List<Map<String, dynamic>>> getNearbyPharmacies(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=3000&type=pharmacy&key=$apiKey');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List).map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch pharmacies');
    }
  }
}