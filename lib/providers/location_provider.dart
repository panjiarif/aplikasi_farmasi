import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';
import '../services/google_maps_service.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  List<Map<String, dynamic>> _nearbyPharmacies = [];

  Position? get currentPosition => _currentPosition;
  List<Map<String, dynamic>> get nearbyPharmacies => _nearbyPharmacies;

  Future<void> fetchLocationAndPharmacies() async {
    _currentPosition = await LocationService.getCurrentLocation();
    if (_currentPosition != null) {
      final placesService = GoogleMapsService();
      _nearbyPharmacies = await placesService.getNearbyPharmacies(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      notifyListeners();
    }
  }
}