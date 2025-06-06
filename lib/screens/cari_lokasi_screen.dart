import 'dart:async';
import 'package:aplikasi_farmasi/widgets/waktu_dunia.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../providers/location_provider.dart';

class CariLokasiScreen extends StatefulWidget {
  @override
  _CariLokasiScreenState createState() => _CariLokasiScreenState();
}

class _CariLokasiScreenState extends State<CariLokasiScreen> {
  GoogleMapController? _mapController;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool _motionControlEnabled = false;
  LatLng? _currentLatLng;

  void _toggleMotionControl() {
    if (_motionControlEnabled) {
      _accelerometerSubscription?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Kontrol sensor dimatikan"),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red[400],
      ));
    } else {
      _accelerometerSubscription = accelerometerEvents.listen((event) {
        if (_currentLatLng == null || _mapController == null) return;

        final newLat = _currentLatLng!.latitude + event.y * 0.0001;
        final newLng = _currentLatLng!.longitude + event.x * 0.0001;

        _currentLatLng = LatLng(newLat, newLng);

        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentLatLng!),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Kontrol sensor diaktifkan"),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green[400]),
      );
    }

    setState(() {
      _motionControlEnabled = !_motionControlEnabled;
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apotek Terdekat',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Colors.green[400],
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_motionControlEnabled
                ? Icons.motion_photos_off
                : Icons.motion_photos_on),
            onPressed: _toggleMotionControl,
            tooltip: _motionControlEnabled
                ? "Matikan kontrol sensor"
                : "Aktifkan kontrol sensor",
          ),
        ],
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
          _currentLatLng ??=
              LatLng(pos.latitude, pos.longitude); // simpan posisi awal

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(pos.latitude, pos.longitude),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: MarkerId("me"),
                position: LatLng(pos.latitude, pos.longitude),
                infoWindow: InfoWindow(title: "Lokasi Saya"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const WaktuDunia();
            },
          );
        },
        backgroundColor: Colors.green[400],
        child: Icon(Icons.access_time),
      ),
    );
  }
}
