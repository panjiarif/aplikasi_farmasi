import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';

class CariLokasiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cari Lokasi Apotek"),
        backgroundColor: Colors.green[400],
        centerTitle: true,
      ),
      body: Consumer<LocationProvider>(
        builder: (context, provider, _) {
          if (provider.currentPosition == null) {
            provider.fetchLocationAndPharmacies();
            return Center(child: CircularProgressIndicator());
          }
      
          if (provider.nearbyPharmacies.isEmpty) {
            return Center(child: Text("Tidak ada apotek terdekat ditemukan."));
          }
      
          
      
          final pos = provider.currentPosition!;
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(pos.latitude, pos.longitude),
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: MarkerId("me"),
                position: LatLng(pos.latitude, pos.longitude),
                infoWindow: InfoWindow(title: "Lokasi Saya"),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              ),
              ...provider.nearbyPharmacies.map((place) {
                final location = place['geometry']['location'];
                return Marker(
                  markerId: MarkerId(place['place_id']),
                  position: LatLng(location['lat'], location['lng']),
                  infoWindow: InfoWindow(title: place['name']),
                );
              }).toSet(),
            },
          );
        },
      ),
    );
  }
}