import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyMasjidsScreen extends StatefulWidget {
  @override
  _NearbyMasjidsScreenState createState() => _NearbyMasjidsScreenState();
}

class _NearbyMasjidsScreenState extends State<NearbyMasjidsScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = LatLng(0, 0); // Default value
  List<Marker> _masjidMarkers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle this case
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle this case
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle this case
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Update the current location
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(
          _currentLocation, 15.0); // Move map to current location
    });

    // Fetch nearby mosques based on current location
    _getNearbyMasjids(position.latitude, position.longitude);
  }

  Future<void> _getNearbyMasjids(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://overpass-api.de/api/interpreter?data=[out:json];node["amenity"="place_of_worship"](around:50000,$latitude,$longitude);out;'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final elements = data['elements'] as List;

      setState(() {
        _masjidMarkers = elements.map<Marker>((element) {
          final lat = element['lat'];
          final lon = element['lon'];

          return Marker(
            point: LatLng(lat, lon),
            width: 80.0,
            height: 80.0,
            child: Icon(
              Icons.mosque,
              size: 20,
              color: Colors.blue, // Change the color if needed
            ),
          );
        }).toList();

        // Add a dummy marker to verify rendering
        _masjidMarkers.add(
          Marker(
            point: _currentLocation,
            width: 80.0,
            height: 80.0,
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        );
      });
    } else {
      throw Exception('Failed to load nearby mosques');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Masjids'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentLocation,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _masjidMarkers,
          ),
        ],
      ),
    );
  }
}
